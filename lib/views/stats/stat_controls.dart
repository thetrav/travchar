
import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/views/stats/reroll_stats.dart';
import 'package:travchar/views/stats/shift_stats.dart';
import 'package:travchar/views/stats/swap_stats.dart';

import 'stat_table.dart';

class StatControls extends StatelessWidget {
  final Map<String, Statistic> stats;
  List<Statistic> get allStats => stats.values.toList();
  final num totalStatValue;
  final bool adjusted;
  final Function(String, String, String, String) swapStats;
  final Function(String, int, String, String, int, String) shiftStats;
  final Function(String) rerollStat;
  final Function done;

  StatControls(this.stats, {
    this.totalStatValue,
    this.adjusted,
    this.swapStats,
    this.shiftStats,
    this.rerollStat,
    this.done
  });

  paddedText(String s) => Padding(
    padding: EdgeInsets.all(10),
    child: Text(s)
  );

  List<Widget> modifications(BuildContext c) {
    Widget card(Widget child) =>
      Padding(
        padding: EdgeInsets.all(20),
        child: Card(child: Padding(padding: EdgeInsets.all(20), child: child))
      );

    final stats = allStats.map((s)=> s.name).toList();
    if(totalStatValue > 50 ) {
      return [paddedText("Highly Competent!")];
    }
    if(adjusted) {
      return [paddedText("Well Adjusted")];
    }

    return [
      card(SwapStats(swapStats, stats)),
      Text("or"),
      card(ShiftStats(shiftStats, stats)),
      Text("or"),
      card(Reroll(rerollStat, stats))
    ];
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(height: 10),
      StatTable(stats),
      paddedText("Total Score $totalStatValue"),
      ...modifications(context),
      TButton("Done (will apply homeworld)", () => done(context))
    ]);
}