import 'dart:convert';

class Skill {
  String name;
  int rank;
  Skill parent;
  List<Skill> specialisations;

  static List<Skill> load(String source) {
    Map<String, dynamic> raw = jsonDecode(source) as Map<String,dynamic>;
    return raw.keys.map<Skill>((k) {
      final skill = Skill(
        name: k,
        rank: 0,
      );
      skill.specialisations = raw[k].map<Skill>(
          (s) => Skill(name: s, parent: skill, rank: 0, specialisations: [])
      ).toList();
      return skill;
    }).toList();
  }

  Skill({this.name, this.rank, this.parent, this.specialisations});
  Skill copy({String name, int rank, Skill parent, List<Skill>specialisations})
    => Skill(
      name: name ?? this.name,
      rank: rank ?? this.rank,
      parent: parent ?? this.parent,
      specialisations: specialisations ?? this.specialisations
    );

  @override
  String toString() {
    if(parent == null) {
      return "Skill: $name @$rank";
    } else {
      return "Skill: ${parent.name} ($name) @$rank";
    }
  }
}