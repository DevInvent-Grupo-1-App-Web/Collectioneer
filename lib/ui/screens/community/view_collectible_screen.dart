import 'package:collectioneer/models/auction.dart';
import 'package:collectioneer/models/bid.dart';
import 'package:collectioneer/ui/screens/auction/view_auction_screen.dart';
import 'package:collectioneer/ui/screens/common/async_media_display.dart';
import 'package:collectioneer/ui/screens/common/auction_bottom_sheet.dart';
import 'package:collectioneer/ui/screens/common/change_to_auction_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:collectioneer/models/collectible.dart';
import 'package:collectioneer/services/collectible_service.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:collectioneer/ui/screens/common/interactions_bottom_sheet.dart';

class ViewCollectibleScreen extends StatefulWidget {
  const ViewCollectibleScreen({super.key});

  @override
  State<ViewCollectibleScreen> createState() => _ViewCollectibleScreenState();
}

class _ViewCollectibleScreenState extends State<ViewCollectibleScreen> {
  final int collectibleId = UserPreferences().getCollectibleId();
  late Collectible collectible;
  bool isLoading = true;
  late Auction auction;
  late Bid bid;

  @override
  Widget build(BuildContext context) {
    double height = 300;
    double width = MediaQuery.of(context).size.width - 64;

    return FutureBuilder(
      future: CollectibleService().getCollectible(collectibleId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              appBar: AppTopBar(title: "Loading...", allowBack: true),
              body: Center(
                child: CircularProgressIndicator(),
              ));
        } else if (snapshot.hasError) {
          return Text('Error on displaying: ${snapshot.error}');
        } else {
          if (snapshot.data == null) {
            _exitInError("No data found.", context);
          }
          collectible = snapshot.data!;
          
          return Scaffold(
              appBar: const AppTopBar(
                title: "Collectible info",
                allowBack: true,
              ),
              body: Padding(
                  padding: const EdgeInsets.all(32),
                  child: ListView(
                    children: [
                      AsyncMediaDisplay(
                          collectibleId: collectibleId,
                          height: height,
                          width: width),
                      const SizedBox(height: 16),
                      CollectibleInfo(
                          collectible: collectible,
                          onCommentTap: _showBottomSheet)
                    ],
                  )),
              floatingActionButton: collectible.ownerId ==
                      UserPreferences().getUserId()
                  ? FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ViewAuctionScreen(collectibleId: collectibleId),
                          ),
                        );
                      },
                      child: const Icon(Icons.edit),
                    )
                  : null,
              bottomSheet: _buildBottomSheet());
        }
      },
    );
  }

  Widget? _buildBottomSheet() {
    if (collectible.auctionId != null) {
      return AuctionBottomSheet(auctionId: collectible.auctionId!);
    }else{
      DateTime deadline = auction.deadline ?? DateTime.now().add(Duration(days: 7));
      double initialBid = bid.amount ?? 100.0;

    return ChangeToAuctionBottomSheet(
      deadline: deadline,
      initialBid: initialBid,
    );
    }
  
  }

  void _exitInError(String error, BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showBottomSheet(BuildContext context) async {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxHeight = screenHeight * 0.8;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const CommentsBottomSheet());
      },
    );
  }
}

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
        Text(collectible.name, style: Theme.of(context).textTheme.titleLarge),
        Text(
          collectible.ownerId.toString(),
          style: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  "4.8",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(" (126)",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      onCommentTap(context);
                    },
                    icon: Icon(Icons.comment,
                        color: Theme.of(context).colorScheme.primary))
              ],
            ),
          ],
        ),
        const Divider(
          height: 24,
        ),
        Text("Descripción", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(collectible.description,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
