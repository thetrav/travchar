

import 'package:flutter/material.dart';
import 'package:travchar/components/TButton.dart';
import 'package:travchar/model/Character.dart';

class NameView extends StatelessWidget {
  final String nextRoute;
  NameView(this.nextRoute);

  final TextEditingController txt = new TextEditingController();
  @override
  Widget build(BuildContext c) =>
    Column(
      children: [
        TextField(controller: txt,
          decoration: InputDecoration(
            labelText: 'Name',
          )
        ),
        TButton("Start",
          () => Navigator.pushNamed(c, nextRoute, arguments: Character(
          name: txt.text,
          age: 1
          ))
        )
      ]
    );

}