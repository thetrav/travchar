
import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/TListView.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/term/apply_all_benefit.dart';
import 'package:travchar/model/term/term.dart';
import 'package:travchar/views/term/term_navigation.dart';

import 'package:tuple/tuple.dart';

class ApplyAllView extends StatefulWidget {
  final ApplyAllBenefit effect;
  final Character character;
  static String route = "/${ApplyAllBenefit.type}";

  ApplyAllView(Tuple2<Character, TermEffect> t):
      character = t.item1, effect = t.item2 as ApplyAllBenefit;

  @override
  State<StatefulWidget> createState() => ApplyAllViewState();
}

class ApplyAllViewState extends State<ApplyAllView> {
  List<TermEffect> choices;
  List<TermEffect> chosen;

  @override
  void initState() {
    super.initState();
    choices = widget.effect.effects.where((e) =>
      e.hasChoice && e.qualifies(widget.character)
    ).toList();
    chosen = <TermEffect>[];
  }

  void done(BuildContext c) {
    Navigator.pop(c, widget.effect.copy(
      effects: widget.effect.effects.where(
          (e) => !e.hasChoice
      ).toList() + chosen
    ));
  }

  void select(TermEffect e, BuildContext c) {
    if(choices.contains(e)) {
      getChoice(c, widget.character, e).then((updated) =>
        setState(() {
          choices.remove(e);
          chosen.add(updated);
        })
      );
    }
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Text("Choices"),
    Expanded(child: TListView(
      choices+chosen,
      (e, c) => ListTile(
        leading: choices.contains(e) ?
          Icon(Icons.label, color: Colors.blue) :
          Icon(Icons.done, color: Colors.green),
        title: Text(e.toString()),
        onTap: () => select(e, c),
      )
    )),
    TButton("Done", choices.isEmpty ? () => done(context) : null)
  ]);
}