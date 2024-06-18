import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/ui/screens/common/collectible_tile.dart';
import 'package:collectioneer/ui/screens/common/post_feed_view.dart';
import 'package:flutter/material.dart';

class CommunityFeedList extends StatefulWidget {
  const CommunityFeedList({super.key, required this.feedItems});
  final List<FeedItem> feedItems;

  @override
  State<CommunityFeedList> createState() => _CommunityFeedListState();
}

class _CommunityFeedListState extends State<CommunityFeedList> {

  @override
  Widget build(BuildContext context) {
    return widget.feedItems.isEmpty
        ? const Center(
            child: Text(
              "No items in this feed type :(\nAdd some items!",
              textAlign: TextAlign.center,
              ),
        )
        : ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 32),
            itemCount: widget.feedItems.length,
            itemBuilder: (context, index) {
              return _buildFeedTile(widget.feedItems[index], MediaQuery.of(context).size.width);
            },
          );
  }

  Widget _buildFeedTile(FeedItem item, double width) {
    switch (item.itemType) {
      case FeedItemType.post:
        return PostFeedView(sourceItem: item, width: width);
      case FeedItemType.collectible:
      case FeedItemType.auction:
        return CollectibleTile(sourceItem: item, width: width);
      default:
        return const Text("No items in this feed type.");
    }
  }
}
