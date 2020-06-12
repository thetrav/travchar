
import 'package:flutter/material.dart';

import 'circle_button.dart';

class TickerController {
  int value = 0;
}

class TTicker extends StatefulWidget {
  final TickerController controller;
  final int min;
  final int max;
  TTicker(this.controller, {this.min=0, this.max});
  @override
  State<StatefulWidget> createState() => _TTicker();
}

class _TTicker extends State<TTicker> {
  void tick(int change) {
    int newVal = widget.controller.value + change;
    if(newVal >= widget.min && newVal <= widget.max) {
      widget.controller.value = newVal;
    }
  }

  @override
  Widget build(BuildContext context) =>
    Row(
      children: [
        CircleButton(Icons.arrow_downward,
          ()=> setState(()=>tick(-1)),
          disabled: widget.controller.value <= widget.min
        ),
        Text("${widget.controller.value}"),
        CircleButton(Icons.arrow_upward,
          ()=> setState(()=>tick(1)),
          disabled: widget.controller.value >= widget.max
        ),
      ]
    );
}