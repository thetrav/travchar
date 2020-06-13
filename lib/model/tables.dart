import 'package:flutter/material.dart';
import 'package:travchar/model/Homeworld.dart';
import 'package:travchar/model/advanced_education.dart';
import 'package:travchar/model/background_skills_table.dart';
import 'package:travchar/model/skill.dart';

class Tables {
  static Future<Tables> load(BuildContext c) async {
    Future<T> load<T> (
      String name,
      T Function(String) builder) =>
      DefaultAssetBundle.of(c)
        .loadString("assets/$name.json")
        .then(builder);
    try {
      return Tables(
        await load("homeworlds", Homeworld.load),
        await load("skills", Skill.load),
        await load("background_skills", BackgroundSkillsTable.load),
        await load("education", AdvancedEducation.load)
      );
    } catch( e, s) {
      print("error: $e\n\t$s");
      throw e;
    }
  }

  Tables(
    this.homeworlds,
    this.skills,
    this.backgroundSkillsTable,
    this.advancedEducations
  );

  List<Homeworld> homeworlds;
  List<Skill> skills;
  BackgroundSkillsTable backgroundSkillsTable;
  List<AdvancedEducation> advancedEducations;
}