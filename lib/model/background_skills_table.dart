
import 'dart:convert';

import 'Character.dart';

class BackgroundSkillsTable {
  final dynamic data;
  BackgroundSkillsTable(this.data);

  static BackgroundSkillsTable load(String data) =>
    BackgroundSkillsTable(jsonDecode(data));

  List<String> skillsFor(Character character) {
    List<String> skills = data["Any World"].map<String>((s)=> s as String).toList();
    skills.sort();
    return skills;
  }
}