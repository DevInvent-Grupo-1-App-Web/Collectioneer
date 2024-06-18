import 'package:collectioneer/user_preferences.dart';

class BaseService {
  final String baseUrl = 'https://dev.api.mycollectioneer.net';

  // Method to add the token to the headers
  Map<String, String> getHeaders() {
    final String token = "${UserPreferences().getUserToken()}";

    return {
      'Authorization': 'Bearer $token',
    };
  }
}