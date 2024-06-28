import 'package:collectioneer/models/comment.dart';
import 'package:collectioneer/services/base_service.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:http/http.dart' as http;

class CommentService extends BaseService {
  static final CommentService _singleton = CommentService._internal();

  factory CommentService() {
    return _singleton;
  }

  CommentService._internal();

  Future<List<Comment>> getPosts(int commentableId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/comments/$commentableId'),
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
}