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
  final double rating;
  final int reviewCount;
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
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    this.updatedAt,
  });

  Collectible.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        ownerId = json['ownerId'],
        value = (json['value'] as num).toDouble(),
        description = json['description'],
        isLinkedToProcess = json['isLinkedToProcess'],
        auctionId = json['auctionId'],
        saleId = json['saleId'],
        exchangeId = json['exchangeId'],
        rating = (json['rating'] as num).toDouble(),
        reviewCount = json['reviewCount'],
        createdAt = DateTime.parse(json['createdAt']).toLocal(),
        updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']).toLocal() : null;
}