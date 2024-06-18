import 'dart:developer';

import 'package:collectioneer/services/community_service.dart';
import 'package:collectioneer/ui/screens/common/app_bottombar.dart';
import 'package:collectioneer/ui/screens/common/app_topbar.dart';
import 'package:collectioneer/user_preferences.dart';
import 'package:flutter/material.dart';

class CommunitiesListScreen extends StatelessWidget {
  const CommunitiesListScreen({super.key});

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
        appBar: const AppTopBar(title: "Comunidades"),
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
  List _userCommunities = [];
  List _filteredCommunities = [];
  final _communityService = CommunityService();
  final _searchController = TextEditingController();


   void _loadCommunities([String query = '']) async {
    final communities = await _communityService.searchCommunities(query);
    final userCommunities = await _communityService.getUserCommunities();
    setState(() {
      _communities = communities;
      _userCommunities = userCommunities;
      _filteredCommunities = _communities;
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
void _filterCommunities() {
  final query = _searchController.text;
  if (query.isNotEmpty) {
    _loadCommunities(query);
  }
}

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCommunities);
    _loadCommunities(); // Carga todas las comunidades al inicio
  }

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Buscar comunidades',
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
      Expanded(
        child: _filteredCommunities.isEmpty
            ? const Center(child: CircularProgressIndicator.adaptive())
            : ListView.builder(
                itemCount: _filteredCommunities.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(_filteredCommunities[index].name),
                          subtitle: Text(_filteredCommunities[index].description),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton(
                            onPressed: _isUserInCommunity(_filteredCommunities[index].id.toString())
                                ? () {
                                  UserPreferences().setLatestActiveCommunity(_filteredCommunities[index].id);
                                  Navigator.pushNamed(context, '/home');
                                }
                                : () {
                                    _joinCommunity(_filteredCommunities[index].id.toString());
                                    Navigator.pushNamed(context, '/home');
                                  },
                            child: const Text('Entrar'),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    ],
  );
}
}