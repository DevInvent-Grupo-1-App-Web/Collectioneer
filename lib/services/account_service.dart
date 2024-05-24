import 'dart:convert';
import 'package:collectioneer/services/base_service.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:http/http.dart' as http;

class AccountService extends BaseService {

  static final AccountService _singleton = AccountService._internal();

  factory AccountService() {
    return _singleton;
  }

  AccountService._internal();

  Future<void> login(
    String username,
    String password,
  ) async {
    final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': username,
      'password': password,
    }),
  );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    final body = jsonDecode(response.body);
    final token = body['token'];

    UserPreferences().setUserToken(token);
  }

  Future<void> register(
      String email, String name, String password, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register-user'),
      body: {
        'email': email,
        'name': name,
        'password': password,
        'username': username,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register');
    }

    final body = jsonDecode(response.body);
    final token = body['token'];

    UserPreferences().setUserToken(token);
  }

  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      body: {
        'email': email,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send recovery email');
    }
  }

  Future<void> changePassword(
      String username, String newPassword, String recoveryToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/change-password'),
      body: {
        'username': username,
        'newPassword': newPassword,
        'recoveryToken': recoveryToken,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password');
    }
  }
}