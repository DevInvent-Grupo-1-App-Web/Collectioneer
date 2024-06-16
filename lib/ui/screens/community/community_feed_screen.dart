import 'dart:developer';
import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/services/community_service.dart';
import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/ui/screens/common/collectible_feed_view.dart';
import 'package:collectioneer/ui/screens/common/community_feed_list.dart';
import 'package:collectioneer/ui/screens/common/feed_filter_chips.dart';
import 'package:collectioneer/ui/screens/community/create_collectible_screen.dart';
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
        body: const Column(
          children: [
            SizedBox(height: 8),
            FeedFilterChips(),
            SizedBox(height: 8),
            Expanded(
              child: CommunityFeedList(),
            ),
          ],
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