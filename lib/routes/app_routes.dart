import 'package:collectioneer/ui/screens/account/profile_screen.dart';
import 'package:collectioneer/ui/screens/communications/notifications_screen.dart';
import 'package:collectioneer/ui/screens/communities_list_screen.dart';
import 'package:collectioneer/ui/screens/community/create_community_screen.dart';
import 'package:collectioneer/ui/screens/community/community_feed_screen.dart';
import 'package:collectioneer/ui/screens/community/create_collectible_screen.dart';
import 'package:collectioneer/ui/screens/community/view_collectible_screen.dart';
import 'package:collectioneer/ui/screens/startup/change_password_screen.dart';
import 'package:collectioneer/ui/screens/startup/forgot_password_screen.dart';
import 'package:collectioneer/ui/screens/startup/login_screen.dart';
import 'package:collectioneer/ui/screens/startup/register_screen.dart';
import 'package:collectioneer/ui/screens/startup/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:collectioneer/ui/screens/auction/convert_an_aucttion_screen.dart';
import 'package:collectioneer/ui/screens/auction/participation_auction.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  AppRoutes.splash: (context) => const SplashScreen(),
  AppRoutes.login: (context) => const LoginScreen(),
  AppRoutes.register: (context) => const RegisterScreen(),
  AppRoutes.forgotPassword: (context) => const ForgotPasswordScreen(),
  AppRoutes.changePassword: (context) => const ChangePasswordScreen(),
  AppRoutes.home: (context) => const CommunityFeedScreen(),
  AppRoutes.notifications: (context) => const NotificationsScreen(),
  AppRoutes.communities: (context) => const CommunitiesListScreen(),
  AppRoutes.account: (context) => const ProfileScreen(),
  AppRoutes.createCollectible: (context) => const CreateCollectibleScreen(),
  AppRoutes.viewCollectible: (context) => const ViewCollectibleScreen(),
  AppRoutes.community: (context) => const CreateCommunityScreen(),
  AppRoutes.collectible: (context) => const ConvertAnAuctionScreen(),
  AppRoutes.auction: (context) => const AuctionParticipationScreen(),
};

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String communities = '/communities';
  static const String account = '/account';
  static const String createCollectible = '/create-collectible';
  static const String viewCollectible = '/view-collectible';
  static const String community = '/add-community';
  static const String collectible = '/collectible';
  static const String auction = '/auction';
}
