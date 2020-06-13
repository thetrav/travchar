import 'dart:convert';

class Skill {
  String name;
  int rank;
  List<Skill> specialisations;

  static List<Skill> load(String source) {
    Map<String, dynamic> raw = jsonDecode(source) as Map<String,dynamic>;
    return raw.keys.map<Skill>((k)=> Skill(
      name: k,
      rank: 0,
      specialisations: raw[k].map<Skill>(
        (s) => Skill(name: s, rank: 0, specialisations: [])
      ).toList()
    )).toList();
  }

  Skill({this.name, this.rank, this.specialisations});
}