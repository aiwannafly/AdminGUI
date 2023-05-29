import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_admin_panel/responsive.dart';
import 'package:tourist_admin_panel/screens/dashboard/dashboard_screen.dart';
import 'package:tourist_admin_panel/screens/home/components/side_menu.dart';

import '../../controllers/menu_app_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            Expanded(flex: 1, child: SideMenu()),
          Expanded(
              flex: 5,
              child: DashboardScreen(
                key: context.read<MenuAppController>().dashboardKey,
              ))
        ],
      )),
    );
  }
}
