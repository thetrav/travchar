

import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/drop_down.dart';

class SwapStats extends StatefulWidget {
  final Function(String from1, String to1, String from2, String to2) swapStats;
  final List<String> stats;

  SwapStats(this.swapStats, this.stats);
  @override
  State<StatefulWidget> createState() => SwapStatsState();
}

class SwapStatsState extends State<SwapStats> {

  final DropDownController fromStat1 = DropDownController(null);
  final DropDownController toStat1 = DropDownController(null);
  final DropDownController fromStat2 = DropDownController(null);
  final DropDownController toStat2 = DropDownController(null);

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
      clearDuplicate(toStat1, [fromStat1]);
      clearDuplicate(fromStat2, [toStat1, fromStat1]);
      clearDuplicate(toStat2, [fromStat2, toStat1, fromStat1]);
    });
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Text("Swap Stats"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:[
        DropDown(fromStat1, stats([])),
        Text(" With "),
        DropDown(toStat1, stats([fromStat1])),
      ]
    ),
    Text("and"),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:[
        DropDown(fromStat2, stats([fromStat1, toStat1])),
        Text(" With "),
        DropDown(toStat2, stats([fromStat1, toStat1, fromStat2]))
      ]
    ),
    TButton("Swap", () =>
      widget.swapStats(fromStat1.selected, toStat1.selected,
        fromStat2.selected, toStat2.selected)),
  ]);
}