
import 'Character.dart';

abstract class Requirement {
  bool evaluate(Character c);
  static Requirement parse(dynamic data) => {
    "stat": StatRequirement.parse
  }[data['type'].toString()](data);


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

class StatRequirement extends Requirement {
  final String name;
  final String diceMod;

  StatRequirement(this.name, this.diceMod);
  static StatRequirement parse(dynamic data) =>
    StatRequirement(data["name"], data["dm"]);

  @override
  bool evaluate(Character c) =>
    compareNum(
      c.stat(name).diceMod,
      diceMod
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