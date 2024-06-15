import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/services/community_service.dart';
import 'package:collectioneer/services/media_service.dart';
import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/ui/screens/community/create_collectible_screen.dart';
import 'package:collectioneer/ui/screens/community/view_collectible_screen.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppTopBar(title: "Feed"),
        body: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              FeedSearchBar(),
              SizedBox(height: 24),
              FeedFilterChips(),
              SizedBox(height: 16),
              Expanded(child: CommunityFeedList()),
            ],
          ),
        ),
        bottomNavigationBar: const AppBottomBar(selectedIndex: 0),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateCollectibleScreen()));
          },
          child: const Icon(Icons.add),
        ));
  }
}

class FeedSearchBar extends StatefulWidget {
  const FeedSearchBar({super.key});

  @override
  State<FeedSearchBar> createState() => _FeedSearchBarState();
}

class _FeedSearchBarState extends State<FeedSearchBar> {
  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        hintText: "Buscar en el feed",
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}

class FeedFilterChips extends StatefulWidget {
  const FeedFilterChips({super.key});

  @override
  State<FeedFilterChips> createState() => _FeedFilterChipsState();
}

class _FeedFilterChipsState extends State<FeedFilterChips> {
  static const List<String> _filters = [
    "Todo",
    "Coleccionables",
    "Posts",
    "Subastas",
    "Ventas"
  ];
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 4.0), // Adjust this value as needed
              child: ChoiceChip(
                label: Text(_filters[index]),
                selected: _selectedFilter == index,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = selected ? index : 0;
                  });
                },
              ),
            );
          },
        ));
  }
}

class CommunityFeedList extends StatefulWidget {
  const CommunityFeedList({super.key});

  @override
  State<CommunityFeedList> createState() => _CommunityFeedListState();
}

class _CommunityFeedListState extends State<CommunityFeedList> {
  List<FeedItem> _feed = [];
  final _communityService = CommunityService();

  void _loadFeed() async {
    final feed = await _communityService.getCommunityFeed();
    setState(() {
      _feed = feed;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  @override
  Widget build(BuildContext context) {
    return _feed.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _feed.length,
            itemBuilder: (context, index) {
              return CollectibleFeedView(sourceItem: _feed[index]);
            },
          );
  }
}

class CollectibleFeedView extends StatelessWidget {
  const CollectibleFeedView({super.key, required this.sourceItem});
  final FeedItem sourceItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          UserPreferences().setCollectibleId(sourceItem.id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ViewCollectibleScreen()));
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 120, maxHeight: 120),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<List<String>>(
                  future: MediaService().getCollectibleMedia(sourceItem.id),
                  builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // or some placeholder
                    } else {
                      if (snapshot.hasError){
                        return Image.network("https://picsum.photos/120");
                      }
                      else {
                        return Image.network(snapshot.data![0]);
                      }
                    }
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sourceItem.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Flexible(
                            child: Text(
                              sourceItem.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
