import 'package:flutter/material.dart';
import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/ui/screens/common/async_media_display.dart';
import 'package:collectioneer/ui/screens/community/view_collectible_screen.dart';
import 'package:collectioneer/user_preferences.dart';

class CollectibleTile extends StatefulWidget {
  const CollectibleTile(
      {super.key, required this.sourceItem, required this.width});
  final FeedItem sourceItem;
  final double width;

  @override
  State<CollectibleTile> createState() => _CollectibleTileState();
}

class _CollectibleTileState extends State<CollectibleTile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UserPreferences().setCollectibleId(widget.sourceItem.id);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ViewCollectibleScreen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("username", style: Theme.of(context).textTheme.labelLarge),
              Text(
                widget.sourceItem.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
          ),
          AsyncMediaDisplay(
            collectibleId: widget.sourceItem.id,
            height: widget.width,
            width: widget.width,
          ),
          SizedBox(
            height: 96,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sourceItem.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                    overflow: TextOverflow.fade,
                  ),
                  Text(timeAgo(widget.sourceItem.createdAt), style: Theme.of(context).textTheme.labelSmall,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String timeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inDays > 365) {
      return '${difference.inDays ~/ 365} years ago';
    } else if (difference.inDays > 30) {
      return '${difference.inDays ~/ 30} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
