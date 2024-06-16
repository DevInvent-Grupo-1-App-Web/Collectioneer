import 'package:collectioneer/models/collectible.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/ui/screens/common/async_media_display.dart';
import 'package:flutter/material.dart';

class ViewAuctionScreen extends StatefulWidget {
  const ViewAuctionScreen({super.key, required this.collectibleId});
  final int collectibleId;

  @override
  State<ViewAuctionScreen> createState() => _ViewAuctionScreenState();
}

class _ViewAuctionScreenState extends State<ViewAuctionScreen> {
  Collectible? collectible;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppTopBar(
          title: "Auction Details",
          allowBack: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ListView(children: [
              AsyncMediaDisplay(
                  collectibleId: widget.collectibleId, height: 300, width: MediaQuery.of(context).size.width - 64),
              const SizedBox(height: 16),
                  Text("Collectible Name",
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    "@userhandle",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            "4.8",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(" (126)",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant)),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                _showBottomSheet(context: context);
                              },
                              icon: Icon(Icons.comment,
                                  color: Theme.of(context).colorScheme.primary))
                        ],
                      ),
                    ],
                  ),
            ]
            )
        )
    );

  }

  void _showBottomSheet({required BuildContext context}) {
    
  }

  
}
