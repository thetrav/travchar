
import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/t_pick_list.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/term/choose_term_benefit.dart';
import 'package:travchar/model/term/term.dart';
import 'package:travchar/views/term/term_navigation.dart';

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

  ChooseBenefit get effect => widget.effect;
  List<TermEffect> picked = [];
  List<TermEffect> get options {
    final opts = <TermEffect>[];
    if(effect.options != null) {
      opts.addAll(effect.options);
    }
    if(effect.tables != null) {
      effect.tables.forEach((t) =>
        opts.addAll(effect.parsedTables[t].table.values.map((e)=>e.copy()).toList())
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

  Future<List<TermEffect>> handleChoices(BuildContext c) async {
    final effects = <TermEffect>[];
    for (TermEffect e in picked) {
      if(e.hasChoice) {
        effects.add(await getChoice(c, widget.character, e));
      } else {
        effects.add(e);
      }
    }
    return effects;
  }

  void done(BuildContext c) {
    handleChoices(c).then((choices) {
      widget.effect.choice = picked;
      Navigator.pop(c, widget.effect);
    });
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