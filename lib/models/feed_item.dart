class FeedItem {
  final int id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String username;
  final int userId;
  final int communityId;
  final String communityName;
  final FeedItemType itemType;
  FeedItem({ 
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.username,
    required this.userId,
    required this.communityId,
    required this.communityName,
    required this.itemType
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      id: json['id'],
      title: json['title'],
      description: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      username: json['username'],
      userId: json['userId'],
      communityId: json['communityId'],
      communityName: json['communityName'],
      itemType: castType(json['itemType'])
    );
  }
}

FeedItemType castType(String itemType) {
  switch (itemType) {
    case 'Collectible':
      return FeedItemType.collectible;
    case 'Sale':
      return FeedItemType.sale;
    case 'Auction':
      return FeedItemType.auction;
    case 'Exchange':
      return FeedItemType.exchange;
    default:
      return FeedItemType.post;
  }
}

enum FeedItemType {
  collectible,
  post,
  auction,
  sale,
  exchange,
  any,
  favourite
}