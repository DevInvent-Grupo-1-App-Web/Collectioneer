import 'package:flutter/material.dart';
import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/ui/screens/community/view_collectible_screen.dart';

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
    return GestureDetector(
      onTap: () {
        // UserPreferences().setCollectibleId(widget.sourceItem.id);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const ViewCollectibleScreen()));
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
              child: Text(widget.sourceItem.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  overflow: TextOverflow.fade,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
