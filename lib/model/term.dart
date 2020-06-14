import 'package:travchar/model/Character.dart';
import 'package:travchar/model/Dice.dart';
import 'package:travchar/model/advanced_education.dart';
import 'package:travchar/model/skill.dart';

import '../util.dart';

abstract class Term {
  final List<TermEffect> effects;
  final List<String> history;
  String get route;
  Term(this.effects, this.history);
}

class EducationTerm extends Term {
  String get route => "/term/education";
  AdvancedEducation education;
  EducationTerm({this.education, List<TermEffect> effects, List<String> history}):
    super(effects, history);
}

abstract class TermEffect {
  Character apply(Character c);
  static TermEffect parse(d) {
    print("parsing Term Effect $d");
    return {
      YearsPass.type: YearsPass.parse,
      ChooseSkills.type: ChooseSkills.parse,
      RolledBenefit.type: RolledBenefit.parse,
      StatGainBenefit.type: StatGainBenefit.parse,
      SkillGainBenefit.type: SkillGainBenefit.parse,
      SpecialisationGainBenefit.type: SpecialisationGainBenefit.parse,
      ChooseBenefit.type: ChooseBenefit.parse,
      StatRaisedTo.type: StatRaisedTo.parse,
      Certification.type: Certification.parse
    }[d["type"]](d);
  }
  String get route;
}

class YearsPass extends TermEffect {
  static String type = "yearsPass";
  final int years;
  YearsPass(this.years);
  static YearsPass parse(d) => YearsPass(d["years"]);
  @override
  Character apply(Character c) => c.copy(age: c.age + years);

  @override
  String toString() => "$years years pass";
  String get route => type;
}

class RolledBenefit extends TermEffect {
  static String type = "rolledBenefit";
  final String table;
  Map<int, TermEffect> parsedTable;
  RolledBenefit(this.table);
  static RolledBenefit parse(d) {
    return RolledBenefit(d["table"]);
  }

  @override
  Character apply(Character c) {
    int roll = dice.roll(1,parsedTable.length).first;
    print("rolled $roll on $table");
    return parsedTable[roll-1].apply(c);
  }

  @override
  String toString() => "roll on $table table";
  String get route => type;
}

class StatGainBenefit extends TermEffect {
  static String type = "statGain";
  final String stat;
  final int amount;
  StatGainBenefit(this.stat, this.amount);
  static StatGainBenefit parse(d) =>
    StatGainBenefit(d["stat"], d["amount"]);

  @override
  Character apply(Character c) {
    c.stat(stat).adjustments.add(StatAdjustment(amount, "Stat Gain Benefit"));
  }

  @override
  String toString() => "Adjust $stat by $amount";
  String get route => type;
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
  Character apply(Character c) {
    Skill oldSkill = c.skill(skill);
    if(oldSkill == null) {
      c.skills[skill] = Skill(name:skill, rank: 0);
    } else {
      oldSkill.rank += amount;
    }
    return c;
  }

  @override
  String toString() => "Adjust $skill by $amount";
  String get route => type;
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
  Character apply(Character c) {
    Skill oldSkill = c.skill(skill);
    if(oldSkill == null) {
      c.skills[skill] = Skill(name:skill, rank: 0);
    } else {
      oldSkill.rank += amount;
    }
    return c;
  }

  @override
  String toString() => "Adjust $skill ($specialisation) by $amount";
  String get route => type;
}

class ChooseSkills extends TermEffect {
  static String type = "chooseSkills";
  final int level;
  final int picks;
  final List<String> tables;
  List<Skill> selected = [];
  ChooseSkills({this.level, this.picks, this.tables});
  static ChooseSkills parse(d) => ChooseSkills(
    level: d["level"],
    picks: d["picks"],
    tables: stringList(d["tables"])
  );

  Character apply(Character c) {
    final skills = {...c.skills};
    selected.forEach((s) {
      if(skills.containsKey(s.name) && skills[s.name].rank < level) {
        skills[s.name] = Skill(name: s.name, rank: level);
      }
    });
    return c.copy(
      skills: skills
    );
  }

  @override
  String toString() => "Chose $picks skills to have at rank $level from $tables";
  String get route => type;
}

class StatRaisedTo extends TermEffect {
  static String type = "statRasiedTo";
  final String stat;
  final int score;
  StatRaisedTo(this.stat, this.score);
  static StatRaisedTo parse(d) =>
    StatRaisedTo(d["stat"], d["score"]);

  @override
  Character apply(Character c) {
    final s = c.stat(stat);
    if(s.score < score) {
      s.adjustments.add(StatAdjustment(
        score - s.score,
        "Stat Raised Term Effect"
      ));
    }
    return c;
  }

  @override
  String toString() => "raise $stat to $score";
  String get route => type;
}

class Certification extends TermEffect {
  static String type = "certification";
  final String code;
  Certification(this.code);
  static Certification parse(d) => Certification(d["code"]);

  @override
  Character apply(Character c) => c.copy(
    accreditations: (c.accreditations ?? []) + [code]
  );

  @override
  String toString() => "gain $code certification";
  String get route => type;
}

class ChooseBenefit extends TermEffect {
  static String type = "chooseBenefit";
  final List<TermEffect> options;
  ChooseBenefit(this.options);
  TermEffect choice;

  static ChooseBenefit parse(d) =>
    ChooseBenefit(parseList(d, "options", TermEffect.parse));

  @override
  Character apply(Character c) =>
    choice.apply(c);

  @override
  String toString() => "Choose from ${options.join(" or ")}";
  String get route => type;
}