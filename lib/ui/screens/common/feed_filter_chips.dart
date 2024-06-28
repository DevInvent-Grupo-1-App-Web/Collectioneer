import 'package:collectioneer/models/feed_item.dart';
import 'package:flutter/material.dart';

class FeedFilterChips extends StatefulWidget {
  const FeedFilterChips({super.key, required this.setFeedItemType});
  
  final Function setFeedItemType;

  @override
  State<FeedFilterChips> createState() => _FeedFilterChipsState();
}

class _FeedFilterChipsState extends State<FeedFilterChips> {
  static const List<String> _filters = [
    "Todo",
    "Coleccionables",
    "Posts",
    "Subastas",
    "Ventas",
    "Guardados"
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
                    switch (_selectedFilter) {
                      case 0:
                        widget.setFeedItemType(FeedItemType.any);
                        break;
                      case 1:
                        widget.setFeedItemType(FeedItemType.collectible);
                        break;
                      case 2:
                        widget.setFeedItemType(FeedItemType.post);
                        break;
                      case 3:
                        widget.setFeedItemType(FeedItemType.auction);
                        break;
                      case 4:
                        widget.setFeedItemType(FeedItemType.sale);
                        break;
                      case 5:
                        widget.setFeedItemType(FeedItemType.favourite);
                        break;
                      default:
                        widget.setFeedItemType(FeedItemType.any);
                    }
                  });
                },
              ),
            );
          },
        ));
  }
}