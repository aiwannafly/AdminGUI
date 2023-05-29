import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';

import '../config/config.dart';

class ImageButton extends StatelessWidget {
  const ImageButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.imageName,
      this.imagePath = "assets/images/",
      this.width = 300,
      this.imageSize = 30,
      this.color = Config.secondaryColor});

  final VoidCallback onPressed;
  final String text;
  final String imageName;
  final String imagePath;
  final double width;
  final double imageSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SimpleButton(
        onPressed: onPressed,
        color: color,
        text: text,
        leading: SizedBox(
          height: imageSize,
          width: imageSize,
          child: Image.asset("$imagePath$imageName"),
        ),
      ),
    );
  }
}
