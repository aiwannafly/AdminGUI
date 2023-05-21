import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:tourist_admin_panel/config/config.dart';
import 'package:tourist_admin_panel/screens/dashboard/components/header.dart';

import '../../crud/crud_builder.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  var current = CRUD.tourists;
  final Map<CRUD, Widget> builders = HashMap();

  @override
  void initState() {
    super.initState();
    builders[current] = current.build();
  }

  void setContent(CRUD crud) {
    setState(() {
      builders.clear();
      current = crud;
      builders[current] = current.build();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      primary: true,
      padding: Config.paddingAll * 2,
      child: Column(
        children: [
          const Header(),
          const SizedBox(
            height: Config.defaultPadding,
          ),
          builders[current]!
        ],
      ),
    ));
  }
}
