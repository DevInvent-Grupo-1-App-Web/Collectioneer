import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/services/community_service.dart';
import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/community_feed_list.dart';
import 'package:collectioneer/ui/screens/common/feed_filter_chips.dart';
import 'package:collectioneer/ui/screens/community/create_collectible_screen.dart';
import 'package:collectioneer/ui/screens/community/create_post_screen.dart';
import 'package:collectioneer/ui/screens/community/view_collectible_screen.dart';
import 'package:collectioneer/ui/screens/community/view_post_screen.dart';
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
    feedItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));

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
        appBar: AppBar(
          title: const Text("Feed"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: SearchInCommunity(),
                );
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
                    child: CommunityFeedList(
                        feedItems: filterFeedItems(feedItems)),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        bottomNavigationBar: const AppBottomBar(selectedIndex: 0),
        floatingActionButton: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      FloatingActionButton.small(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
        heroTag: null,
        child: const Icon(
          Icons.post_add
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      FloatingActionButton(           
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateCollectibleScreen())
          );
        },
        heroTag: null,           
        child: const Icon(
          Icons.add
        ),
      )
    ]
  )
  );
  }
}

class SearchInCommunity extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: CommunityService().searchInCommunity(query),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } 
        if (snapshot.hasData) {
          final List<FeedItem> feedItems = snapshot.data!;
          return ListView.builder(
            itemCount: feedItems.length,
            itemBuilder: (context, index) {
              final FeedItem feedItem = feedItems[index];
              return ListTile(
                title: Text(feedItem.title),
                subtitle: Text(feedItem.description, maxLines: 1, 
                overflow: TextOverflow.ellipsis),
                onTap: () {
                  UserPreferences().setActiveElement(feedItem.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        if (feedItem.itemType == FeedItemType.post) {
                          return const ViewPostScreen();
                        }
                          return const ViewCollectibleScreen();
                        
                      }
                      ),
                    );
                }
                    ,
                  );
                },
              );
            }
            
            return const Center(child: CircularProgressIndicator());
            }
          );
      }
      
  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Search for something'));
  }
}


