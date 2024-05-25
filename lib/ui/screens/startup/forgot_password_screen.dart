import 'dart:developer';

import 'package:collectioneer/routes/app_routes.dart';
import 'package:collectioneer/services/account_service.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  Future<bool> _sendRecoveryEmail() async {
    final String email = _emailController.text;

    try {
      await AccountService().forgotPassword(email);
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar el correo de recuperación: $e'),
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
                    '¿Olvidaste tu contraseña?',
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
                  Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: 'Correo electrónico', filled: true),
                      ),
                      const SizedBox(height: 36.0),
                      FilledButton(
                        onPressed: () async {
                          try {
                            if (await _sendRecoveryEmail()) {
                              Navigator.pushNamed(
                                  context, AppRoutes.changePassword);
                            }
                          } catch (e) {
                            log('Envío de correo de recuperación fallido: $e');
                          }
                        },
                        child: const Text('Enviar correo de recuperación'),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: Text(
                      'Iniciar sesión de nuevo',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ])));
  }
}
