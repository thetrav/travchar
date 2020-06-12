

import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/drop_down.dart';
import 'package:travchar/components/t_ticker.dart';

class ShiftStats extends StatefulWidget {
  final Function(String from1, int amount1, String to1,
    String from2, int amount2, String to2) shift;
  final List<String> stats;

  ShiftStats(this.shift, this.stats);

  @override
  State<StatefulWidget> createState() => ShiftStatsState();
}

class ShiftStatsState extends State<ShiftStats> {
  final DropDownController from1 = DropDownController(null);
  final DropDownController to1 = DropDownController(null);
  final TickerController amount1 = TickerController();
  final DropDownController from2 = DropDownController(null);
  final DropDownController to2 = DropDownController(null);
  final TickerController amount2 = TickerController();

  List<String> stats(List<DropDownController> excluding) {
    final exclude = excluding.map((d) => d.selected).toList();
    return widget.stats.where((s) => !exclude.contains(s)).toList();
  }

  void onChange(String s) {
    void clearDuplicate(DropDownController a, List<DropDownController> match) {
      if (match.map((d) => d.selected).contains(a.selected)) {
        a.selected = null;
      }
    }

    setState((){
      clearDuplicate(to1, [from1]);
      clearDuplicate(from2, [to1, from1]);
      clearDuplicate(to2, [from2, to1, from1]);
    });
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Text("Shift Stats"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("from:"),
        DropDown(from1, stats([]), onChange: onChange),
        TTicker(amount1, max: 2),
        Text("to:"),
        DropDown(to1, stats([from1]), onChange: onChange)
      ]
    ),
    Text("And"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("from:"),
        DropDown(from2, stats([from1, to1]), onChange: onChange),
        TTicker(amount2, max: 2),
        Text("to:"),
        DropDown(to2, stats([from1, to1, from2]), onChange: onChange)
      ]
    ),
    Row(children: [
      TButton("Shift", () =>
        widget.shift(from1.selected, amount1.value, to1.selected,
          from2.selected, amount2.value, to2.selected)
      )
    ])
  ]);
}