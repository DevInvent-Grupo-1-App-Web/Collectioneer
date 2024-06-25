class PostRequest {
  final String title;
  final String content;
  final int communityId;
  final int authorId;

  PostRequest({
    required this.title,
    required this.content,
    required this.communityId,
    required this.authorId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'communityId': communityId,
      'authorId': authorId,
    };
  }
}