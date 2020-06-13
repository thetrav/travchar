
import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/tables.dart';
import 'package:tuple/tuple.dart';

class AdvancedEducationView extends StatefulWidget {
  final Character character;
  final Tables tables;
  final String nextRoute;

  AdvancedEducationView(this.nextRoute, Tuple2<Character, Tables> t):
    character = t.item1, tables = t.item2;

  @override
  State<StatefulWidget> createState() => AdvancedEducationViewState();
}

class AdvancedEducationViewState extends State<AdvancedEducationView> {
  List<Widget> educations(BuildContext c) =>
    widget.tables.advancedEducations
      .where((e)=> e.canApply(widget.character))
      .map((e) => ListTile(title: Text(e.name))).toList();


  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text("Enroll in"),
      ...educations(context),
      Text("or"),
      TButton("Career", (){})
    ]
  );
}