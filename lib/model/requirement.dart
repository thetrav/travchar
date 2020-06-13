
import 'dart:convert';

import 'Character.dart';

abstract class Requirement {
  bool evaluate(Character c);
  static Requirement parse(dynamic data) {
    print("parsing requirement ${jsonEncode(data)}");
    return {
      "stat": StatRequirement.parse,
      "homeworld": HomeworldRequirement.parse,
      "skill": SkillRequirement.parse,
      "career": CareerRequirement.parse,
      "accreditation": AccreditationRequirement.parse,
      "or": OrRequirement.parse
    }[data['type'].toString()](data);
  }


  bool compareNum(int n, String compareString) {
    if (compareString.endsWith("+")) {
      return n > int.parse(compareString.substring(0, compareString.length - 1));
    }
    if (compareString.endsWith("-")) {
      return n < int.parse(compareString.substring(0, compareString.length - 1));
    }
    return n == int.parse(compareString);
  }
}

class OrRequirement extends Requirement {
  final List<Requirement> options;
  OrRequirement(this.options);
  static OrRequirement parse(d) =>
    OrRequirement(d["options"].map<Requirement>(Requirement.parse).toList());

  @override
  bool evaluate(Character c) =>
    options.any((r)=> r.evaluate(c));
}

class StatRequirement extends Requirement {
  final String stat;
  final String score;

  StatRequirement(this.stat, this.score);
  static StatRequirement parse(dynamic data) =>
    StatRequirement(data["stat"], data["score"]);

  @override
  bool evaluate(Character c) =>
    compareNum(
      c.stat(stat).score,
      score
    );
}

class SkillRequirement extends Requirement {
  final String skill;
  String rank;
  SkillRequirement(this.skill, this.rank);
  static SkillRequirement parse(dynamic data) =>
    SkillRequirement(data["name"], data["rank"]);

  @override
  bool evaluate(Character c) =>
    c.skills.containsKey(skill) &&
    compareNum(c.skills[skill].rank, rank);
}

class AccreditationRequirement extends Requirement {
  final String code;
  AccreditationRequirement(this.code);
  static AccreditationRequirement parse(d) =>
    AccreditationRequirement(d["code"]);

  @override
  bool evaluate(Character c) =>
    c.accredited(code);
}

class CareerRequirement extends Requirement {
  final String career;
  final String rank;
  CareerRequirement(this.career, this.rank);
  static CareerRequirement parse(data) =>
    CareerRequirement(data["name"], data["rank"]);

  @override
  bool evaluate(Character c) {
    return false;
  }
}

abstract class HomeworldRequirement extends Requirement {
  static HomeworldRequirement parse(d) => {
    "tradeCode": TradeCodeRequirement.parse,
    "gravity": GravityRequirement.parse,
    "uwpNum": UwpNumRequirement.parse
  }[d['subType']](d);

}

class TradeCodeRequirement extends HomeworldRequirement {
  final String code;
  TradeCodeRequirement(this.code);
  static TradeCodeRequirement parse(d) =>
    TradeCodeRequirement(d["code"]);

  @override
  bool evaluate(Character c) =>
    c.homeworld.trade.contains(code);

}

class GravityRequirement extends HomeworldRequirement {
  final double min;
  final double max;
  GravityRequirement(this.min, this.max);

  static GravityRequirement parse(d) =>
    GravityRequirement(d["min"], d["max"]);

  @override
  bool evaluate(Character c) {
    return c.homeworld.gravity > min && c.homeworld.gravity < max;
  }
}

class UwpNumRequirement extends HomeworldRequirement {
  final String code;
  final String num;
  UwpNumRequirement(this.code, this.num);
  static UwpNumRequirement parse(d) =>
    UwpNumRequirement(d['code'], d['num']);

  @override
  bool evaluate(Character c) =>
    compareNum(c.homeworld.uwpByCode(code), num);

}