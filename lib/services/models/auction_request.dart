class AuctionRequest {
  final int communityId;
  final int auctioneerId;
  final int collectibleId;
  final double startingPrice;
  final DateTime deadline;

  AuctionRequest({
    required this.communityId,
    required this.auctioneerId,
    required this.collectibleId,
    required this.startingPrice,
    required this.deadline,
  });

  Map<String, dynamic> toJson() {
    return {
      'communityId': communityId,
      'auctioneerId': auctioneerId,
      'collectibleId': collectibleId,
      'startingPrice': startingPrice,
      'deadline': deadline.toUtc().toIso8601String(),
    };
  }
}
