import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:collectioneer/services/base_service.dart';
import 'package:collectioneer/user_preferences.dart';

class MediaService extends BaseService {
  static final MediaService _singleton = MediaService._internal();

  factory MediaService() {
    return _singleton;
  }

  MediaService._internal();

  // Función para convertir la imagen a base64
  Future<String> imageToBase64(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    return base64Encode(bytes);
  }

  // Función para cargar los medios
  Future<void> uploadMedia(String mediaName, String imagePath, String contentType, int attachedToId, String attachedToType) async {
    final base64Image = await imageToBase64(imagePath);

    final response = await http.post(
      Uri.parse('$baseUrl/upload-media'),
      headers: <String, String>{
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'mediaName': mediaName,
        'content': base64Image,
        'contentType': contentType,
        'attachedToId': attachedToId,
        'attachedToType': attachedToType,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to upload media: ${response.body}');
    }
  }
}