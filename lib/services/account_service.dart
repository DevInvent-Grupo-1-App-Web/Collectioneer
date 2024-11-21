import 'dart:convert';
import 'package:collectioneer/models/user.dart';
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
    UserPreferences().setUserId(body['userId']);
  }

  Future<void> register(
      String email, String name, String password, String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'name': name,
        'password': password,
        'username': username,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register');
    }

    final body = jsonDecode(response.body);
    final token = body['token'];

    UserPreferences().setUserToken(token);
    UserPreferences().setUserId(body['user']['id']);
  }

  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send recovery email');
    }
  }

  Future<void> changePassword(
      String username, String newPassword, String recoveryToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/change-password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'newPassword': newPassword,
        'recoveryToken': recoveryToken,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to change password');
    }
  }

  Future<User> getUserData(
    int id,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    return User.fromJson(jsonDecode(response.body));
  }
}
