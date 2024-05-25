import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: "Profile"),
      body: Center(
        child: Text('Your content here'),
      ),
      bottomNavigationBar: AppBottomBar(selectedIndex: 3),
    );
  }
}