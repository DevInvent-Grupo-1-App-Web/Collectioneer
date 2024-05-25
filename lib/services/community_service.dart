import 'dart:convert';
import 'package:collectioneer/models/community.dart';
import 'package:collectioneer/services/base_service.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:http/http.dart' as http;

class CommunityService extends BaseService {
  static final CommunityService _singleton = CommunityService._internal();

  factory CommunityService() {
    return _singleton;
  }

  CommunityService._internal();

  Future<List<Community>> getCommunities() async {
    final response = await http.get(
      Uri.parse('$baseUrl/communities'),
      headers: <String, String>{
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Community.fromJson(item)).toList();
  }

  Future<void> createCommunity(String name, String description) async {
    final response = await http.post(
      Uri.parse('$baseUrl/new-community'),
      headers: <String, String>{
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        'userId': UserPreferences().getUserId(),
      }),
    );
    if (response.statusCode != 201) {
     throw Exception('Failed to create community: ${response.body}');
    }
    final body = jsonDecode(response.body);
    final communityId = body['id'];
    UserPreferences().setLatestActiveCommunity(communityId);
  }
}