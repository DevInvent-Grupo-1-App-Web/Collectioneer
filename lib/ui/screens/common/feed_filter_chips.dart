import 'package:flutter/material.dart';

class FeedFilterChips extends StatefulWidget {
  const FeedFilterChips({super.key});

  @override
  State<FeedFilterChips> createState() => _FeedFilterChipsState();
}

class _FeedFilterChipsState extends State<FeedFilterChips> {
  static const List<String> _filters = [
    "Todo",
    "Coleccionables",
    "Posts",
    "Subastas",
    "Ventas"
  ];
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 4.0), // Adjust this value as needed
              child: ChoiceChip(
                label: Text(_filters[index]),
                selected: _selectedFilter == index,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = selected ? index : 0;
                  });
                },
              ),
            );
          },
        ));
  }
}