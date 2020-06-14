
import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/components/t_pick_list.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/term.dart';
import 'package:travchar/model/term_effect_table.dart';
import 'package:tuple/tuple.dart';

class ChooseSkillsView extends StatefulWidget {
  final Map<String, TermEffectTable> tables;
  final ChooseSkills effect;
  final Character character;
  static String route = "/${ChooseSkills.type}";

  ChooseSkillsView(Tuple3<Character, TermEffect, Map<String, TermEffectTable>> t):
    character = t.item1,effect = t.item2 as ChooseSkills, tables = t.item3;

  @override
  State<StatefulWidget> createState() => ChooseSkillsViewState();
}

class ChooseSkillsViewState extends State<ChooseSkillsView> {

  bool belowEffect(String skill) {
    final rank = widget.character.skill(skill)?.rank ?? -1;
    return rank < widget.effect.level;
  }

  List<TermEffect> picked = [];

  List<TermEffect> get options {
    final opts = <TermEffect>[];
    widget.tables.forEach((key, table) {
      table.table.forEach((i, effect) {
        if(effect is SkillGainBenefit) {
          final skill = effect.skill;
          if(belowEffect(skill)) {
            opts.add(effect);
          }
        }
      });
    });
    return opts.toSet().toList();
  }
  int get picks => widget.effect.picks;
  int get picksLeft => picks - picked.length;

  void selectionChanged(List<TermEffect> newSelection) {
    if(newSelection.length <= picks) {
      setState(()=> picked = newSelection);
    }
  }

  void done(BuildContext c) {
    widget.effect.selected = picked;
    Navigator.pop(c, widget.effect);
  }

  String label(TermEffect e) {
    if(e is SkillGainBenefit) {
      return "Set ${e.skill} to ${widget.effect.level}";
    }
    return "OOPS! $e";
  }

  @override
  Widget build(BuildContext context) => Column(children: [
    Text("$picksLeft of $picks remaining"),
    Expanded(child: TPickList(
      elements: options,
      selected: picked,
      labelBuilder: label,
      selectionChanged: selectionChanged
    )),
    TButton("done", () => done(context))
  ]);
}