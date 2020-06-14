import 'dart:convert';

import 'package:travchar/model/requirement.dart';
import 'package:travchar/model/term.dart';

import '../util.dart';
import 'Character.dart';

class AdvancedEducation {
  final String name;
  final List<Requirement> requirements;
  final Requirement admission;
  final Requirement graduation;
  final List<TermEffect> passEffects;
  final List<TermEffect> failEffects;
  final Map<String, Map<int, TermEffect>> tables;

  bool canApply(Character c) =>
    requirements.every((r) => r.evaluate(c));

  AdvancedEducation({
    this.name,
    this.requirements,
    this.admission,
    this.graduation,
    this.passEffects,
    this.failEffects,
    this.tables
  });

  static Map<int, TermEffect> mapTable(Map<String, dynamic> raw,
    TermEffect Function(dynamic) parser) {
    final table = <int, TermEffect>{};
    raw.keys.forEach((key) {
      final i = int.parse(key);
      final v = parser(raw[key]);
      table[i] = v;
    });
  }

  static Map<String, Map<int, TermEffect>> parseTables(
    Map<String, dynamic> raw,
    TermEffect Function(dynamic) parser) {
    final tables = <String, Map<int, TermEffect>>{};
    raw.keys.forEach((tableName) {
      tables[tableName] = mapTable(raw[tableName], parser);
    });
    return tables;
  }

  static AdvancedEducation parse(d) =>
    AdvancedEducation(
      name: d["name"],
      requirements: parseList(d, "requirements", Requirement.parse),
      admission: Requirement.parse(d["admission"]),
      graduation: Requirement.parse(d["graduation"]),
      passEffects: parseList(d, "pass_effects", TermEffect.parse),
      failEffects: parseList(d, "fail_effects", TermEffect.parse),
      tables: parseTables(d["tables"], TermEffect.parse)
    );

  static List<AdvancedEducation> load(String source) =>
    jsonDecode(source).map<AdvancedEducation>(AdvancedEducation.parse).toList();
}