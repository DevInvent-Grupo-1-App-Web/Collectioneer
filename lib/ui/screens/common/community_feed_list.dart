import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/ui/screens/common/collectible_tile.dart';
import 'package:collectioneer/ui/screens/common/post_tile.dart';
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
        ? Center(
            child: Text(
              "Categoría vacía\nPrueba añadir algo para verlo aquí",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          )
        : ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: widget.feedItems.length,
            itemBuilder: (context, index) {
              return _buildFeedTile(
                  widget.feedItems[index], MediaQuery.of(context).size.width);
            },
          );
  }

  Widget _buildFeedTile(FeedItem item, double width) {
    switch (item.itemType) {
      case FeedItemType.post:
        return PostTile(sourceItem: item, width: width);
      case FeedItemType.collectible:
      case FeedItemType.auction:
        return CollectibleTile(sourceItem: item, width: width);
      default:
        return const Text("No items in this feed type.");
    }
  }
}
