import 'package:collectioneer/models/user.dart';
import 'package:collectioneer/services/account_service.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/ui/screens/startup/forgot_password_screen.dart';
import 'package:collectioneer/ui/screens/startup/splash_screen.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<User> getUserData() async {
    User user =
        await AccountService().getUserData(UserPreferences().getUserId());
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getUserData(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          User user = snapshot.data!;
          return Scaffold(
            appBar: const AppTopBar(title: "Profile"),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/placeholder.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      FilledButton(
                          onPressed: () {}, child: const Text("Editar perfil")),
                      FilledButton.tonal(
                          onPressed: () {},
                          child: const Text("Mis coleccionables")),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text("Cambiar contraseña")),
                      TextButton(
                          onPressed: () {
                            UserPreferences().clearUserPreferences();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SplashScreen())
                            );
                          },
                          child: const Text("Cerrar sesión")),
                          TextButton(onPressed: () { 
                            // Show modal dialog to confirm account deletion
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Eliminar cuenta"),
                                  content: const Text("¿Estás seguro de que quieres eliminar tu cuenta?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        //AccountService().deleteAccount(UserPreferences().getUserId());
                                        UserPreferences().clearUserPreferences();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => const SplashScreen())
                                        );
                                      },
                                      child: const Text("Eliminar cuenta"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }, child: const Text("Eliminar cuenta")),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
