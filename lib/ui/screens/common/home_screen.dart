import 'package:flutter/material.dart';
import 'package:collectioneer/ui/screens/account/profile_screen.dart';
import 'package:collectioneer/ui/screens/communications/notifications_screen.dart';
import 'package:collectioneer/ui/screens/communities_list_screen.dart';
import 'package:collectioneer/ui/screens/community/community_feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    CommunityFeedScreen(),
    NotificationsScreen(),
    CommunitiesListScreen(),
    ProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _options =const [
     
    BottomNavigationBarItem(
    icon: Icon(Icons.home_outlined, size: 30.0),
    activeIcon: Icon(Icons.home, size: 30.0),
    label: '', // Se establece una cadena vacía para ocultar el nombre
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.notifications_outlined, size: 30.0),
    activeIcon: Icon(Icons.notifications, size: 30.0),
    label: '', // Se establece una cadena vacía para ocultar el nombre
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.group_outlined, size: 30.0),
    activeIcon: Icon(Icons.group, size: 30.0),
    label: '', // Se establece una cadena vacía para ocultar el nombre
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.person_outline, size: 30.0),
    activeIcon: Icon(Icons.person, size: 30.0),
    label: '', // Se establece una cadena vacía para ocultar el nombre
  ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _options,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Personaliza aquí más estilos de BottomNavigationBar
        useLegacyColorScheme: true,
        iconSize: 40.0,
        selectedItemColor: Theme.of(context).colorScheme.inverseSurface,
         // Color del ítem activo
        showUnselectedLabels: false, // Oculta el nombre del ítem inactivo
        showSelectedLabels: false,
        selectedFontSize: 20, // Oculta el nombre del ítem activo
        backgroundColor: Theme.of(context).colorScheme.onInverseSurface, // Color de fondo
        type: BottomNavigationBarType.fixed, // Tipo de barra
      ),
    );
  }
}

