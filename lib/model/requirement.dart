
import 'dart:convert';

import '../util.dart';
import 'Character.dart';
import 'stat_check.dart';

abstract class Requirement {
  bool evaluate(Character c);
  static Requirement parse(dynamic data) {
    print("parsing requirement ${jsonEncode(data)}");
    return {
      "automatic": (d) => AutomaticPass(),
      "stat": StatRequirement.parse,
      "homeworld": HomeworldRequirement.parse,
      "skill": SkillRequirement.parse,
      "career": CareerRequirement.parse,
      "accreditation": AccreditationRequirement.parse,
      "or": OrRequirement.parse,
      "statCheck": StatCheck.parse,
      "bestStatCheck": BestStatCheck.parse
    }[data['type'].toString()](data);
  }

  bool compareNum(int n, String compareString) {
    if (compareString.endsWith("+")) {
      return n >= int.parse(compareString.substring(0, compareString.length - 1));
    }
    if (compareString.endsWith("-")) {
      return n <= int.parse(compareString.substring(0, compareString.length - 1));
    }
    return n == int.parse(compareString);
  }

}

class AutomaticPass extends Requirement {
  @override
  bool evaluate(Character c) => true;

  @override
  String toString() => "Automatic";
}

class OrRequirement extends Requirement {
  final List<Requirement> options;
  OrRequirement(this.options);
  static OrRequirement parse(d) =>
    OrRequirement(d["options"].map<Requirement>(Requirement.parse).toList());

  @override
  bool evaluate(Character c) =>
    options.any((r)=> r.evaluate(c));

  @override
  String toString() => "one of ${options.join(" or ")}";
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

  @override
  String toString() => "has $stat at $score";
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

  @override
  String toString() => "Has at $skill at $rank";
}

class AccreditationRequirement extends Requirement {
  final String code;
  AccreditationRequirement(this.code);
  static AccreditationRequirement parse(d) =>
    AccreditationRequirement(d["code"]);

  @override
  bool evaluate(Character c) =>
    c.accredited(code);

  @override
  String toString() => "Has $code accreditation";
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

  @override
  String toString() => "Has at least rank $rank in $career";

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
    c.homeworld.tradeCodes.contains(code);

  @override
  String toString() => "Homeworld has tradecode $code";
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

  @override
  String toString() => "Homeworld Gravity between $min and $max";
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

  @override
  String toString() => "Homeworld UWP $code is $num";
}

class BestStatCheck extends Requirement {
  final Map<String, int> stats;
  BestStatCheck(this.stats);
  static BestStatCheck parse(d) =>
    BestStatCheck(mapMap(d["stats"], (v)=> v as int));

  @override
  bool evaluate(Character c) {
    final best = stats.keys.fold<Statistic>(c.stat(stats.keys.first), (best, s) {
      final test = c.stat(s);
      return test.score > best.score ? test : best;
    });
    return StatCheck(best.name, stats[best.name]).evaluate(c);
  }

  @override
  String toString() => "Check against best of $stats";
}