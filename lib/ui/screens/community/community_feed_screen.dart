import 'dart:developer';
import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/services/community_service.dart';
import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/ui/screens/common/community_feed_list.dart';
import 'package:collectioneer/ui/screens/common/feed_filter_chips.dart';
import 'package:collectioneer/ui/screens/community/create_collectible_screen.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  FeedItemType currentFeedItemType = FeedItemType.any;
  List<FeedItem> feedItems = [];

  void setFeedItemType(FeedItemType feedItemType) {
    setState(() {
      currentFeedItemType = feedItemType;
    });
  }

  List<FeedItem> filterFeedItems(List<FeedItem> feedItems) {
    if (currentFeedItemType == FeedItemType.any) {
      return feedItems;
    } else {
      return feedItems
          .where((element) => element.itemType == currentFeedItemType)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppTopBar(
          title: currentFeedItemType.toString(),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                log("Search button pressed");
              },
            )
          ],
        ),
        body: FutureBuilder<List<FeedItem>>(
          future: CommunityService().getCommunityFeed(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              feedItems = snapshot.data!;
              return Column(
                children: [
                  const SizedBox(height: 8),
                  FeedFilterChips(
                    setFeedItemType: setFeedItemType,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: CommunityFeedList(feedItems: filterFeedItems(feedItems)),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
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
