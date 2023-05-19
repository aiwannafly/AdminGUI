import 'package:flutter/cupertino.dart';
import 'package:tourist_admin_panel/config/config.dart';
import 'package:tourist_admin_panel/crud/tourist/tourist_crud.dart';
import 'package:tourist_admin_panel/screens/dashboard/components/header.dart';

import '../../crud/section_manager/section_manager_crud.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

enum CRUD {
  tourists, groups, sectionManagers
}

class DashboardScreenState extends State<DashboardScreen> {
  var current = CRUD.tourists;

  void setContent(CRUD crud) {
    setState(() {
      current = crud;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      primary: false,
      padding: Config.paddingAll * 2,
      child: Column(
        children: [
          const Header(),
          const SizedBox(height: Config.defaultPadding,),
          getContent(context)
        ],
      ),
    ));
  }

  Widget getContent(BuildContext context) {
    if (current == CRUD.tourists) {
      return const TouristCRUD();
    } else if (current == CRUD.groups) {
      return Config.defaultText("Groups");
    }
    return const SectionManagerCRUD();
  }
}
