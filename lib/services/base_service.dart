import 'package:collectioneer/user_preferences.dart';

class BaseService {
  final String baseUrl = 'https://collectioneer-app-hee9ezd0bxh6c2es.eastus2-01.azurewebsites.net';

  // Method to add the token to the headers
  Map<String, String> getHeaders() {
    final String token = "${UserPreferences().getUserToken()}";

    return {
      'Authorization': 'Bearer $token',
    };
  }
}
