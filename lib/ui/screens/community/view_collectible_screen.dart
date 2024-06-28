import 'package:collectioneer/models/element_type.dart';
import 'package:collectioneer/ui/screens/auction/widgets/owner_auction_bottom_sheet.dart';
import 'package:collectioneer/ui/screens/common/async_media_display.dart';
import 'package:collectioneer/ui/screens/auction/widgets/bidder_auction_bottom_sheet.dart';
import 'package:collectioneer/ui/screens/common/change_to_auction_bottom_sheet.dart';
import 'package:collectioneer/ui/screens/common/collectible_info.dart';
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
  final int collectibleId = UserPreferences().getActiveElement();
  late Collectible collectible;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    double height = 300;
    double width = MediaQuery.of(context).size.width - 64;

    return FutureBuilder(
      future: CollectibleService().getCollectible(collectibleId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              appBar: AppTopBar(
                title: "Cargando...",
                allowBack: true,
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ));
        } else if (snapshot.hasError) {
          return Text('Error al mostrar: ${snapshot.error}');
        } else {
          if (snapshot.data == null) {
            _exitInError("Sin datos disponibles", context);
          }
          collectible = snapshot.data!;

          return Scaffold(
            appBar: AppTopBar(title: _pageName(collectible), allowBack: true),
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
                        onCommentTap: _showCommentBottomSheet)
                  ],
                )),
            floatingActionButton:
                (collectible.ownerId == UserPreferences().getUserId() &&
                        !collectible.isLinkedToProcess)
                    ? FloatingActionButton(
                        onPressed: () {
                          _summonEditionBottomSheet(context);
                        },
                        child: const Icon(Icons.edit),
                      )
                    : null,
            bottomSheet: _buildBottomSheet(),
          );
        }
      },
    );
  }

  void _summonEditionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const ChangeToAuctionBottomSheet(),
        );
      },
    );
  }

  void _exitInError(String error, BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error),
      duration: const Duration(seconds: 2),
    ));
  }

  void _showCommentBottomSheet(BuildContext context) async {
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
            child: const InteractionBottomSheet(type: ElementType.collectible));
      },
    );
  }

  String _pageName(Collectible sourceItem) {
    if (!collectible.isLinkedToProcess) {
      return "Coleccionable";
    }

    if (collectible.auctionId != null) {
      return "Subasta";
    }

    if (collectible.saleId != null) {
      return "Venta";
    }

    return "Error";
  }

  Widget _switchUserBottomSheet(BuildContext context) {
    if (collectible.ownerId == UserPreferences().getUserId()) {
      return OwnerAuctionBottomSheet(auctionId: collectible.auctionId!);
    } else {
      return BidderAuctionBottomSheet(auctionId: collectible.auctionId!);
    }
  }

  Widget? _buildBottomSheet() {
    if (!collectible.isLinkedToProcess) {
      return null;
    } else {
      if (collectible.auctionId != null) {
        return _switchUserBottomSheet(context);
      } else if (collectible.saleId != null) {
        return null;
      } else {
        return null;
      }
    }
  }
}
