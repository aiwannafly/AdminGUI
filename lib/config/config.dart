import 'package:flutter/material.dart';

Widget centeredText(String text) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    softWrap: false,
    style: TextStyle(
      fontSize: 15,
      fontFamily: "Montserrat",
      color: Colors.grey.shade200
    ),
  );
}

class Config {
  static const appName = "Tourist Admin Panel";
  static const defaultRadius = 8.0;
  static const borderRadius = BorderRadius.all(Radius.circular(defaultRadius));
  static final iconColor = Colors.grey.shade400;
  static final menuColor = Colors.blue.shade200;
  static final backIconColor = Colors.grey.shade100;
  static final hoverColor = Colors.grey.shade300;
  static final backColor = Colors.grey.shade200; // Color(0xFF070824);
  static const primaryColor = Colors.pink;// Color(0xFF2697FF);
  static const secondaryColor = Color(0xFF3b1020);// Color(0xFF2A2D3E);
  static const secondaryColorDarken = Color(0xFF54152c);// Color(0xFF242839);
  static const buttonLightColor = Color(0xFFf280a9);// Colors.lightBlueAccent;
  static const bgColor = Color(0xFF290512); // Color(0xFF171928);
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
      overflow: TextOverflow.ellipsis,
      softWrap: false,
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
