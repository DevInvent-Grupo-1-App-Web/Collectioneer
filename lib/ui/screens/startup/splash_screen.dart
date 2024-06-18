import 'package:collectioneer/routes/app_routes.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  String loadUserPreferences() {
    UserPreferences prefs = UserPreferences();

    bool hasUserToken = prefs.hasUserToken();

    if (hasUserToken) {
        return AppRoutes.communities;
    }

    return AppRoutes.login;
  }

  @override
  Widget build(BuildContext context) {
    
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, loadUserPreferences());
    });


    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Text(
            'Collectioneer',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        )
    );
  }
}