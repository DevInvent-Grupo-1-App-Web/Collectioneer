import 'package:collectioneer/routes/app_routes.dart';
import 'package:flutter/material.dart';

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  State<AppBottomBar> createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: widget.selectedIndex == 0
                ? const Icon(Icons.home)
                : const Icon(Icons.home_outlined),
            onPressed: () => {
              Navigator.pushNamed(context, AppRoutes.home),
            },
            iconSize: 30.0,
          ),
          IconButton(
            icon: widget.selectedIndex == 1
                ? const Icon(Icons.notifications)
                : const Icon(Icons.notifications_outlined),
            onPressed: () => {
              Navigator.pushNamed(context, AppRoutes.notifications),
            },
            iconSize: 30.0,
          ),
          IconButton(
            icon: widget.selectedIndex == 2
                ? const Icon(Icons.group)
                : const Icon(Icons.group_outlined),
            onPressed: () => {
              Navigator.pushNamed(context, AppRoutes.communities),
            },
            iconSize: 30.0,
          ),
          IconButton(
            icon: widget.selectedIndex == 3
                ? const Icon(Icons.person)
                : const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.account),
            iconSize: 30.0,
          ),
        ],
      ),
    );
  }
}
