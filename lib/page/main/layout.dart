import 'package:flutter/material.dart';
import 'package:partrelate_desktop/page/main/navigator.dart';

List<NavigationRailDestination> navigationDestinations = routes
    .map((route) => NavigationRailDestination(
          icon: route.icon,
          selectedIcon: route.selectedIcon,
          label: Text(route.labelText),
        ))
    .toList();

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            destinations: navigationDestinations,
            onDestinationSelected: (int index) {
              setState(() {
                navigatorKey.currentState!.pushNamed(routes[index].route);
                _selectedIndex = index;
              });
            },
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
          ),
          const Expanded(
              child: SingleChildScrollView(
            child: MainLayoutNavigator(),
          ))
        ],
      ),
    );
  }
}
