import 'package:flutter/cupertino.dart';

class ConditionBuilder extends StatelessWidget {
  const ConditionBuilder(
      {super.key,
      required this.condition,
      required this.ifFalse,
      required this.ifTrue});

  final bool condition;
  final Widget ifTrue;
  final Widget ifFalse;

  @override
  Widget build(BuildContext context) {
    return condition ? ifTrue : ifFalse;
  }
}
