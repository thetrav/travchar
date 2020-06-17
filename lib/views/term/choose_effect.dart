
import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/t_pick_list.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/choose_term_benefit.dart';
import 'package:travchar/model/term.dart';
import 'package:travchar/model/term_effect_table.dart';
import 'package:tuple/tuple.dart';

class ChooseEffectView extends StatefulWidget {
  final ChooseBenefit effect;
  final Character character;
  final Map<String, TermEffectTable> tables;
  static String route = "/${ChooseBenefit.type}";

  ChooseEffectView(Tuple3<Character, TermEffect, Map<String, TermEffectTable>> t):
    character = t.item1,effect = t.item2 as ChooseBenefit, tables = t.item3;

  @override
  State<StatefulWidget> createState() => ChooseEffectViewState();
}

class ChooseEffectViewState extends State<ChooseEffectView> {

  List<TermEffect> picked = [];
  List<TermEffect> get options {
    final opts = <TermEffect>[];
    if(widget.effect.options != null) {
      opts.addAll(widget.effect.options);
    }
    if(widget.effect.tables != null) {
      widget.effect.tables.forEach((t) =>
        opts.addAll(widget.tables[t].table.values.map((e)=>e.copy()).toList())
      );
    }
    return opts;
  }

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
      elements: options
        .where((e) => e.qualifies(widget.character)).toList(),
      selected: picked,
      labelBuilder: (e) => e.toString(),
      selectionChanged: selectionChanged
    )),
    TButton("Done", () => done(context))
  ]);
}