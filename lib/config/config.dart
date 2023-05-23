import 'package:flutter/material.dart';

class Config {
  static const defaultRadius = 8.0;
  static const borderRadius = BorderRadius.all(Radius.circular(defaultRadius));
  static final iconColor = Colors.grey.shade400;
  static final menuColor = Colors.blue.shade200;
  static final backIconColor = Colors.grey.shade100;
  static final hoverColor = Colors.grey.shade300;
  static const seedColor = Colors.blue;
  static final backColor = Colors.grey.shade200; // Color(0xFF070824);
  static const primaryColor = Color(0xFF2697FF);
  static const secondaryColor = Color(0xFF2A2D3E);
  static const bgColor = Color(0xFF171928);
  static const defaultPadding = 10.0;
  static const iconSize = 25.0;
  static const paddingAll = EdgeInsets.all(defaultPadding);
  static const fontFamily = "Montserrat";

  static double pageWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double pageHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Text defaultText(String text, [double fontSize = 18]) {
    return Text(
      text,
      style: defaultTextStyle(fontSize),
    );
  }

  static Widget centeredText(BuildContext context, String text) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  static TextStyle defaultTextStyle([double fontSize = 18]) {
    return TextStyle(
        color: Colors.grey.shade100,
        fontFamily: Config.fontFamily,
        fontSize: fontSize);
  }
}
