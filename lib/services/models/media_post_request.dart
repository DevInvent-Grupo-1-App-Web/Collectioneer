class MediaPostRequest {
  final String mediaName;
  final String content;
  final String contentType;
  final int attachedToId;
  final String attachedToType;

  MediaPostRequest({
    required this.mediaName,
    required this.content,
    required this.contentType,
    required this.attachedToId,
    required this.attachedToType,
  });

  Map<String, dynamic> toJson() {
    return {
      'mediaName': mediaName,
      'content': content,
      'contentType': contentType,
      'attachedToId': attachedToId,
      'attachedToType': attachedToType,
    };
  }
}