class Collectible {
  final int id;
  final String name;
  final int ownerId;
  final double value;
  final String description;
  final bool isLinkedToProcess;
  final int? auctionId;
  final int? saleId;
  final int? exchangeId;
  final DateTime createdAt;
  final DateTime? updatedAt;

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
    this.updatedAt,
  });

  Collectible.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        ownerId = json['ownerId'], // Changed from 'owner_id'
        value = (json['value'] as num).toDouble(),
        description = json['description'],
        isLinkedToProcess = json['isLinkedToProcess'], // Changed from 'is_linked_to_process'
        auctionId = json['auctionId'], // Changed from 'auction_id'
        saleId = json['saleId'], // Changed from 'sale_id'
        exchangeId = json['exchangeId'], // Changed from 'exchange_id'
        createdAt = DateTime.parse(json['createdAt']), // Changed from 'created_at'
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null; // Changed from 'updated_at'
}