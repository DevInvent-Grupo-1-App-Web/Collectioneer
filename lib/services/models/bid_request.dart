import 'package:collectioneer/user_preferences.dart';

class BidRequest {
  final int auctionId;
  final double amount;

  BidRequest({
    required this.auctionId,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'auctionId': auctionId,
      'bidderId': UserPreferences().getUserId(),
      'amount': amount,
    };
  }

}