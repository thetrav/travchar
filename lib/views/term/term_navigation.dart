import 'package:flutter/material.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/term/rolled_benefit.dart';
import 'package:travchar/model/term/term.dart';
import 'package:tuple/tuple.dart';

Future<TermEffect> getChoice(
  BuildContext c,
  Character character,
  TermEffect e) async {
  if(e is RolledBenefit) {
    dynamic effect = await Navigator.pushNamed(c, "/${e.rolledEffect.route}",
      arguments: Tuple2(character, e.rolledEffect));
    return e.copy(effect: effect as TermEffect);
  } else {
    dynamic effect = await Navigator.pushNamed(c, "/${e.route}",
      arguments: Tuple2(character, e));
    return effect as TermEffect;
  }
}