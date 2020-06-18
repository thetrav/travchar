
import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/t_pick_list.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/tables.dart';
import 'package:tuple/tuple.dart';

class BackgroundSkillsView extends StatefulWidget {
  final String nextRoute;
  final Character character;
  final Tables tables;

  BackgroundSkillsView(this.nextRoute, Tuple2<Character, Tables> t)
    :
      this.character = t.item1,
      this.tables = t.item2;

  @override
  State<StatefulWidget> createState() => BackgroundSkillsViewState();
}

class BackgroundSkillsViewState extends State<BackgroundSkillsView> {
  List<String> selected;

  @override
  void initState() {
    super.initState();
    selected = <String>[];
  }

  int get picksTotal => widget.character.stat("edu").diceMod + 2;
  int get picksRemaining => picksTotal - selected.length;

  List<String> get allowedSkills =>
    widget.tables.backgroundSkillsTable.skillsFor(widget.character);

  void selectionChanged(List<String> s) {
    if(s.length <= picksTotal) {
      setState(() {
        selected = s;
      });
    }
  }

  void done(BuildContext c) {
    Navigator.pushReplacementNamed(c, widget.nextRoute,
      arguments:Tuple2<Character, Tables>(
        widget.character.copy(
          age: 18,
          skills: widget.character.skills.map((skill) =>
            selected.contains(skill.name) ?
              skill.copy(rank: 0) :
              skill
          ).toList()
        ),
        widget.tables
      )
    );
  }

  @override
  Widget build(BuildContext context) => Column( children: [
    Text("$picksRemaining of $picksTotal Remaining"),
    Expanded(child: TPickList(
      elements: allowedSkills,
      selected: selected,
      labelBuilder: (s) => s,
      selectionChanged: selectionChanged,
    )),
    TButton("Done", () =>done(context))
  ]);
}