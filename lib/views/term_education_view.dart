

import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
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

  static String route = "/termEducation";

  TermEducationView(this.nextRoute, Tuple3<AdvancedEducation, Character, Tables> t):
    education = t.item1, character = t.item2, tables = t.item3;

  @override
  State<StatefulWidget> createState() => TermEducationViewState();
}

class TermEducationViewState extends State<TermEducationView> {
  bool graduated;
  List<String> history;
  List<TermEffect> effects;
  Character character;

  @override
  void initState() {
    super.initState();
    newState();
  }

  @override
  void didUpdateWidget(TermEducationView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.education != widget.education) {
      setState(()=>newState());
    }
  }

  void newState() {
    final education = widget.education;
    graduated = education.graduation.evaluate(widget.character);
    history = <String>[];
    character = widget.character;
    effects = (graduated ? education.passEffects : education.failEffects)
      .where((e)=> e.qualifies(character)).toList();
  }

  void applyEffect(BuildContext c, TermEffect e) {
    final effect = (e.hasChoice) ? Navigator.pushNamed(c,
      "/${e.route}",
      arguments: Tuple3(character, e, widget.education.tables)
    ) : Future.value(e);
    effect.then((result) {
      if(result != null && result is TermEffect) {
        setState(() {
          character = result.apply(character, widget.education.tables);
          effects.remove(e);
          history.add("applied $e");
        });
      }
    });
  }

  Widget effectTile(BuildContext c, TermEffect e) {
    return ListTile(
      leading: Icon(Icons.label, color: Colors.blue),
      title: Text(e.toString()),
      onTap: () => applyEffect(c, e)
    );
  }

  void done(BuildContext context) {
    Navigator.pushReplacementNamed(context, widget.nextRoute, arguments: Tuple2(
      character.copy(terms: character.terms + [
        EducationTerm(widget.education, history)
      ]), widget.tables
    ));
  }

  Widget historyTile(history) => ListTile(
    leading: Icon(Icons.done, color: Colors.green),
    title: Text(history)
  );

  @override
  Widget build(BuildContext context) {
    final children = [
      Text(graduated ? "You graduated, congratulations!" : "You failed, how disappointing"),
      Expanded(child: ListView(
        children: history.map(historyTile).toList() +
          effects.map((e) => effectTile(context, e)).toList()
      ))
    ];
    if(effects.isEmpty) {
      children.add(TButton("Done", () => done(context)));
    }
    return Column(children: children);
  }
}