import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/hover_wrapper.dart';

import '../config/config.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton(
      {super.key,
      required this.onPressed,
      required this.color,
      this.leading,
      required this.text});

  final VoidCallback onPressed;
  final Color color;
  final String text;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    double paddingStride = leading == null ? 1.5 : 1;
    return HoverWrapper(
        onTap: onPressed,
        shadowColor:
            color == Config.secondaryColor ? Config.buttonLightColor : color,
        child: Container(
          decoration:
              BoxDecoration(color: color, borderRadius: Config.borderRadius),
          padding: Config.paddingAll * paddingStride,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leading ?? const SizedBox(),
              if (leading != null)
                const SizedBox(
                  width: Config.defaultPadding,
                ),
              Text(text, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ));
  }
}
