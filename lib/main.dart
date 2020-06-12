import 'package:flutter/material.dart';

import 'components/scaffolded.dart';
import 'routes.dart';
import 'util.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traveller Character Generator',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: mapMap(routes, (v) => (c) => Scaffolded((c) => v(c)))
    );
  }
}

