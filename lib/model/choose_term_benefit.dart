

import 'package:travchar/model/term.dart';
import 'package:travchar/model/term_effect_table.dart';

import '../util.dart';
import 'Character.dart';

class ChooseBenefit extends TermEffect {
  static String type = "chooseBenefit";
  final List<TermEffect> options;
  final List<String> tables;
  final int picks;
  final String label;
  ChooseBenefit({this.options, this.picks, this.tables, this.label});
  List<TermEffect> choice;

  static ChooseBenefit parse(d) =>
    ChooseBenefit(
      options: parseList(d, "options", TermEffect.parse),
      picks: d['picks']?? 1,
      tables: parseList(d, "tables", (s) => s.toString()),
      label: d["label"]
    );

  @override
  Character apply(Character c, Map<String, TermEffectTable> tables) =>
    choice.fold(c, (c, e) => e.apply(c, tables));

  @override
  bool get hasChoice => true;
  @override
  String toString() => (choice == null) ?
    (label == null) ?
      "Choose from multiple benefits" :
      label :
    "${choice.join(", ")}";
  String get route => type;

  @override
  TermEffect copy() => ChooseBenefit(
    options: options?.map((e) => e.copy())?.toList(),
    picks: picks,
    tables: tables,
    label: label
  );
}