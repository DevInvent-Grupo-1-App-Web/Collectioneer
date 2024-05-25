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
}