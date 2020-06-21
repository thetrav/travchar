import '../Dice.dart';
import 'term.dart';
import '../Character.dart';
import 'term_effect_table.dart';

class RolledBenefit extends TermEffect {
  static String type = "rolledBenefit";
  final String table;
  final Map<String, TermEffectTable> tables;
  int rolledValue;
  bool rolled;
  TermEffect effect;
  RolledBenefit({
    this.table,
    this.tables,
    this.rolledValue,
    this.effect,
    this.rolled: false
  });
  static RolledBenefit parse(d, tables) {
    return RolledBenefit(
      table: d["table"],
      tables: tables
    );
  }

  int get roll {
    if(!rolled) {
      rolled = true;
      rolledValue = dice.roll(1, tables[table].table.length).first;
    }
    return rolledValue;
  }

  TermEffect get rolledEffect =>
    tables[table].table[roll];

  @override
  Character apply(Character c) =>
    rolledEffect.apply(c);

  @override
  bool get hasChoice => rolledEffect.hasChoice;
  @override
  String toString() => !rolled ?
  "roll on $table table" :
  rolledEffect.toString();
  String get route => type;

  @override
  TermEffect copy({effect}) => RolledBenefit(
    table: table,
    tables: tables,
    rolledValue: rolledValue,
    rolled: rolled,
    effect: effect ?? this.effect
  );
}