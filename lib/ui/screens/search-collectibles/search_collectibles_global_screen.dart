import 'package:flutter/material.dart';
import 'package:collectioneer/ui/screens/community/view_collectible_screen.dart';
import 'package:collectioneer/user_preferences.dart';

class SearchCollectiblesGlobalScreen extends StatefulWidget {
  const SearchCollectiblesGlobalScreen({super.key});

  @override
  _SearchCollectiblesGlobalScreenState createState() => _SearchCollectiblesGlobalScreenState();

}

class _SearchCollectiblesGlobalScreenState extends State<SearchCollectiblesGlobalScreen> {
  final List<String> collectibles = [
    'Collectible 1',
    'Collectible 2',
    'Collectible 3',
    'Collectible 4',
    'Collectible 5',
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredCollectibles = collectibles.where((collectible) {
      return collectible.toLowerCase().contains(searchQuery.toLowerCase());
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
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCollectibles.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(filteredCollectibles[index]),
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