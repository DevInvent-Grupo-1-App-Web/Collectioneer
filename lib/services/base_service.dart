import 'package:collectioneer/user_preferences.dart';

class BaseService {
  final String baseUrl = 'https://collectioneer-e2abg4ephpf4h6cb.eastus2-01.azurewebsites.net';

  // Method to add the token to the headers
  Map<String, String> getHeaders() {
    final String token = "${UserPreferences().getUserToken()}";

    return {
      'Authorization': 'Bearer $token',
    };
  }
}
