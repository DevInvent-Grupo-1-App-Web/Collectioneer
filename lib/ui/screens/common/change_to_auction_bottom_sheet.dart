import 'package:flutter/material.dart';

class ChangeToAuctionBottomSheet extends StatefulWidget {
  final DateTime deadline;
  final double initialBid;

  const ChangeToAuctionBottomSheet({
    Key? key,
    required this.deadline,
    required this.initialBid,
  }) : super(key: key);

  @override
  State<ChangeToAuctionBottomSheet> createState() => _ChangeToAuctionBottomSheetState();
}

class _ChangeToAuctionBottomSheetState extends State<ChangeToAuctionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Cambiar a Subasta',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Fecha Límite:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            '${widget.deadline.day}/${widget.deadline.month}/${widget.deadline.year}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Puja Inicial:',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            '\$${widget.initialBid.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
