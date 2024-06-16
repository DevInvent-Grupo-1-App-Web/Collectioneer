class Bid {
  final int id;
  final int auctionId;
  final double amount;
  final DateTime createdAt;

  Bid({
    required this.id,
    required this.auctionId,
    required this.amount,
    required this.createdAt,
  });
  
  Bid.fromJson(Map<String, dynamic> json) : this(
    id: json['id'],
    auctionId: json['auctionId'],
    amount: json['amount'] != null && json['amount'] is num ? json['amount'].toDouble() : null,
    createdAt: DateTime.parse(json['createdAt']),
  );
}