import 'package:collectioneer/models/collectible.dart';
import 'package:collectioneer/services/collectible_service.dart';
import 'package:flutter/material.dart';
import 'package:collectioneer/ui/screens/community/view_collectible_screen.dart';
import 'package:collectioneer/user_preferences.dart';

class SearchCollectiblesGlobalScreen extends StatefulWidget {
  const SearchCollectiblesGlobalScreen({super.key});

  @override
  _SearchCollectiblesGlobalScreenState createState() => _SearchCollectiblesGlobalScreenState();

}
class _SearchCollectiblesGlobalScreenState extends State<SearchCollectiblesGlobalScreen> {
  List<Collectible> collectibles = [];
  String searchQuery = '';
  bool isLoading = false;
  final CollectibleService collectibleService = CollectibleService();

  @override
  void initState() {
    super.initState();
    fetchAndSetCollectibles();
  }

  Future<void> fetchAndSetCollectibles() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedCollectibles = await collectibleService.fetchCollectibles(searchQuery, page: 1, pageSize: 10); // Ajusta los parámetros según sea necesario
      setState(() {
        collectibles = fetchedCollectibles;
      });
    } catch (error) {
      // Manejar el error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCollectibles = collectibles.where((collectible) {
      return collectible.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Coleccionables'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                fetchAndSetCollectibles();
              },
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredCollectibles.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(filteredCollectibles[index].name),
                          onTap: () {
                            // TODO: Implementar la navegación a la pantalla de vista de coleccionable
                            UserPreferences().setActiveElement(index);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ViewCollectibleScreen(),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}