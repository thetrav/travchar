import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/drop_down.dart';

class Reroll extends StatelessWidget {
  final Function(String) reroll;
  final List<String> stats;
  final DropDownController controller = DropDownController("str");

  Reroll(this.reroll, this.stats);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text("Re Roll Stat"),
      DropDown(controller, stats),
      TButton("Re Roll", () => reroll(controller.selected))
    ]
  );
}