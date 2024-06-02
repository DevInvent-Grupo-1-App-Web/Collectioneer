import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:collectioneer/models/collectible.dart';

class CollectibleService {
  final String baseUrl;

  CollectibleService({required this.baseUrl});

  Future<List<Collectible>> fetchCollectibles({int? communityId, int? maxAmount, int? offset}) async {
    final queryParameters = {
      if (communityId != null) 'communityId': communityId.toString(),
      if (maxAmount != null) 'maxAmount': maxAmount.toString(),
      if (offset != null) 'offset': offset.toString(),
    };

    final uri = Uri.parse('$baseUrl/collectibles').replace(queryParameters: queryParameters);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> responseBody = json.decode(response.body);
      return responseBody.map((json) => Collectible.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load collectibles');
    }
  }

  Future<Collectible> fetchCollectibleById(int id) async {
    final uri = Uri.parse('$baseUrl/collectibles/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return Collectible.fromJson(responseBody);
    } else {
      throw Exception('Failed to load collectible');
    }
  }

  Future<Collectible> createCollectible(Collectible collectible) async {
    final uri = Uri.parse('$baseUrl/collectibles');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'communityId': collectible.communityId,
        'name': collectible.name,
        'description': collectible.description,
        'userId': collectible.ownerId,
        'value': collectible.value,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      return Collectible.fromJson(responseBody);
    } else {
      throw Exception('Failed to create collectible');
    }
  }
}
