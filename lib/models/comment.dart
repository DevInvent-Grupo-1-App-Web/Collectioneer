class Comment {
  final int id;
  final String body;
  final int authorId;
  final String authorName;
  final String profileURI;

  Comment({
    required this.id,
    required this.body,
    required this.authorId,
    required this.authorName,
    required this.profileURI,
  });

  Comment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        authorId = json['userId'],
        authorName = json['username'],
        body = json['content'],
        profileURI = json['profileURI'];
}