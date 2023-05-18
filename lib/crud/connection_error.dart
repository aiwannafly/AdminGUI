import 'package:flutter/cupertino.dart';
import 'package:tourist_admin_panel/config/config.dart';

class ConnectionError extends StatelessWidget {
  const ConnectionError({super.key});

  @override
  Widget build(BuildContext context) {
    return Config.defaultText("Could not connect to database :/");
  }
}