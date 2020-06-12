
import 'package:flutter/material.dart';

class TButton extends StatelessWidget {
  final String label;
  final Function onPress;
  TButton(this.label, this.onPress);

  @override
  Widget build(BuildContext context) =>
    RaisedButton(child: Text(label), onPressed: onPress,);
}