import 'package:flutter/material.dart';
import 'package:travchar/model/advanced_education.dart';
import 'package:travchar/views/term/choose_effect.dart';
import 'package:travchar/views/term_applicaiton_view.dart';
import 'package:tuple/tuple.dart';

import 'model/Character.dart';
import 'model/tables.dart';
import 'model/term.dart';
import 'util.dart';
import 'views/background_skills_view.dart';
import 'views/homeworld_view.dart';
import 'views/name_view.dart';
import 'views/stats_view.dart';
import 'views/term_education_view.dart';

Tuple2<Character, Tables> cargs(BuildContext c) =>
  arg<Tuple2<Character, Tables>>(c);

final routes = <String, Widget Function(BuildContext)>{
  "/": (c) => NameView("/build/1"),
  "/build/1": (c) => HomeworldView("/build/2", arg<Character>(c)),
  "/build/2": (c) => StatsView("/build/3", cargs(c)),
  "/build/3": (c) => BackgroundSkillsView(TermApplicationView.route, cargs(c)),
  TermApplicationView.route: (c) => TermApplicationView(
    educationRoute: TermEducationView.route,
    careerRoute: "/build/career",
    t: cargs(c)
  ),
  TermEducationView.route: (c) => TermEducationView(
    TermApplicationView.route,
    arg<Tuple3<AdvancedEducation, Character, Tables>>(c)
  ),
  ChooseEffectView.route: (c) {
    return ChooseEffectView(arg<Tuple2<
      Character,
      TermEffect
    >>(c));
  }
};