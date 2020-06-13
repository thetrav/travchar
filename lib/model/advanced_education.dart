import 'dart:convert';

import 'package:travchar/model/requirement.dart';

import 'Character.dart';

class AdvancedEducation {
  final String name;
  final List<Requirement> requirements;

  bool canApply(Character c) =>
    requirements.every((r) => r.evaluate(c));

  AdvancedEducation(this.name, this.requirements);
  static AdvancedEducation parse(d) =>
    AdvancedEducation(d["name"], d["requirements"].map<Requirement>(Requirement.parse).toList());

  static List<AdvancedEducation> load(String source) =>
    jsonDecode(source).map<AdvancedEducation>(AdvancedEducation.parse).toList();
}