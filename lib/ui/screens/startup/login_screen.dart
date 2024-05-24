import 'dart:developer';

import 'package:collectioneer/routes/app_routes.dart';
import 'package:collectioneer/services/account_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;

  Future<bool> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    try {
      await AccountService().login(username, password);
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to login: $e'),
          ),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Login'),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: !isPasswordVisible, // Use isPasswordVisible here
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (await _login()) {
                    Navigator.pushNamed(context, AppRoutes.home);
                  }
                } catch (e) {
                  log('Login failed: $e');
                }
              },
              child: const Text('Login'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
