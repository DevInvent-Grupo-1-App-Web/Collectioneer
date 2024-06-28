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
            content: Text('Inicio de sesión fallido: $e'),
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
              'Iniciar sesión',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Column(
              children: [
                TextFormField(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre de usuario', filled: true),
                ),
                const SizedBox(height: 36.0),
                TextFormField(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  controller: _passwordController,
                  obscureText: !isPasswordVisible, // Use isPasswordVisible here
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    filled: true,
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
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.forgotPassword);
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 36.0),
                FilledButton(
                  onPressed: () async {
                    try {
                      if (await _login()) {
                        navigateTo(AppRoutes.home);
                      }
                    } catch (e) {
                      log('Inicio de sesión fallido: $e');
                    }
                  },
                  child: const Text('Iniciar sesión'),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.register);
              },
              child: Text(
                'Crea una nueva cuenta.',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }
}
