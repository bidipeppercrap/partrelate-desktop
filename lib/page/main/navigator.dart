import 'package:flutter/material.dart';
import 'package:partrelate_desktop/page/home.dart';
import 'package:partrelate_desktop/page/part.dart';
import 'package:partrelate_desktop/page/vehicle.dart';

class Route {
  const Route(
      {required this.icon,
      required this.selectedIcon,
      required this.labelText,
      required this.route,
      required this.page});

  final Icon icon;
  final Icon selectedIcon;
  final String labelText;
  final String route;
  final Widget page;
}

final navigatorKey = GlobalKey<NavigatorState>();

List<Route> routes = [
  const Route(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      labelText: 'Home',
      route: 'home',
      page: HomePage()),
  const Route(
      icon: Icon(Icons.directions_car_filled_outlined),
      selectedIcon: Icon(Icons.directions_car_filled),
      labelText: 'Vehicle',
      route: 'vehicle',
      page: VehiclePage()),
  const Route(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      labelText: 'Part',
      route: 'part',
      page: PartPage())
];

class MainLayoutNavigator extends StatelessWidget {
  const MainLayoutNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: 'home',
      onGenerateRoute: (RouteSettings settings) {
        for (var route in routes) {
          if (route.route == settings.name) {
            WidgetBuilder builder;

            builder = (BuildContext context) => route.page;
            return MaterialPageRoute<dynamic>(
                builder: builder, settings: settings);
          }
        }

        throw Exception('Invalid route: ${settings.name}');
      },
    );
  }
}
