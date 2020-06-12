
import 'package:flutter/material.dart';
import 'package:travchar/model/Character.dart';

class CharacterView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CharacterViewState();
}

class CharacterViewState extends State<CharacterView> {
  Character character;
  int progress;

  @override
  void initState() {
    super.initState();
    progress = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}

