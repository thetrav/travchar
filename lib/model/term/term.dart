import 'package:travchar/model/Character.dart';

import 'package:travchar/model/advanced_education.dart';
import 'package:travchar/model/term/apply_all_benefit.dart';

import '../../util.dart';
import 'choose_term_benefit.dart';
import 'rolled_benefit.dart';
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
  Character apply(Character c);
  bool qualifies(Character c) => true;
  static TermEffect parse(d, Map<String, TermEffectTable> tables) {
    print("parsing Term Effect $d");
    return <String, TermEffect Function(dynamic, Map<String, TermEffectTable>)>{
      ApplyAllBenefit.type: ApplyAllBenefit.parse,
      YearsPass.type: YearsPass.parse,
      RolledBenefit.type: RolledBenefit.parse,
      StatGainBenefit.type: StatGainBenefit.parse,
      SkillGainBenefit.type: SkillGainBenefit.parse,
      SpecialisationGainBenefit.type: SpecialisationGainBenefit.parse,
      ChooseBenefit.type: ChooseBenefit.parse,
      StatRaisedTo.type: StatRaisedTo.parse,
      SkillRaisedTo.type: SkillRaisedTo.parse,
      Certification.type: Certification.parse
    }[d["type"]](d, tables);
  }
  String get route;

  TermEffect copy();
}

class YearsPass extends TermEffect {
  static String type = "yearsPass";
  final int years;
  YearsPass(this.years);
  static YearsPass parse(d, tables) => YearsPass(d["years"]);
  @override
  Character apply(Character c) => c.copy(age: c.age + years);
  @override
  bool get hasChoice => false;
  @override
  String toString() => "$years years pass";
  String get route => type;
  TermEffect copy() => this;
}


class StatGainBenefit extends TermEffect {
  static String type = "statGain";
  final String stat;
  final int amount;
  StatGainBenefit(this.stat, this.amount);
  static StatGainBenefit parse(d, tables) =>
    StatGainBenefit(d["stat"], d["amount"]);

  @override
  Character apply(Character c) {
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
  static SkillGainBenefit parse(d, tables) {
    if(d["skill"] == null) {
      throw "missing skill in $d";
    }
    return SkillGainBenefit(d["skill"], d["amount"]);
  }

  @override
  bool get hasChoice => false;
  @override
  Character apply(Character c) {
    return c.copy(skills: c.skills.map((s) =>
      s.name == skill ?
        s.copy(rank: (s.rank ?? 0) + amount) :
        s
    ).toList());
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
  static SpecialisationGainBenefit parse(d, tables) =>
    SpecialisationGainBenefit(d["skill"], d["specialisation"], d["amount"]);

  @override
  Character apply(Character c) {
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
  static StatRaisedTo parse(d, tables) =>
    StatRaisedTo(d["stat"], d["score"]);
  @override
  bool qualifies(Character c) =>
    c.stat(stat).score < score;

  @override
  Character apply(Character c) {
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
  static Certification parse(d, tables) => Certification(d["code"]);

  @override
  Character apply(Character c) => c.copy(
    accreditations: (c.accreditations ?? []) + [code]
  );

  @override
  bool get hasChoice => false;
  @override
  String toString() => "gain $code certification";
  String get route => type;
  TermEffect copy() => this;
}

class SkillRaisedTo extends TermEffect {
  static String type = "skillRaisedTo";
  final String skill;
  final int rank;
  SkillRaisedTo(this.skill, this.rank);
  static SkillRaisedTo parse(d, tables) =>
    SkillRaisedTo(d["skill"], d["rank"]);
  @override
  bool qualifies(Character c) =>
    (c.skill(skill)?.rank?? -1) < rank;

  @override
  Character apply(Character c) {
    return c.copy(skills: c.skills.map((s) =>
      s.name == skill && (s.rank ?? -1) < rank ? s.copy(rank: rank) : s
    ).toList());
  }

  @override
  bool get hasChoice => false;
  @override
  String toString() => "raise $skill to $rank";
  String get route => type;
  TermEffect copy() => this;
}