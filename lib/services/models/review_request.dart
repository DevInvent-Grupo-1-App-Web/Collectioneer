class ReviewRequest {
  final int reviewerId;
  final int collectibleId;
  final String content;
  final int rating;

  ReviewRequest({
    required this.reviewerId,
    required this.collectibleId,
    required this.content,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'reviewerId': reviewerId,
      'collectibleId': collectibleId,
      'content': content,
      'rating': rating,
    };
  }
}