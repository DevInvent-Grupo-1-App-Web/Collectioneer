import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:flutter/material.dart';

class CommunityFeedScreen extends StatelessWidget {
  const CommunityFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: "Feed"),
      body: Center(
        child: Text('Your content here'),
      ),
      bottomNavigationBar: AppBottomBar(selectedIndex: 0),
    );
  }
}