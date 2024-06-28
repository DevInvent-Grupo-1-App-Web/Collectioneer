class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int authorId;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.authorId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      authorId: json['authorId'],
    );
  }
}
