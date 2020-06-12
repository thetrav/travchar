

import 'package:flutter/material.dart';

class TLoader<T> extends StatelessWidget {
  final Future<T> loading;
  final Widget Function(BuildContext, T) builder;
  TLoader(this.loading, this.builder);

  @override
  Widget build(BuildContext c) => FutureBuilder(
    future: loading,
    builder: (c, snapshot) {
      print("buildin");
      if(snapshot.hasError) {
        return Text("ERROR! ${snapshot.error}");
      }
      if(snapshot.hasData) {
        return builder(c, snapshot.data);
      }
      return CircularProgressIndicator();
    }
  );

}