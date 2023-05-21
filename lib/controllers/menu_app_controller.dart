import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/screens/dashboard/dashboard_screen.dart';

import '../crud/crud_builder.dart';

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<DashboardScreenState> _dashboardKey = GlobalKey<DashboardScreenState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  GlobalKey<DashboardScreenState> get dashboardKey => _dashboardKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  void changeCRUD(CRUD crud) {
    _dashboardKey.currentState!.setContent(crud);
  }
}