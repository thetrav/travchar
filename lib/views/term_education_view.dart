

import 'package:flutter/material.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/advanced_education.dart';
import 'package:travchar/model/tables.dart';
import 'package:travchar/model/term.dart';
import 'package:tuple/tuple.dart';

class TermEducationView extends StatefulWidget {
  final String nextRoute;
  final AdvancedEducation education;
  final Character character;
  final Tables tables;

  TermEducationView(this.nextRoute, Tuple3<AdvancedEducation, Character, Tables> t):
    education = t.item1, character = t.item2, tables = t.item3;

  @override
  State<StatefulWidget> createState() => TermEducationViewState();
}

class TermEducationViewState extends State<TermEducationView> {
  bool graduated;
  List<Widget> history;
  List<TermEffect> effects;

  @override
  void initState() {
    super.initState();
    final education = widget.education;
    graduated = education.graduation.evaluate(widget.character);
    history = <Widget>[];
    effects = graduated ? education.passEffects : education.failEffects;
  }

  Widget effectTile(BuildContext c, TermEffect e) {
    return ListTile(
      title: Text(e.toString()),
      onTap: () => Navigator.pushNamed(c,
      "/${e.route}",
      arguments: Tuple3(widget.character, e, widget.education.tables)
      )
    );
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(graduated ? "You graduated, congratulations!" : "You failed, how disappointing"),
    Expanded(child: ListView(
      children: history +
        effects.map((e) => effectTile(context, e)).toList()
    ))
  ]);
}