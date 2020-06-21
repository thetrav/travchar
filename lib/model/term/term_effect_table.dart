import 'package:travchar/model/Dice.dart';
import 'package:travchar/model/term/term.dart';

import '../../util.dart';

class TermEffectTable {
  final String name;
  final Map<int, TermEffect> table;
  TermEffectTable(this.name, this.table);

  TermEffect roll() =>
    dice.tableRoll(table);

  static Map<int, TermEffect> mapTable(List<dynamic> raw, Map<String, TermEffectTable> tables) {
    final table = <int, TermEffect>{};
    eachWithIndex(raw, (i, e) =>
      table[i+1] = TermEffect.parse(e, tables)
    );
    return table;
  }

  static Map<String, TermEffectTable> parse(
    Map<String, dynamic> raw) {
    final tables = <String, TermEffectTable>{};
    raw.keys.forEach((tableName) {
      print("parsing table: $tableName");
      tables[tableName] = TermEffectTable(
        tableName,
        mapTable(raw[tableName], tables)
      );
    });
    return tables;
  }
}