class FeedItem {
  final int id;
  final String title;
  final String description;
  FeedItem({ 
    required this.id,
    required this.title,
    required this.description,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      id: json['id'],
      title: json['name'],
      description: json['description']
    );
  }
}

enum FeedItemType {
  collectible,
  post
}