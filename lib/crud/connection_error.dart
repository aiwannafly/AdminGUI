import 'package:flutter/cupertino.dart';
import 'package:tourist_admin_panel/config/config.dart';
import 'package:tourist_admin_panel/crud/selector.dart';

class ConnectionError extends StatelessWidget {
  const ConnectionError({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Selector.height(context),
        width: Selector.width(context),
        alignment: Alignment.center,
        child: Config.defaultText("Could not connect to database :/")
    );
  }
}