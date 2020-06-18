

import 'package:flutter/material.dart';
import 'package:travchar/model/skill.dart';

class SkillListView extends StatelessWidget {

  final List<Skill> skills;
  SkillListView(this.skills);

  Widget skillTile(Skill skill) {
    final specialisations = skill.specialisations ?? [];
    return ListTile(
      title: Text(skill.name),
      leading: Text("${skill.rank}"),
      subtitle: Text(specialisations.map((s) => s.name).join(", "))
    );
  }

  @override
  Widget build(BuildContext context) =>
    Column(
      children: skills.where((s) => s.rank != null).map(skillTile).toList()
    );
}