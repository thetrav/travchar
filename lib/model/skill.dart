import 'dart:convert';

import 'package:travchar/util.dart';

class Skill {
  String name;
  int rank;
  List<Specialisation> specialisations;
  List<SubSkill> subSkills;

  static List<Skill> load(String source)=>
    jsonDecode(source).map<Skill>((raw) =>
      Skill.parse(raw)
    ).toList();

  static Skill parse(d) {
    final skill = Skill(
      name: d["name"],
      rank: null,
    );
    skill.specialisations = parseList(d, "specialisations", Specialisation.parse);
    skill.subSkills = parseList(d, "subSkills", SubSkill.parse);
    return skill;
  }

  Skill({this.name, this.rank, this.specialisations, this.subSkills});
  Skill copy({String name, int rank,
    List<Specialisation>specialisations,
    List<SubSkill> subSkills})
    => Skill(
      name: name ?? this.name,
      rank: rank ?? this.rank,
      specialisations: specialisations ?? this.specialisations,
      subSkills: subSkills ?? this.subSkills
    );

  @override
  String toString() {
    final start = "Skill: $name @$rank";
    if(specialisations != null) {
      return "$start: ${specialisations.join(", ")}";
    } else if (subSkills != null) {
      return "$start: ${subSkills.join(",")}";
    } else {
      return start;
    }
  }
}

class SubSkill {
  String name;
  int rank;

  SubSkill({this.name, this.rank});
  SubSkill copy({String name, int rank, Skill parent}) => SubSkill(
    name: name ?? this.name,
    rank: rank ?? this.rank
  );

  static SubSkill parse(d) => SubSkill(
    name: d as String,
    rank: null
  );

  @override
  String toString() => "SubSkill $name @$rank";
}

class Specialisation {
  String name;
  int rank;

  Specialisation({this.name, this.rank});
  Specialisation copy({String name, int rank, Skill parent}) => Specialisation(
    name: name ?? this.name,
    rank: rank ?? this.rank
  );
  static Specialisation parse(d) => Specialisation(
    name: d as String,
    rank: null
  );

  @override
  String toString() => "Specialisation $name @$rank";
}