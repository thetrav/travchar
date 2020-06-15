
import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/t_pick_list.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/term.dart';
import 'package:tuple/tuple.dart';

class ChooseEffectView extends StatefulWidget {
  final ChooseBenefit effect;
  final Character character;
  static String route = "/${ChooseBenefit.type}";

  ChooseEffectView(Tuple2<Character, TermEffect> t):
    character = t.item1,effect = t.item2 as ChooseBenefit;

  @override
  State<StatefulWidget> createState() => ChooseEffectViewState();
}

class ChooseEffectViewState extends State<ChooseEffectView> {

  List<TermEffect> picked = [];

  int get picks => widget.effect.picks;
  int get picksLeft => picks - picked.length;

  void selectionChanged(List<TermEffect> newSelection) {
    if(newSelection.length <= picks) {
      setState(()=> picked = newSelection);
    }
  }

  void done(BuildContext c) {
    widget.effect.choice = picked;
    Navigator.pop(c, widget.effect);
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Text("$picksLeft of $picks remaining"),
    Expanded(child: TPickList(
      elements: widget.effect.options
        .where((e) => e.qualifies(widget.character)).toList(),
      selected: picked,
      labelBuilder: (e) => e.toString(),
      selectionChanged: selectionChanged
    )),
    TButton("Done", () => done(context))
  ]);
}