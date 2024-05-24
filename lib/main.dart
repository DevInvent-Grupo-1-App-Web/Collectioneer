import 'package:collectioneer/ui/screens/account/profile_screen.dart';
import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/ui/screens/communications/notifications_screen.dart';
import 'package:collectioneer/ui/screens/communities_list_screen.dart';
import 'package:collectioneer/ui/screens/community/community_feed_screen.dart';
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
        appBar: AppTopBar(
          title: 'Collectioneer',
          allowBack: false,
        ),
        body: Center(
          child: Text('Your content here'),
        ),
        bottomNavigationBar: AppBottomBar(selectedIndex: 1,),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/startup': (context) => const SplashScreen(),
        '/home': (context) => const CommunityFeedScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/communities': (context) => const CommunitiesListScreen(),
        '/account': (context) => const ProfileScreen(),
      },
    );
  }
}
