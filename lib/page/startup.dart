import 'package:flutter/material.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key, this.children = const <Widget>[]});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
