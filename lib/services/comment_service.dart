import 'dart:convert';
import 'package:collectioneer/models/comment.dart';
import 'package:collectioneer/services/base_service.dart';
import 'package:collectioneer/services/models/comment_request.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:http/http.dart' as http;

class CommentService extends BaseService {
  static final CommentService _singleton = CommentService._internal();

  factory CommentService() {
    return _singleton;
  }

  CommentService._internal();

  Future<List<Comment>> getCollectibleComments(int commentableId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/collectible/$commentableId/comments'),
      headers: <String, String>{
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Comment.fromJson(item)).toList();
  }

  Future<void> postCollectibleComment(int collectibleId, CommentRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/collectible/$collectibleId/comments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode > 299) {
      throw Exception(response.body);
    }
  }

  Future<List<Comment>> getPostComments(int postId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/post/$postId/comments'),
      headers: <String, String>{
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
    );

    if (response.statusCode > 299) {
      throw Exception(response.body);
    }

    final List<dynamic> body = jsonDecode(response.body);
    return body.map((dynamic item) => Comment.fromJson(item)).toList();
  }

  Future<void> postPostComment(int postId, CommentRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/post/$postId/comment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode > 299) {
      throw Exception(response.body);
    }
  }
}