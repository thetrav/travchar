
import 'dart:convert';

import 'package:travchar/model/requirement.dart';

import '../util.dart';
import 'Character.dart';

class BackgroundSkillsTable {
  final List<String> commonSkills;
  final List<BackgroundSkill> restrictedSkills;
  final List<BackgroundStatGain> statGains;
  BackgroundSkillsTable(this.commonSkills, this.restrictedSkills, this.statGains);

  static BackgroundSkillsTable load(String source) {
    final data = jsonDecode(source);
    List<String> common = data["commonSkills"].map<String>((s)=> s as String).toList();
    List<BackgroundSkill> restricted = data["restrictedSkills"].map<BackgroundSkill>(BackgroundSkill.parse).toList();
    List<BackgroundStatGain> statGains = data["statGains"].map<BackgroundStatGain>(BackgroundStatGain.parse).toList();
    return BackgroundSkillsTable(common, restricted, statGains);
  }

  List<String> skillsFor(Character character) {
    final skills = restrictedSkills
      .where((bs)=> bs.req.evaluate(character))
      .map((bs)=> bs.skills)
      .expand(((e) => e))
      .toList()
      ..addAll(commonSkills)
      ..toSet().toList()//deduplicate
      ..sort();
    return skills;
  }
}

class BackgroundSkill {
  final List<String> skills;
  final Requirement req;

  BackgroundSkill(this.skills, this.req);
  static BackgroundSkill parse(data) =>
    BackgroundSkill(
      stringList(data["skills"]),
      HomeworldRequirement.parse(data["requirement"])
    );
}

class BackgroundStatGain {
  final List<String> stats;
  final int gains;
  final Requirement req;
  BackgroundStatGain(this.stats, this.gains, this.req);
  static BackgroundStatGain parse(d) =>
    BackgroundStatGain(
      stringList(d["stats"]),
      d["gains"],
      HomeworldRequirement.parse(d["requirement"]));
}