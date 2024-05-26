import 'dart:ffi';

class Collectible {
  final int id;
  final String name;
  final int ownerId;
  final Float value;
  final String description;
  final bool isLinkedToProcess;
  final int? auctionId;
  final int? saleId;
  final int? exchangeId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Collectible({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.value,
    required this.description,
    required this.isLinkedToProcess,
    this.auctionId,
    this.saleId,
    this.exchangeId,
    required this.createdAt,
    required this.updatedAt,
  });

  Collectible.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        ownerId = json['owner_id'],
        value = json['value'],
        description = json['description'],
        isLinkedToProcess = json['is_linked_to_process'],
        auctionId = json['auction_id'],
        saleId = json['sale_id'],
        exchangeId = json['exchange_id'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']);
}