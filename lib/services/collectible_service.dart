import 'dart:convert';
import 'package:collectioneer/models/collectible.dart';
import 'package:collectioneer/services/base_service.dart';
import 'package:collectioneer/services/models/collectible_request.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:http/http.dart' as http;

class CollectibleService extends BaseService {
  static final CollectibleService _singleton = CollectibleService._internal();

  factory CollectibleService() {
    return _singleton;
  }

  CollectibleService._internal();

  Future<Collectible> createCollectible(CollectibleRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/collectibles'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
      body: jsonEncode(<String, dynamic>{
        'communityId': UserPreferences().getLatestActiveCommunity(),
        'name': request.name,
        'description': request.description,
        'userId': UserPreferences().getUserId(),
        'value': request.value,
      }),
    );
    
    if (response.statusCode > 299) {
      throw Exception('Failed to create collectible: ${response.body}');
    }

    return Collectible.fromJson(jsonDecode(response.body));
  }

  Future<Collectible> getCollectible(int collectibleId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/collectibles/$collectibleId'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load collectible: ${response.body}');
      }
      Collectible collectible = Collectible.fromJson(jsonDecode(response.body));
      return collectible;
    } catch (e) {
      rethrow;
    }
  }
}
