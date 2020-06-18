import 'dart:convert';

import 'package:travchar/model/requirement.dart';
import 'package:travchar/model/term.dart';

import '../util.dart';
import 'Character.dart';
import 'term_effect_table.dart';

class AdvancedEducation {
  final String name;
  final List<Requirement> requirements;
  final Requirement admission;
  final Requirement graduation;
  final Requirement honours;
  final List<TermEffect> passEffects;
  final List<TermEffect> failEffects;
  final List<TermEffect> honoursEffects;
  final Map<String, TermEffectTable> tables;

  bool canApply(Character c) =>
    requirements.every((r) => r.evaluate(c));

  AdvancedEducation({
    this.name,
    this.requirements,
    this.admission,
    this.graduation,
    this.honours,
    this.passEffects,
    this.failEffects,
    this.honoursEffects,
    this.tables
  });

  static AdvancedEducation parse(d) =>
    AdvancedEducation(
      name: d["name"],
      requirements: parseList(d, "requirements", Requirement.parse),
      admission: Requirement.parse(d["admission"]),
      graduation: Requirement.parse(d["graduation"]),
      honours: Requirement.parse(d["honours"]),
      passEffects: parseList(d, "pass_effects", TermEffect.parse),
      failEffects: parseList(d, "fail_effects", TermEffect.parse),
      honoursEffects: parseList(d, "honours_effects", TermEffect.parse),
      tables: TermEffectTable.parse(d["tables"])
    );

  static List<AdvancedEducation> load(String source) =>
    jsonDecode(source).map<AdvancedEducation>(AdvancedEducation.parse).toList();

  AdvancedEducation copy() => AdvancedEducation(
    name: name,
    requirements: requirements,
    admission: admission,
    graduation: graduation,
    honours: honours,
    passEffects: passEffects.map((e)=> e.copy()).toList(),
    failEffects: failEffects.map((e)=> e.copy()).toList(),
    honoursEffects: honoursEffects.map((e)=> e.copy()).toList(),
    tables: tables
  );
}