import 'dart:math';

import 'package:flutter/material.dart';
import 'package:travchar/model/tables.dart';
import 'package:tuple/tuple.dart';
import '../model/Character.dart';
import '../model/Dice.dart';
import '../util.dart';
import 'stats/stat_controls.dart';

class StatsView extends StatefulWidget {
  final String nextRoute;
  final Character character;
  final Tables tables;

  StatsView(this.nextRoute, Tuple2<Character, Tables> t):
      this.character = t.item1, this.tables = t.item2;

  @override
  State<StatefulWidget> createState() =>
    StatsViewState();
}

class StatsViewState extends State<StatsView> {
  Map<String, Statistic> stats;
  bool adjusted;

  Statistic roll(String s) =>
    Statistic(name: s, roll: dice.roll(2,6));

  @override
  void initState() {
    super.initState();
    adjusted = false;
    rollStats();
  }

  void done(BuildContext c) {
    final mods = widget.character.homeworld.statAdjustments;
    mods.forEach((key, value) {
      stats[key].adjustments.add(value);
    });
    Navigator.pushReplacementNamed(
      c,
      widget.nextRoute,
      arguments: Tuple2<Character, Tables>(
        widget.character.copy(statRolls: stats, terms: []),
        widget.tables
      )
    );
  }

  void rollStats() {
    stats = {
      "str": roll("str"),
      "dex": roll("dex"),
      "end": roll("end"),
      "int": roll("int"),
      "edu": roll("edu"),
      "soc": roll("soc")
    };
    while(totalStatValue < 35) {
      final l = allStats;
      l.sort((a, b)=> a.score.compareTo(b.score));
      l.first.adjustments.add(StatAdjustment(1, "totalscore < 35"));
    }
  }

  List<Statistic> get allStats => stats.values.toList();

  num get totalStatValue => sum(allStats.map((s) => s.score).toList());

  void swapStat(String a, String b) {
    final stat1 = stats[a];
    final stat2 = stats[b];
    final difference = stat1.score - stat2.score;
    stat1.adjustments.add(StatAdjustment(-difference, "Characte Gen Stat Swap"));
    stat2.adjustments.add(StatAdjustment(difference, "Character Gen Stat Swap"));
  }

  void swapStats(String a1, String b1, String a2, String b2) {
    setState((){
      if(a1!= null && b1!= null) {
        swapStat(a1, b1);
      }
      if(a2!= null && b2!= null) {
        swapStat(a2, b2);
      }
      adjusted = true;
    });
  }

  void shiftStat(String s, int amount) =>
    stats[s].adjustments.add(StatAdjustment(
      amount,
      "Character Gen Stat Shift"
    ));

  void shiftStats(String a1, int amount1, String b1,
                  String a2, int amount2, String b2) {
    setState(() {
      if(a1 != null && b1 != null) {
        shiftStat(a1, -amount1);
        shiftStat(b1, amount1);
      }
      if(a2 != null && b2 != null) {
        shiftStat(a2, -amount2);
        shiftStat(b2, amount2);
      }
      adjusted = true;
    });
  }

  void rerollStat(String s) {
    setState((){
      if(s != null) {
        final newRoll = min(6, sum(dice.roll(2, 6)));
        final difference = stats[s].score - newRoll;
        stats[s].adjustments.add(StatAdjustment(
          -difference,
          "Character Gen Re Roll"));
      }
      adjusted = true;
    });
  }

  @override
  Widget build(BuildContext context) =>
    SingleChildScrollView(child: StatControls(stats,
      totalStatValue: totalStatValue,
      adjusted: adjusted,
      swapStats: swapStats,
      shiftStats: shiftStats,
      rerollStat: rerollStat,
      done: done
    ));
}