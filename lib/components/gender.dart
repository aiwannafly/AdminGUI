import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

class GenderView extends StatelessWidget {
  const GenderView({super.key, required this.gender});

  final Gender gender;

  @override
  Widget build(BuildContext context) {
    IconData iconData = gender == Gender.male ? Icons.male : Icons.female;
    Color color = gender == Gender.male ? Colors.blue : Colors.pinkAccent;
    return Icon(
      iconData,
      color: color,
    );
  }

  Widget skillCategory(BuildContext context, SkillCategory skillCategory) {
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