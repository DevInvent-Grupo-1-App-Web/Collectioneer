class CommentRequest {
  final int authorId;
  final String content;

  CommentRequest({
    required this.authorId,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'authorId': authorId,
      'content': content,
    };
  }
}