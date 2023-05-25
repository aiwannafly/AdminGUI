import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';

import '../config/config.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.imageName,
    this.imagePath = "assets/images/",
    this.width = 300,
    this.imageSize = 50
  });

  final VoidCallback onPressed;
  final String text;
  final String imageName;
  final String imagePath;
  final double width;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: imageSize,
              width: imageSize,
              child: Image.asset("$imagePath$imageName"),
            ),
            const SizedBox(
              width: Config.defaultPadding,
            ),
            SimpleButton(
                onPressed: onPressed,
                color: Config.secondaryColor,
                text: text)
          ],
        ));
  }
}
