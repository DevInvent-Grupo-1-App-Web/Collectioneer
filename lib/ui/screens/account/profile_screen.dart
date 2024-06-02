import 'package:collectioneer/models/user.dart';
import 'package:collectioneer/services/account_service.dart';
import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
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
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.labelSmall,
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
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text("Cambiar contraseña")),
                      TextButton(
                          onPressed: () {
                            UserPreferences().clearUserPreferences();
                            Navigator.pushNamed(context, '/splash');
                          },
                          child: const Text("Cerrar sesión")),
                    ],
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const AppBottomBar(selectedIndex: 3),
          );
        }
      },
    );
  }
}
