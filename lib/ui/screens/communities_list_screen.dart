import 'package:collectioneer/services/community_service.dart';
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/add-community');
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
  late final VoidCallback _searchListener;

  @override
  void initState() {
    super.initState();
    _searchListener = _filterCommunities;
    _searchController.addListener(_searchListener);
    _loadCommunities();
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    super.dispose();
  }

  void _loadCommunities([String query = '']) async {
    final communities = await _communityService.searchCommunities(query);
    final userCommunities = await _communityService.getUserCommunities();
    if (mounted) {
      setState(() {
        _communities = communities;
        _userCommunities = userCommunities;
        _filteredCommunities = _communities;
      });
    }
  }

  bool _isUserInCommunity(String communityId) {
    for (var community in _userCommunities) {
      if (community.id.toString() == communityId) {
        return true;
      }
    }
    return false;
  }

  bool _isUserOwner(String communityId) {
    // Implementa la lógica para verificar si el usuario es el propietario
    // Esto es solo un ejemplo, ajusta según tu lógica de negocio
    for (var community in _userCommunities) {
      if (community.id.toString() == communityId && community.isOwner) {
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

  void _deleteCommunity(String communityId) async {
    try {
      await _communityService.deleteCommunity(communityId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Community deleted'),
          ),
        );
        _loadCommunities();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete community: $e'),
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

  void _showDeleteConfirmationDialog(String communityId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar esta comunidad?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCommunity(communityId);
              },
            ),
          ],
        );
      },
    );
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
                            trailing: _isUserOwner(_filteredCommunities[index].id.toString())
                                ? IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(_filteredCommunities[index].id.toString());
                                    },
                                  )
                                : null,
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
                                      UserPreferences().setLatestActiveCommunity(_filteredCommunities[index].id);
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