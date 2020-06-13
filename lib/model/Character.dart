

import 'package:travchar/model/skill.dart';

import '../util.dart';
import 'Homeworld.dart';

class Character {
  String name;
  int age;
  Homeworld homeworld;
  Map<String, Statistic> statRolls;
  Map<String, Skill> skills;

  Character({
    this.name,
    this.age,
    this.homeworld,
    this.statRolls,
    this.skills
  });

  Statistic stat(String s) => statRolls[s];

  Character copy({
    String name,
    int age,
    Homeworld homeworld,
    Map<String, Statistic> statRolls,
    Map<String, Skill> skills,
  }) {
    return Character(
      name: name ?? this.name,
      age: age ?? this.age,
      homeworld: homeworld ?? this.homeworld,
      statRolls: statRolls ?? this.statRolls,
      skills: skills ?? this.skills
    );
  }

}

class Statistic {
  String name;
  List<int> roll = [];
  List<StatAdjustment> adjustments;
  int get adjustmentScore => sum(adjustments.map((a)=> a.value)?.toList());
  int get score => sum(roll) + adjustmentScore;
  int get diceMod {
    if(score == 0) return -3;
    if(score >= 15) return 3;
    return (score/3-2).floor();
  }

  Statistic({this.name, this.roll, this.adjustments}){
    if(adjustments == null) {
      adjustments = [];
    }
  }
}

class StatAdjustment {
  String note;
  int value;

  StatAdjustment(this.value, this.note);
}