import 'package:collectioneer/routes/app_routes.dart';
import 'package:collectioneer/services/account_service.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _recoveryTokenController =
      TextEditingController();

  Future<bool> _changePassword() async {
    final String username = _usernameController.text;
    final String newPassword = _newPasswordController.text;
    final String recoveryToken = _recoveryTokenController.text;

    try {
      await AccountService()
          .changePassword(username, newPassword, recoveryToken);
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change password: $e'),
          ),
        );
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Change Password',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    filled: true,
                  ),
                ),
                const SizedBox(height: 36.0),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    filled: true,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 36.0),
                TextFormField(
                  controller: _recoveryTokenController,
                  decoration: const InputDecoration(
                    labelText: 'Recovery Token',
                    filled: true,
                  ),
                ),
                const SizedBox(height: 36.0),
                FilledButton(
                  onPressed: () async {
                    if (await _changePassword()) {
                      navigateTo(AppRoutes.login);
                    }
                  },
                  child: const Text('Change Password'),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              child: Text(
                'Back to Login',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }
}
