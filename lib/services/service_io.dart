import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tourist_admin_panel/components/input_label.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../config/config.dart';

class ServiceIO {
  ServiceIO._internal();

  factory ServiceIO() {
    return ServiceIO._internal();
  }

  void showProgressCircle(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future showWidget(BuildContext context,
      {required Widget child, Color barrierColor = Colors.black38}) async {
    await showDialog(
        context: context,
        barrierColor: barrierColor,
        builder: (context) => AlertDialog(
              elevation: 0,
              backgroundColor: Config.bgColor,
              alignment: Alignment.center,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child
                ],
              )
            ));
  }

  void showMessage(String text, BuildContext context,
      [bool noShadow = false, double height = 70]) {
    showDialog(
        barrierColor: noShadow ? Colors.transparent : Colors.black54,
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Config.bgColor,
              content: Container(
                alignment: Alignment.center,
                height: height,
                child: Config.defaultText(text, 20),
              ),
            ));
  }
}
