import 'package:flutter/material.dart';
import 'package:travchar/model/Character.dart';

class StatTable extends StatelessWidget {
  final Map<String, Statistic> stats;
  StatTable(this.stats);

  text(String s) => Container(
    width: 80,
    child: Text(s)
  );

  Widget statHeader() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      text(""),
      text("Score"),
      text("Mod")
    ]
  );

  Widget statView(String statName) {
    final stat = stats[statName];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        text(stat.name),
        text("${stat.score}"),
        text("${stat.diceMod}")
      ]
    );
  }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Physical Stats"),
          statHeader(),
          statView("str"),
          statView("dex"),
          statView("end"),
        ]
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Other Stats"),
          statHeader(),
          statView("int"),
          statView("edu"),
          statView("soc"),
        ]
      ),
    ]);

}