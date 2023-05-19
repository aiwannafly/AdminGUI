import 'package:flutter/material.dart';

import '../config/config.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton(
      {super.key,
      required this.onPressed,
      required this.color,
      required this.text});

  final VoidCallback onPressed;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
        ),
        child: Container(
          padding: Config.paddingAll,
          child: Text(text, style: Theme.of(context).textTheme.titleMedium),
        ));
  }
}
