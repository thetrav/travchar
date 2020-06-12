

import 'package:flutter/material.dart';

class TListView<T> extends StatelessWidget {
  final List<T> elements;
  final Widget Function(BuildContext) header;
  final Widget Function(T, BuildContext) builder;

  TListView(this.elements, this.builder, {this.header});

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: elements.length + (header == null ? 0 : 1),
    itemBuilder: (c, i) {
      if(header == null) {
        return builder(elements[i], c);
      } else if (i == 0) {
        return header(c);
      } else {
        return builder(elements[i-1], c);
      }
    }
  );
}