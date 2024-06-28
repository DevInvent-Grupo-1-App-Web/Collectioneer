class Review {
  final int id;
  final int userId;
  final int collectibleId;
  final String content;
  final int rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.userId,
    required this.collectibleId,
    required this.content,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      collectibleId: json['collectibleId'],
      content: json['content'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

}