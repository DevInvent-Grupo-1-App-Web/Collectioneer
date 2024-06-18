class Media {
  final int id;
  final int uploaderId;
  final String mediaName;
  final String mediaURL;
  final String createdAt;
  final String updatedAt;

  Media({
    required this.id,
    required this.uploaderId,
    required this.mediaName,
    required this.mediaURL,
    required this.createdAt,
    required this.updatedAt,
  });

  Media.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        uploaderId = json['uploaderId'],
        mediaName = json['mediaName'],
        mediaURL = json['mediaURL'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];
}