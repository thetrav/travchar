
import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/advanced_education.dart';
import 'package:travchar/model/tables.dart';
import 'package:tuple/tuple.dart';

import 'stats/stat_table.dart';

class TermApplicationView extends StatefulWidget {
  final Character character;
  final Tables tables;

  final String educationRoute;
  final String careerRoute;

  TermApplicationView({this.educationRoute, this.careerRoute, Tuple2<Character, Tables> t}):
    character = t.item1, tables = t.item2;

  @override
  State<StatefulWidget> createState() => TermApplicationViewState();
}

class TermApplicationViewState extends State<TermApplicationView> {
  String education;
  String career;
  String draft;

  void applyForEducation(BuildContext c, AdvancedEducation e) {
    final admission = e.admission.evaluate(widget.character);
    if(admission == false) {
      setState((){education = "Failed Enrollment";});
    } else {
      Navigator.pushReplacementNamed(c, widget.educationRoute, arguments: Tuple3(e, widget.character, widget.tables));
    }
  }

  List<Widget> educations(BuildContext c) {
    if(education == null) {
      return widget.tables.advancedEducations
        .where((e) => e.canApply(widget.character))
        .map((e) =>
        ListTile(
          title: Text(e.name),
          subtitle: Text("admission: ${e.admission}"),
          onTap: () => applyForEducation(c, e),
        )).toList();
    }
    return [Text(education)];
  }


  @override
  Widget build(BuildContext context) => Column(
    children: [
      StatTable(widget.character.statRolls),
      Text("Enroll in"),
      ...educations(context),
      Text("or"),
      TButton("Career", (){}),
      Text("or"),
      TButton("Draft", (){}),
      Text("or"),
      TButton("Drifter", (){}),
    ]
  );
}