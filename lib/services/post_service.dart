import 'dart:convert';

import 'package:collectioneer/models/post.dart';
import 'package:collectioneer/services/base_service.dart';
import 'package:collectioneer/services/models/post_request.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:http/http.dart' as http;

class PostService extends BaseService {
  Future<Post> getPost(int postId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/posts/$postId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      }
    );

    if (response.statusCode > 299) {
      throw Exception(response.body);
    }

    final body = jsonDecode(response.body);
    return Post.fromJson(body);
  }

  Future<Post> postPost(PostRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/new-post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode > 299) {
      throw Exception(response.body);
    }

    final body = jsonDecode(response.body);

    return Post.fromJson(body);
  }
}