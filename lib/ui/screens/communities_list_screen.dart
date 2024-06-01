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
            Navigator.pushNamed(context, '/add-community');
            log("Add community");
          },
          child: const Icon(Icons.add),
        ));
  }
}

class CommunityList extends StatefulWidget {
  const CommunityList({super.key});

  @override
  State<CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  List _communities = [];
  List _userCommunities = [];
  final _communityService = CommunityService();

  void _loadCommunities() async {
    final communities = await _communityService.getCommunities();
    final userCommunities = await _communityService.getUserCommunities();
    setState(() {
      _communities = communities;
      _userCommunities = userCommunities;
    });
  }

  bool _isUserInCommunity(String communityId) {
  for (var community in _userCommunities) {
    if (community.id.toString() == communityId) {
      return true;
    }
  }
  return false;
}

  void _joinCommunity(String communityId) async {
  try {
    await _communityService.joinCommunity(communityId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Joined community'),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join community: $e'),
        ),
      );
    }
  }
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
                  onPressed: _isUserInCommunity(_communities[index].id.toString())
                      ? null
                      : () {
                          _joinCommunity(_communities[index].id.toString());
                        },
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
