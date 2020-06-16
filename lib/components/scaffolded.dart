

import 'package:flutter/material.dart';

class Scaffolded extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  Scaffolded(this.builder);

  Widget buildChild(BuildContext c) {
    try {
      return builder(c);
    } catch( e, s) {
      print("caught $e\n$s");
      return Text("ERROR $e");
    }
  }

  @override
  Widget build(BuildContext c) {
    final child = buildChild(c);
    return Scaffold(
      appBar: AppBar(
        title: Text("Traveller Character Generator"),
      ),
      body: Center(
        child: child,
      ),
    );
  }
}