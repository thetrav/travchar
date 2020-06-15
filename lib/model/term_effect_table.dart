
import 'package:travchar/model/Dice.dart';
import 'package:travchar/model/term.dart';

class TermEffectTable {
  final String name;
  final Map<int, TermEffect> table;
  TermEffectTable(this.name, this.table);

  TermEffect roll() =>
    dice.tableRoll(table);

  static Map<int, TermEffect> mapTable(Map<String, dynamic> raw) {
    final table = <int, TermEffect>{};
    raw.keys.forEach((key) {
      final i = int.parse(key);
      final v = TermEffect.parse(raw[key]);
      table[i] = v;
    });
    return table;
  }

  static Map<String, TermEffectTable> parse(
    Map<String, dynamic> raw) {
    final tables = <String, TermEffectTable>{};
    raw.keys.forEach((tableName) {
      print("parsing table: $tableName");
      tables[tableName] = TermEffectTable(
        tableName,
        mapTable(raw[tableName])
      );
    });
    return tables;
  }
}