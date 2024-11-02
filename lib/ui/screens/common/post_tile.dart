import 'package:collectioneer/ui/screens/community/view_post_screen.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:collectioneer/models/feed_item.dart';

class PostTile extends StatefulWidget {
  const PostTile({super.key, required this.sourceItem, required this.width});
  final FeedItem sourceItem;
  final double width;

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        UserPreferences().setActiveElement(widget.sourceItem.id);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ViewPostScreen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.sourceItem.username, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),),
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
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sourceItem.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                    softWrap: true,
                  ),
                  const SizedBox(height: 8.0),
                  Text(timeAgo(widget.sourceItem.createdAt), style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String timeAgo(DateTime time) {
    // return formatted as YYYY-MM-DD HH:MM:SS
    //return time.toString();


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
