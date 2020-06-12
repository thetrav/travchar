

import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final bool disabled;

  CircleButton(this.icon, this.onPressed, {this.disabled = false});

  @override
  Widget build(BuildContext context) => RawMaterialButton(
    onPressed: disabled ? null : onPressed,
    elevation: 2.0,
    fillColor: Colors.white,
    child: Icon(
      icon,
      size: 35.0,
    ),
    padding: EdgeInsets.all(15.0),
    shape: CircleBorder(),
  );
}