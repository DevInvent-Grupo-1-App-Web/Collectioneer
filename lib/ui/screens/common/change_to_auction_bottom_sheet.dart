import 'package:collectioneer/services/auction_service.dart';
import 'package:collectioneer/services/models/auction_request.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ChangeToAuctionBottomSheet extends StatefulWidget {
  const ChangeToAuctionBottomSheet({
    super.key,
  });

  @override
  State<ChangeToAuctionBottomSheet> createState() =>
      _ChangeToAuctionBottomSheetState();
}

class _ChangeToAuctionBottomSheetState
    extends State<ChangeToAuctionBottomSheet> {
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _initialPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Iniciar subasta',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                TextFormField(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  controller: _initialPriceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: const InputDecoration(
                      labelText: 'Precio inicial', filled: true),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        // ignore: use_build_context_synchronously
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        final DateTime finalDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        String formattedDate = DateFormat('yyyy-MM-dd – kk:mm')
                            .format(finalDateTime);
                        _deadlineController.text = formattedDate;
                      }
                    }
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      controller: _deadlineController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha de cierre',
                        filled: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                    onPressed: () async {
                      await setAuction();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Iniciar subasta')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future setAuction() async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd – kk:mm');
    DateTime? deadline;
    try {
      deadline = formatter.parse(_deadlineController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, ingrese una fecha válida.'),
        ),
      );
      return;
    }

    final AuctionRequest request = AuctionRequest(
      communityId: UserPreferences().getLatestActiveCommunity()!,
      auctioneerId: UserPreferences().getUserId(),
      collectibleId: UserPreferences().getActiveElement(),
      startingPrice: double.parse(_initialPriceController.text),
      deadline: DateTime.parse(deadline!.toIso8601String()),
    );

    try {
      await AuctionService().postAuction(request: request);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
