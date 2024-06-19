import 'package:collectioneer/models/auction.dart';
import 'package:collectioneer/services/auction_service.dart';
import 'package:flutter/material.dart';

class OwnerAuctionBottomSheet extends StatefulWidget {
  OwnerAuctionBottomSheet({super.key});
  final int auctionId = 1;
  late final Auction auction;

  @override
  State<OwnerAuctionBottomSheet> createState() =>
      _OwnerAuctionBottomSheetState();
}

class _OwnerAuctionBottomSheetState extends State<OwnerAuctionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuctionService().getAuction(auctionId: widget.auctionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error on displaying: ${snapshot.error}');
          } else {
            if (snapshot.data == null) {
              return const Text('No data found.');
            }
            widget.auction = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceBright,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.transparent
                        : Theme.of(context).colorScheme.onSurface,
                    blurRadius: 4,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              padding: const EdgeInsets.only(
                  top: 24, left: 32, right: 32, bottom: 24),
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Última oferta',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                          Text(
                            '\$ ${widget.auction.startingPrice.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tiempo restante',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                          Text(
                            widget.auction.getRemainingTime(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        });
  }
}
