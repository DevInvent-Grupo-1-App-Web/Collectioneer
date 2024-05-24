import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:flutter/material.dart';

class CommunitiesListScreen extends StatefulWidget {
  const CommunitiesListScreen({super.key});

  @override
  State<CommunitiesListScreen> createState() => _CommunitiesListScreenState();
}

class _CommunitiesListScreenState extends State<CommunitiesListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppTopBar(title: "Communities"),
      body: Center(
        child: Text('Your content here'),
      ),
      bottomNavigationBar: AppBottomBar(selectedIndex: 2),
    );
  }
}