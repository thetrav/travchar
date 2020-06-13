

import 'package:flutter/material.dart';

class TPickList<T> extends StatelessWidget {
  final Function(List<T> newSelection) selectionChanged;
  final List<T> elements;
  final List<T> selected;
  final String Function(T) labelBuilder;

  TPickList({this.elements, this.selected, this.labelBuilder, this.selectionChanged});


  void toggle(T e) {
    if(selected.contains(e)) {
      selectionChanged(selected.where((s) => e!= e).toList());
    } else {
      selectionChanged(selected + [e]);
    }
  }

  Widget tile(T e) =>
    ListTile(
      leading: selected.contains(e) ? Icon(Icons.done, color: Colors.green) : null,
      title: Text(labelBuilder(e)),
      onTap: () => toggle(e),
    );

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: elements.length,
    itemBuilder: (c, i) => tile(elements[i]),
  );
}