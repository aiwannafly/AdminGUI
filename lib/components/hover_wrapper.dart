import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';

class HoverWrapper extends StatefulWidget {
  const HoverWrapper(
      {super.key,
      this.onTap,
      this.shineWhenAppear = false,
      required this.child,
      this.shadowColor = Colors.lightBlueAccent});

  final VoidCallback? onTap;
  final Widget child;
  final Color shadowColor;
  final bool shineWhenAppear;

  @override
  State<HoverWrapper> createState() => _HoverWrapperState();
}

class _HoverWrapperState extends State<HoverWrapper> {
  bool hovered = false;
  static const duration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    if (widget.shineWhenAppear) {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          hovered = true;
        });
        Future.delayed(const Duration(milliseconds: 400), () {
          setState(() {
            hovered = false;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (h) {
        setState(() {
          hovered = h;
        });
        return;
      },
      child: AnimatedContainer(
          duration: duration,
          decoration: BoxDecoration(
              // color: !hovered ? Colors.blueGrey.shade900 :
              // Colors.grey.shade900,
              color: hovered ? Config.secondaryColor : Config.bgColor,
              borderRadius: Config.borderRadius,
              boxShadow: !hovered
                  ? []
                  : [
                      BoxShadow(
                          blurStyle: BlurStyle.outer,
                          color: widget.shadowColor,
                          blurRadius: 10)
                    ]),
          child: widget.child),
    );
  }
}
