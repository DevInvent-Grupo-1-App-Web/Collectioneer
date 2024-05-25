import 'dart:developer';

import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/services/community_service.dart';
import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
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
            log("Add feed item");
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
    return _feed == null || _feed.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _feed.length,
            itemBuilder: (context, index) {
              return ConstrainedBox(
                constraints:
                    const BoxConstraints(minHeight: 120, maxHeight: 120),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        "https://picsum.photos/120",
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _feed[index].title,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Flexible(
                                  child: Text(
                                    _feed[index].description,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
