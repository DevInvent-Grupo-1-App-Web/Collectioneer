import 'dart:developer';

import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/models/media.dart';
import 'package:collectioneer/services/community_service.dart';
import 'package:collectioneer/services/media_service.dart';
import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/ui/screens/common/async_media_display.dart';
import 'package:collectioneer/ui/screens/community/create_collectible_screen.dart';
import 'package:collectioneer/ui/screens/community/view_collectible_screen.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppTopBar(
          title: "Feed",
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                log("Search button pressed");
              },
            )
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            children: [
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
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("username",
                          style: Theme.of(context).textTheme.labelSmall),
                      Text(
                        sourceItem.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
              ),
              AsyncMediaDisplay(
                collectibleId: sourceItem.id,
                height: 360,
                width: 360,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(sourceItem.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    overflow: TextOverflow.fade),
              ),
              const SizedBox(height: 32)
            ],
          ),
        ),
      ),
    );
  }
}


/*

                FutureBuilder<List<Media>>(
                  future: MediaService().getCollectibleMedia(sourceItem.id),
                  builder: (BuildContext context, AsyncSnapshot<List<Media>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if (snapshot.hasError){
                        log(snapshot.error.toString() + sourceItem.id.toString());
                        return Image.network("https://picsum.photos/120");
                      }
                      else {
                        return Image.network(
                          snapshot.data!.isNotEmpty ? snapshot.data![0].mediaURL : "https://picsum.photos/200",
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        );
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
*/