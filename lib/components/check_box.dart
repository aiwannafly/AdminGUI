import 'package:flutter/material.dart';

import '../config/config.dart';

class CheckBox<T> extends StatefulWidget {
  const CheckBox(
      {super.key, required this.item, required this.selected});

  final T item;
  final Set<T> selected;

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.contains(MaterialState.selected)) {
      return Colors.blue;
    }
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Config.secondaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: widget.selected.contains(widget.item),
      onChanged: (bool? selected) {
        if (selected == null) return;
        setState(() {
          if (selected) {
            widget.selected.add(widget.item);
          } else {
            widget.selected.remove(widget.item);
          }
        });
      },
    );
  }
}
