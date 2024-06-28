import 'dart:convert';
import 'dart:developer';

import 'package:collectioneer/models/review.dart';
import 'package:collectioneer/services/base_service.dart';
import 'package:collectioneer/services/models/review_request.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:http/http.dart' as http;

class ReviewService extends BaseService {
  Future<Review> postReview(ReviewRequest reviewRequest) async {
    final response = await http.post(
      Uri.parse('$baseUrl/collectible/new-review'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
      body: jsonEncode(reviewRequest.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final Map<String, dynamic> body = jsonDecode(response.body);
    return Review.fromJson(body);
  }

  Future<List<Review>> getReviewsForCollectible(int collectibleId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/collectible/$collectibleId/reviews'),
      headers: <String, String>{
        'Authorization': 'Bearer ${UserPreferences().getUserToken()}',
      },
    );
    
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final List<dynamic> body = jsonDecode(response.body);

    return body.map((dynamic item) => Review.fromJson(item)).toList();

  }
}