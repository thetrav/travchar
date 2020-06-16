
import 'package:flutter/material.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/term.dart';
import 'package:travchar/views/skill_list.dart';
import 'package:travchar/views/stats/stat_table.dart';

class CharacterView extends StatelessWidget {
  final Character character;
  CharacterView(this.character);

  Widget termTile(Term term) => ListTile(
    title: Text(term.name),
    subtitle: Text(term.history.join(", "))
  );

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Text(character.name),
      Text("From ${character.homeworld.name}"),
      Text("${character.age} Years Old"),
      StatTable(character.stats),
    ];
    if(character.skills != null) {
      children.add(SkillListView(character.skills.values.toList()));
    }
    if(character.accreditations != null) {
      children.add(ListTile(
          title: Text("Certifications"),
          subtitle: Text(character.accreditations.join(", "))
      ));
    }
    if(character.terms != null) {
      children.addAll([
        Text("Terms:"),
        ...character.terms.map(termTile).toList()
      ]);
    }
    return Column(children:children);
  }
}

