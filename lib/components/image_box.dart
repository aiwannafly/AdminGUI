import 'package:flutter/cupertino.dart';

import '../config/config.dart';

class ImageBox extends StatelessWidget {
  const ImageBox({
    super.key,
    required this.imageName,
    this.imagePath = "assets/images/",
    this.areaSize = 200,
    this.imageSize = 150
  });

  final String imageName;
  final String imagePath;
  final double areaSize;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: areaSize,
        width: areaSize,
        decoration: const BoxDecoration(
          color: Config.secondaryColor,
          borderRadius: Config.borderRadius
        ),
        alignment: Alignment.center,
        child: SizedBox(
          height: imageSize,
          width: imageSize,
          child: ClipRRect(
              borderRadius: Config.borderRadius,
              child: Image.asset("$imagePath$imageName")),
        ));
  }
}
