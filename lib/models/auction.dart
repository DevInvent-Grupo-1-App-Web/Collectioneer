import 'dart:developer';

class Auction {
  final int id;
  final int communityId;
  final int auctioneerId;
  final int collectibleId;
  final int startingPrice;
  final DateTime deadline;
  final bool isOpen;
  final DateTime createdAt;
  final DateTime updatedAt;

  Auction({
    required this.id,
    required this.communityId,
    required this.auctioneerId,
    required this.collectibleId,
    required this.startingPrice,
    required this.deadline,
    required this.isOpen,
    required this.createdAt,
    required this.updatedAt,
  });

  Auction.fromJson(Map<String, dynamic> json) : this(
    id: json['id'],
    communityId: json['communityId'],
    auctioneerId: json['auctioneerId'],
    collectibleId: json['collectibleId'],
    startingPrice: json['startingPrice'],
    deadline: DateTime.parse(json['deadline']),
    isOpen: json['isOpen'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  bool isFinished() {
    log("Deadline: $deadline");
    return deadline.isBefore(DateTime.now());
  }

  String getRemainingTime() {
    final now = DateTime.now();
    final difference = deadline.difference(now);
    final days = difference.inDays;
    final hours = difference.inHours.remainder(24);
    
    if (days > 0) {
      return '${days}d ${hours}h';
    }

    
    final minutes = difference.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }

    final seconds = difference.inSeconds.remainder(60);

    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    
    return '${seconds}s';
  }
}
