

import 'package:flutter/material.dart';

class Scaffolded extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  Scaffolded(this.builder);

  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(
      title: Text("Traveller Character Generator"),
    ),
    body: Center(
      child: builder(c),
    ),
  );
}