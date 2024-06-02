import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: "Notifications"),
      body: Center(
        child: Text('Your content here'),
      ),
      bottomNavigationBar: AppBottomBar(selectedIndex: 1),
    );
  }
}