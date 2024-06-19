import 'package:collectioneer/routes/app_routes.dart';
import 'package:collectioneer/ui/screens/startup/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF8C4E28),
      brightness: MediaQuery.of(context).platformBrightness,
    );

    return MaterialApp(
      title: 'Collectioneer',
      theme: ThemeData(
        colorScheme: colorScheme,
        primaryColor: colorScheme.primary,
        textTheme: GoogleFonts.soraTextTheme(),
      ),
      home: const Scaffold(
        body: Center(
          child: SplashScreen(),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: routes,
    );
  }
}
