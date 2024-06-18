import 'dart:developer';

import 'package:collectioneer/routes/app_routes.dart';
import 'package:collectioneer/services/account_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isPasswordVisible = false;

  Future<bool> _register() async {
    final String username = _usernameController.text;
    final String name = _nameController.text;
    final String password = _passwordController.text;
    final String email = _emailController.text;

    try {
      await AccountService().register(email, name, password, username);
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register: $e'),
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
              'Regístrate',
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
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombres', filled: true),
                ),
                const SizedBox(height: 36.0),
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
                  controller: _emailController,
                  decoration:
                      const InputDecoration(labelText: 'Correo', filled: true),
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
                const SizedBox(height: 36.0),
                FilledButton(
                  onPressed: () async {
                    try {
                      if (await _register()) {
                        if (mounted) {
                          navigateTo(AppRoutes.home);
                        }
                      }
                    } catch (e) {
                      log('Registro fallido: $e');
                    }
                  },
                  child: const Text('Registrarse'),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              child: Text(
                'Inicia sesión en una cuenta existente',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
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
