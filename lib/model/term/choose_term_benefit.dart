import 'package:travchar/model/term/term_effect_table.dart';

import "term.dart";
import '../../util.dart';
import '../Character.dart';

class ChooseBenefit extends TermEffect {
  static String type = "chooseBenefit";
  final List<TermEffect> options;
  final List<String> tables;
  final Map<String, TermEffectTable> parsedTables;
  final int picks;
  final String label;
  ChooseBenefit({this.options, this.picks, this.tables, this.label, this.parsedTables});
  List<TermEffect> choice;

  static ChooseBenefit parse(d, tables) =>
    ChooseBenefit(
      options: parseList(d, "options", (d) => TermEffect.parse(d, tables)),
      picks: d['picks']?? 1,
      tables: parseList(d, "tables", (s) => s.toString()),
      label: d["label"],
      parsedTables: tables
    );

  @override
  Character apply(Character c) =>
    choice.fold(c, (c, e) => e.apply(c));

  @override
  bool get hasChoice => true;
  @override
  String toString() => (choice == null) ?
    (label == null) ?
      "Choose from multiple benefits" :
      label :
    "${choice.join(", ")}";
  @override
  String get route => type;

  @override
  TermEffect copy() => ChooseBenefit(
    options: options?.map((e) => e.copy())?.toList(),
    picks: picks,
    tables: tables,
    label: label,
    parsedTables: parsedTables
  );
}