import 'dart:developer';

import 'package:collectioneer/services/community_service.dart';
import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:flutter/material.dart';

class CommunitiesListScreen extends StatelessWidget {
  const CommunitiesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppTopBar(title: "Communities"),
        body: const Center(
          child: CommunityList(),
        ),
        bottomNavigationBar: const AppBottomBar(selectedIndex: 2),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            log("Add community");
          },
          child: const Icon(Icons.add),
        )
      );
  }
}

class CommunityList extends StatefulWidget {
  const CommunityList({super.key});

  @override
  State<CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  List _communities = [];
  final _communityService = CommunityService();

  void _loadCommunities() async {
    final communities = await _communityService.getCommunities();
    setState(() {
      _communities = communities;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _communities.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              ListTile(
                title: Text(_communities[index].name),
                subtitle: Text(_communities[index].description),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Join'),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
