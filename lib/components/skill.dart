import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

class SkillView extends StatelessWidget {
  const SkillView({super.key, required this.skillCategory});

  final SkillCategory skillCategory;

  @override
  Widget build(BuildContext context) {
    String name = skillCategory.string;
    Color color = skillCategory == SkillCategory.beginner
        ? Colors.lightGreenAccent
        : skillCategory == SkillCategory.intermediate
        ? Colors.yellowAccent
        : Colors.redAccent;
    return Text(
      name,
      style: TextStyle(color: color, fontFamily: "Montserrat", fontSize: 16),
    );
  }
}