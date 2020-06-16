import 'package:travchar/model/Character.dart';
import 'package:travchar/model/Dice.dart';
import 'package:travchar/model/advanced_education.dart';
import 'package:travchar/model/skill.dart';

import '../util.dart';
import 'term_effect_table.dart';

abstract class Term {
  final List<String> history;
  String get name;
  Map<String, TermEffectTable> get tables;
  String get route;
  Term(this.history);
}

class EducationTerm extends Term {
  String get route => "/term/education";
  String get name => education.name;
  AdvancedEducation education;
  Map<String, TermEffectTable> get tables => education.tables;
  EducationTerm(this.education, List<String> history):
    super(history);
}

abstract class TermEffect {
  bool get hasChoice;
  Character apply(Character c, Map<String, TermEffectTable> tables);
  bool qualifies(Character c) => true;
  static TermEffect parse(d) {
    print("parsing Term Effect $d");
    return {
      YearsPass.type: YearsPass.parse,
      RolledBenefit.type: RolledBenefit.parse,
      StatGainBenefit.type: StatGainBenefit.parse,
      SkillGainBenefit.type: SkillGainBenefit.parse,
      SpecialisationGainBenefit.type: SpecialisationGainBenefit.parse,
      ChooseBenefit.type: ChooseBenefit.parse,
      StatRaisedTo.type: StatRaisedTo.parse,
      SkillRaisedTo.type: SkillRaisedTo.parse,
      Certification.type: Certification.parse
    }[d["type"]](d);
  }
  String get route;

  TermEffect copy();
}

class YearsPass extends TermEffect {
  static String type = "yearsPass";
  final int years;
  YearsPass(this.years);
  static YearsPass parse(d) => YearsPass(d["years"]);
  @override
  Character apply(Character c, Map<String, TermEffectTable> tables) => c.copy(age: c.age + years);
  @override
  bool get hasChoice => false;
  @override
  String toString() => "$years years pass";
  String get route => type;
  TermEffect copy() => this;
}

class RolledBenefit extends TermEffect {
  static String type = "rolledBenefit";
  final String table;
  int roll;
  bool rolled = false;
  RolledBenefit(this.table);
  static RolledBenefit parse(d) {
    return RolledBenefit(d["table"]);
  }

  @override
  Character apply(Character c, Map<String, TermEffectTable> tables) {
    final parsedTable = tables[table].table;
    roll = dice.roll(1, parsedTable.length).first;
    rolled = true;
    return parsedTable[roll].apply(c, tables);
  }

  @override
  bool get hasChoice => false;
  @override
  String toString() => !rolled ?
    "roll on $table table" :
    "rolled: $roll on $table";
  String get route => type;

  @override
  TermEffect copy() => RolledBenefit(table);
}

class StatGainBenefit extends TermEffect {
  static String type = "statGain";
  final String stat;
  final int amount;
  StatGainBenefit(this.stat, this.amount);
  static StatGainBenefit parse(d) =>
    StatGainBenefit(d["stat"], d["amount"]);

  @override
  Character apply(Character c, Map<String, TermEffectTable> tables) {
    final newStats = mapMap(c.stats, (Statistic stat) => stat.name == this.stat ? stat.copy(
      score: stat.score + amount
    ): stat);

    return c.copy(
      stats: newStats
    );
  }

  @override
  bool get hasChoice => false;
  @override
  String toString() => "Adjust $stat by $amount";
  String get route => type;
  TermEffect copy() => this;
}

class SkillGainBenefit extends TermEffect {
  static String type = "skillGain";
  final String skill;
  final int amount;
  SkillGainBenefit(this.skill, this.amount);
  static SkillGainBenefit parse(d) {
    if(d["skill"] == null) {
      throw "missing skill in $d";
    }
    return SkillGainBenefit(d["skill"], d["amount"]);
  }

  @override
  bool get hasChoice => false;
  @override
  Character apply(Character c, Map<String, TermEffectTable> tables) {
    Map<String, Skill> newSkills = (c.skill(skill) == null) ?
      {...c.skills, skill: Skill(name:skill, rank: 0)} :
      mapMap(c.skills, (Skill skill) =>
        skill.name == this.skill ?
          skill.copy(rank: skill.rank + amount) :
          skill
      );

    return c.copy(skills: newSkills);
  }

  @override
  String toString() => "Adjust $skill by $amount";
  String get route => type;
  TermEffect copy() => this;
}

class SpecialisationGainBenefit extends TermEffect {
  static String type = "specialisationGain";
  final String skill;
  final String specialisation;
  final int amount;
  SpecialisationGainBenefit(this.skill, this.specialisation, this.amount);
  static SpecialisationGainBenefit parse(d) =>
    SpecialisationGainBenefit(d["skill"], d["specialisation"], d["amount"]);

  @override
  Character apply(Character c, Map<String, TermEffectTable> tables) {
    print("TODO! Fix specialisations!");
    return c;
  }

  @override
  bool get hasChoice => false;
  @override
  String toString() => "Adjust $skill ($specialisation) by $amount";
  String get route => type;
  TermEffect copy() => this;
}

class StatRaisedTo extends TermEffect {
  static String type = "statRasiedTo";
  final String stat;
  final int score;
  StatRaisedTo(this.stat, this.score);
  static StatRaisedTo parse(d) =>
    StatRaisedTo(d["stat"], d["score"]);
  @override
  bool qualifies(Character c) =>
    c.stat(stat).score < score;

  @override
  Character apply(Character c, Map<String, TermEffectTable> tables) {
    final s = c.stat(stat);
    if(s.score < score) {
      return c.copy(stats: mapMap(c.stats, (stat)=>
        stat.name == this.stat ?
          stat.copy(score: this.score - stat.score) :
          stat
      ));
    }
    return c;
  }

  @override
  bool get hasChoice => false;
  @override
  String toString() => "raise $stat to $score";
  String get route => type;
  TermEffect copy() => this;
}

class Certification extends TermEffect {
  static String type = "certification";
  final String code;
  Certification(this.code);
  static Certification parse(d) => Certification(d["code"]);

  @override
  Character apply(Character c, Map<String, TermEffectTable> tables) => c.copy(
    accreditations: (c.accreditations ?? []) + [code]
  );

  @override
  bool get hasChoice => false;
  @override
  String toString() => "gain $code certification";
  String get route => type;
  TermEffect copy() => this;
}

class ChooseBenefit extends TermEffect {
  static String type = "chooseBenefit";
  final List<TermEffect> options;
  final int picks;
  ChooseBenefit(this.options, this.picks);
  List<TermEffect> choice;

  static ChooseBenefit parse(d) =>
    ChooseBenefit(parseList(d, "options", TermEffect.parse), d['picks']?? 1);

  @override
  Character apply(Character c, Map<String, TermEffectTable> tables) =>
    choice.fold(c, (c, e) => e.apply(c, tables));

  @override
  bool get hasChoice => true;
  @override
  String toString() => (choice == null) ?
    "Choose from multiple benefits" :
    "${choice.join(", ")}";
  String get route => type;

  @override
  TermEffect copy() => ChooseBenefit(options.map((e) => e.copy()).toList(), picks);
}

class SkillRaisedTo extends TermEffect {
  static String type = "skillRaisedTo";
  final String skill;
  final int rank;
  SkillRaisedTo(this.skill, this.rank);
  static SkillRaisedTo parse(d) =>
    SkillRaisedTo(d["skill"], d["rank"]);
  @override
  bool qualifies(Character c) =>
    (c.skill(skill)?.rank?? -1) < rank;

  @override
  Character apply(Character c, Map<String, TermEffectTable> tables) {
    final newSkills =
      (c.skill(skill) == null) ?
        {...c.skills, skill: Skill(name: skill, rank: rank)} :
        mapMap(c.skills, (skill) => skill.name == this.skill ?
          skill.copy(rank: rank) :
          skill
        );
    return c.copy(skills: newSkills);
  }

  @override
  bool get hasChoice => false;
  @override
  String toString() => "raise $skill to $rank";
  String get route => type;
  TermEffect copy() => this;
}