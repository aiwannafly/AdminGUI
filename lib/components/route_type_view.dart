import 'package:flutter/cupertino.dart';
import 'package:tourist_admin_panel/model/route.dart';

class RouteTypeView extends StatelessWidget {
  const RouteTypeView({super.key, required this.routeType});

  final RouteType routeType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 50,
      width: 50,
      child: Image.asset(
          "assets/images/${routeType.string.toLowerCase()}.png"),);
  }
}
