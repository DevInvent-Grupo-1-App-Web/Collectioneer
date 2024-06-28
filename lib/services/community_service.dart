import 'dart:convert';
import 'dart:developer';
import 'package:collectioneer/models/community.dart';
import 'package:collectioneer/models/feed_item.dart';
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

    log("Communities found: ${response.body}");

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



  Future<void> joinCommunity(String communityId) async {
  // Obtén las comunidades del usuario
  final userCommunitiesResponse = await http.get(
    Uri.parse('$baseUrl/communities/${UserPreferences().getUserId()}'),
    headers: <String, String>{
      'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
    },
  );

  if (userCommunitiesResponse.statusCode != 200) {
    throw Exception('Failed to get user communities: ${userCommunitiesResponse.body}');
  }

  final List<dynamic> userCommunities = jsonDecode(userCommunitiesResponse.body);

  // Verifica si el usuario ya está en la comunidad
  for (var community in userCommunities) {
    if (community['id'].toString() == communityId) {
      throw Exception('User is already in this community');
    }
  }

  // Si el usuario no está en la comunidad, únete a la comunidad
  final response = await http.post(
    Uri.parse('$baseUrl/join-community'),
    headers: <String, String>{
      'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'communityId': communityId,
      'userId': UserPreferences().getUserId(),
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to join community: ${response.body}');
  }
}

  Future<List<Community>> getUserCommunities() async {
    final response = await http.get(
      Uri.parse('$baseUrl/communities/${UserPreferences().getUserId()}'),
      headers: <String, String>{
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get user communities: ${response.body}');
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Community.fromJson(item)).toList();
  }
  
Future<List<Community>> searchCommunities(String query) async {
  Uri uri;
  // Si el término de búsqueda está vacío, ajusta la URI para obtener todas las comunidades
  if (query.isEmpty) {
    uri = Uri.parse('$baseUrl/communities');
  } else {
    uri = Uri.parse('$baseUrl/search/communities?SearchTerm=${Uri.encodeComponent(query)}');
  }

  try {
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to search communities. Status code: ${response.statusCode}, Response: ${response.body}');
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Community.fromJson(item)).toList();
  } catch (e) {
    throw Exception('Failed to search communities due to: $e');
  }
}

  Future<List<FeedItem>> getCommunityFeed() async {
    final response = await http.get(
      Uri.parse('$baseUrl/${UserPreferences().getLatestActiveCommunity()}/feed'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
    
    log(response.body.toString());

    final List<dynamic> body = jsonDecode(response.body);
    final List<FeedItem> feedItems =
        body.map((dynamic item) => FeedItem.fromJson(item)).toList();
    log("Feed items: ${feedItems.length}");
    return feedItems;
  }

  Future<List<FeedItem>> searchInCommunity(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/community/${UserPreferences().getLatestActiveCommunity()}/search?query=$query'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
    );

    if (response.statusCode > 299) {
      log('$baseUrl/community/${UserPreferences().getLatestActiveCommunity()}/search&query=$query');
      log('Failed to search in community: ${response.body}');
      throw Exception(response.body);
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => FeedItem.fromJson(item)).toList();
  }
}
