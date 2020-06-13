import 'package:flutter/material.dart';
import 'package:travchar/views/advanced_education_view.dart';
import 'package:tuple/tuple.dart';

import 'model/Character.dart';
import 'model/tables.dart';
import 'util.dart';
import 'views/background_skills_view.dart';
import 'views/homeworld_view.dart';
import 'views/name_view.dart';
import 'views/stats_view.dart';

Tuple2<Character, Tables> cargs(BuildContext c) =>
  arg<Tuple2<Character, Tables>>(c);

final routes = <String, Widget Function(BuildContext)>{
  "/": (c) => NameView("/build/1"),
  "/build/1": (c) => HomeworldView("/build/2", arg<Character>(c)),
  "/build/2": (c) => StatsView("/build/3", cargs(c)),
  "/build/3": (c) => BackgroundSkillsView("/build/4", cargs(c)),
  "/build/4": (c) => AdvancedEducationView("/build/5", cargs(c))
};