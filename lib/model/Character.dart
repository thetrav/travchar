

import 'package:travchar/model/skill.dart';
import 'package:travchar/model/term.dart';

import 'Homeworld.dart';



class Character {
  String name;
  int age;
  Homeworld homeworld;
  Map<String, Statistic> stats;
  Map<String, Skill> skills;
  List<String> accreditations;
  List<Term> terms;

  Character({
    this.name,
    this.age,
    this.homeworld,
    this.stats,
    this.skills,
    this.accreditations,
    this.terms
  });

  Statistic stat(String s) => stats[s];
  bool accredited(String a) => accreditations?.contains(a) ?? false;

  Map<String, Skill> get specialisations {
    final specs = <String, Skill>{};
    skills.values.forEach ((skill) => skill.specialisations.forEach((s)=> specs[s.name] = s));
    return specs;
  }

  Skill skill(String name) {
    if(skills.containsKey(name)) {
      return skills[name];
    }
    return null;
  }

  Character copy({
    String name,
    int age,
    Homeworld homeworld,
    Map<String, Statistic> stats,
    Map<String, Skill> skills,
    List<String> accreditations,
    List<Term> terms
  }) {
    return Character(
      name: name ?? this.name,
      age: age ?? this.age,
      homeworld: homeworld ?? this.homeworld,
      stats: stats ?? this.stats,
      skills: skills ?? this.skills,
      accreditations: accreditations ?? this.accreditations,
      terms: terms ?? this.terms
    );
  }
}

class Statistic {
  String name;
  List<int> roll = [];
  int score;
  int get diceMod {
    if(score == 0) return -3;
    if(score >= 15) return 3;
    return (score/3-2).floor();
  }

  Statistic({this.name, this.roll, this.score});
  Statistic copy({String name, List<int> roll, int score}) =>
    Statistic(
      name: name ?? this.name,
      roll: roll ?? this.roll,
      score: score ?? this.score
    );
}