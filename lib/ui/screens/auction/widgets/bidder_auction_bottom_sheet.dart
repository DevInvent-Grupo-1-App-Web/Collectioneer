import 'package:collectioneer/models/auction.dart';
import 'package:collectioneer/services/auction_service.dart';
import 'package:collectioneer/services/models/bid_request.dart';
import 'package:flutter/material.dart';

class BidderAuctionBottomSheet extends StatefulWidget {
  BidderAuctionBottomSheet({super.key, required this.auctionId});
  final int auctionId;
  late Auction auction;

  @override
  State<BidderAuctionBottomSheet> createState() =>
      _BidderAuctionBottomSheetState();
}

class _BidderAuctionBottomSheetState extends State<BidderAuctionBottomSheet> {
  final TextEditingController _bidController =
      TextEditingController(text: '1050');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuctionService().getAuction(auctionId: widget.auctionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error al mostrar: ${snapshot.error}');
          } else {
            if (snapshot.data == null) {
              return const Text('Sin datos disponibles.');
            }
            widget.auction = snapshot.data!;

            if (widget.auction.isFinished()) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceBright,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.transparent
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -4),
                    )
                  ],
                ),
                padding: const EdgeInsets.only(
                    top: 24, left: 32, right: 32, bottom: 24),
                width: MediaQuery.of(context).size.width,
                child: Text('Subasta finalizada', style: Theme.of(context).textTheme.titleLarge),
              );
            }


            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              padding: const EdgeInsets.only(
                  top: 24, left: 32, right: 32, bottom: 24),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                          Text('Tiempo restante',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
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
                  const SizedBox(height: 16),
                  SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Ofertar',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                ),
                                content: TextField(
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                  controller: _bidController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Ingresa tu oferta',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FilledButton(
                                    child: const Text('Ofertar'),
                                    onPressed: () {
                                      AuctionService()
                                          .postBid(
                                        request: BidRequest(
                                          auctionId: widget.auction.id,
                                          amount:
                                              double.parse(_bidController.text),
                                        ),
                                      )
                                          .then(
                                        (value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('¡Oferta enviada!'),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      ).catchError(
                                        (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(error.toString()),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Ofertar'),
                      ))
                ],
              ),
            );
          }
        });
  }
}
