import 'package:flutter/material.dart';

import 'model/Character.dart';
import 'util.dart';
import 'views/background_skills_view.dart';
import 'views/homeworld_view.dart';
import 'views/name_view.dart';
import 'views/stats_view.dart';

final routes = <String, Widget Function(BuildContext)>{
  "/": (c) => NameView("/build/1"),
  "/build/1": (c) => HomeworldView("/build/2", arg<Character>(c)),
  "/build/2": (c) => StatsView("/build/3", arg<Character>(c)),
  "/build/3": (c) => BackgroundSkillsView("/build/4", arg<Character>(c))
};