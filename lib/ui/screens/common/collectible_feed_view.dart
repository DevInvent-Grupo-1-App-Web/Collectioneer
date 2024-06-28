import 'dart:async';

import 'package:flutter/material.dart';
import 'package:collectioneer/models/feed_item.dart';
import 'package:collectioneer/ui/screens/common/async_media_display.dart';
import 'package:collectioneer/ui/screens/community/view_collectible_screen.dart';
import 'package:collectioneer/user_preferences.dart';

class CollectibleFeedView extends StatefulWidget {
  const CollectibleFeedView(
      {super.key, required this.sourceItem, required this.width});
  final FeedItem sourceItem;
  final double width;

  @override
  State<CollectibleFeedView> createState() => _CollectibleFeedViewState();
}

class _CollectibleFeedViewState extends State<CollectibleFeedView> with AutomaticKeepAliveClientMixin {

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
              Text("username", style: Theme.of(context).textTheme.labelSmall),
              Text(
                widget.sourceItem.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.sourceItem.description,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
                overflow: TextOverflow.fade),
          )
        ],
      ),
    );
  }
}