import 'package:collectioneer/models/auction.dart';
import 'package:collectioneer/services/auction_service.dart';
import 'package:collectioneer/services/models/bid_request.dart';
import 'package:flutter/material.dart';

class AuctionBottomSheet extends StatefulWidget {
  AuctionBottomSheet({super.key, required this.auctionId});
  final int auctionId;
  late Auction auction;

  @override
  State<AuctionBottomSheet> createState() => _AuctionBottomSheetState();
}

class _AuctionBottomSheetState extends State<AuctionBottomSheet> {
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
            return Text('Error on displaying: ${snapshot.error}');
          } else {
            if (snapshot.data == null) {
              return const Text('No data found.');
            }
            widget.auction = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -4),
                  )
                ],
              ),
              padding: const EdgeInsets.only(
                  top: 24, left: 32, right: 32, bottom: 24),
              width: MediaQuery.of(context).size.width,
              height: 160,
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
                              style: Theme.of(context).textTheme.labelMedium),
                          Text(
                              '\$ ${widget.auction.startingPrice.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headlineSmall),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tiempo restante',
                              style: Theme.of(context).textTheme.labelMedium),
                          Text(widget.auction.getRemainingTime(),
                              style: Theme.of(context).textTheme.headlineSmall),
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
                                title: const Text('Ofertar'),
                                content: TextField(
                                  controller: _bidController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter your bid',
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
                                              content: Text(
                                                  'Bid placed successfully'),
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
