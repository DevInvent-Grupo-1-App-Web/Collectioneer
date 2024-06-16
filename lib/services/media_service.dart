import 'dart:convert';
import 'dart:developer';
import 'package:collectioneer/models/media.dart';
import 'package:collectioneer/services/models/media_post_request.dart';
import 'package:http/http.dart' as http;
import 'package:collectioneer/services/base_service.dart';
import 'package:collectioneer/user_preferences.dart';

class MediaService extends BaseService {
  static final MediaService _singleton = MediaService._internal();

  factory MediaService() {
    return _singleton;
  }

  MediaService._internal();

  // Función para cargar los medios
  Future<void> uploadMedia(String mediaName, String imageData, String contentType, int attachedToId, String attachedToType) async {
    final MediaPostRequest mediaPostRequest = MediaPostRequest(
      mediaName: mediaName,
      content: imageData,
      contentType: contentType,
      attachedToId: attachedToId,
      attachedToType: attachedToType,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/upload-media'),
      headers: <String, String>{
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(mediaPostRequest.toJson()),
    );

    if (response.statusCode > 299) {
      log(mediaPostRequest.toJson().toString());
      throw Exception('Failed to upload media: ${response.body}');
    }

    log('Media uploaded successfully:${response.statusCode}');
  }

  Future<List<Media>> getCollectibleMedia(int collectibleId) async {
      final response = await http.get(
        Uri.parse('$baseUrl/media?ElementId=$collectibleId&ElementType=collectible'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
        },
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load media: ${response.body}');
      }

      final List<dynamic> media = jsonDecode(response.body);
      return media.map((e) => Media.fromJson(e)).toList();
  }
}