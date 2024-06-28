class Comment {
  final int id;
  final String body;
  final int parentId;
  final int authorId;
  final String authorName;

  Comment({
    required this.id,
    required this.body,
    required this.parentId,
    required this.authorId,
    required this.authorName,
  });

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        body = json['body'],
        parentId = json['parentId'],
        authorId = json['authorId'],
        authorName = json['authorName'];
}