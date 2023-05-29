import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';

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
      {required Widget child, Color barrierColor = Colors.black38, bool showDoneButton = true}) async {
    await showDialog(
        context: context,
        barrierColor: barrierColor,
        builder: (context) => AlertDialog(
            elevation: 0,
            backgroundColor: Config.bgColor,
            alignment: Alignment.center,
            insetPadding: const EdgeInsets.symmetric(horizontal: Config.defaultPadding),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(children: [
                    child,
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: Visibility(
                          visible: showDoneButton,
                          child: SimpleButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: Config.primaryColor,
                            text: "Done",
                          ),
                        ))
                  ])
                ],
              ),
            )));
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
