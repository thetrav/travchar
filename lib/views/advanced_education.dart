
import 'package:flutter/material.dart';
import 'package:travchar/model/Character.dart';
import 'package:travchar/model/tables.dart';
import 'package:tuple/tuple.dart';

class AdvancedEducation extends StatefulWidget {
  final Character character;
  final Tables tables;
  final String nextRoute;

  AdvancedEducation(this.nextRoute, Tuple2<Character, Tables> t):
    character = t.item1, tables = t.item2;

  @override
  State<StatefulWidget> createState() => AdvancedEducationState();
}

class AdvancedEducationState extends State<AdvancedEducation> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}