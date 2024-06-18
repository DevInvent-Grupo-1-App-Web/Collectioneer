import 'package:collectioneer/models/collectible.dart';
import 'package:flutter/material.dart';

class CollectibleInfo extends StatelessWidget {
  const CollectibleInfo(
      {super.key, required this.collectible, required this.onCommentTap});
  final Collectible collectible;
  final Function onCommentTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(collectible.name,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onSurface)),
        Text(
          '@${collectible.ownerId.toString()}',
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  "4.8",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSurface),
                ),
                Text(" (126)",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
            IconButton(
                onPressed: () {
                  onCommentTap(context);
                },
                icon: Icon(Icons.comment,
                    color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        Text(
          "Descripción",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
        ),
        const SizedBox(height: 8),
        Text(collectible.description,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}