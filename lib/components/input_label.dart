import 'package:flutter/material.dart';

import '../config/config.dart';

class InputLabel extends StatelessWidget {
  const InputLabel({super.key, required this.controller, required this.hintText, this.suffixIcon});

  final TextEditingController controller;
  final String hintText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Config.secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: Config.borderRadius,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
