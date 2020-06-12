
import 'package:flutter/material.dart';

class DropDownController {
  String selected;
  DropDownController(this.selected);
}

class DropDown extends StatefulWidget {
  final DropDownController controller;
  final List<String> options;
  final String nullOption;
  final Function(String) onChange;

  DropDown(this.controller, this.options, {this.nullOption, this.onChange});

  @override
  State<StatefulWidget> createState() => _DropDown();
}

class _DropDown extends State<DropDown> {


  @override
  Widget build(BuildContext context) {
    final options = widget.options.map((s) =>
      DropdownMenuItem(
        value: s,
        child: Text(s)
      )).toList();
    if(widget.nullOption != null) {
      options.insert(0, DropdownMenuItem(
        value: null,
        child: Text(widget.nullOption)
      ));
    }
    return DropdownButton<String>(
      value: widget.controller.selected,
      items: options,
      onChanged: (v) => setState(() {
        widget.controller.selected = v;
        if(widget.onChange != null) {
          widget.onChange(v);
        }
      })
    );
  }
}