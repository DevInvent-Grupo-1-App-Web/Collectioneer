import 'package:collectioneer/services/media_service.dart';
import 'package:flutter/material.dart';

class AsyncMediaDisplay extends StatefulWidget {
  const AsyncMediaDisplay(
      {super.key,
      required this.collectibleId,
      required this.height,
      required this.width});
  final int collectibleId;
  final double height;
  final double width;

  @override
  State<AsyncMediaDisplay> createState() => _AsyncMediaDisplayState();
}

class _AsyncMediaDisplayState extends State<AsyncMediaDisplay> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MediaService().getCollectibleMedia(widget.collectibleId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: widget.height,
            child: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error),
                Text("An error occurred while fetching media"),
              ],
            )));
        } else {
          final collectibleMedia = snapshot.data;
          if (collectibleMedia == null || collectibleMedia.isEmpty) {
            return SizedBox(
                height: widget.height,
                width: widget.width,
                child: const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.clear),
                    Text("No media found for this collectible."),
                  ],
                )));
          } else {
            final mediaURLs = collectibleMedia.map((e) => e.mediaURL).toList();
            return mediaReel(mediaURLs);
          }
        }
      },
    );
  }

  Widget mediaReel(List<String> mediaURLs) {
    return SizedBox(
      height: widget.height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mediaURLs.length,
        itemBuilder: (context, index) {
          return Image.network(
            mediaURLs[index],
            height: widget.height,
            width: widget.width,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
