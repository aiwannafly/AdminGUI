import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_admin_panel/controllers/menu_app_controller.dart';

import '../../../crud/crud_builder.dart';

extension CRUDView on CRUD {
  static const path = "assets/images/";

  String get imagePath {
    String postfix = switch (this) {
      CRUD.tourists => "tourist_male.png",
      CRUD.groups => "group.png",
      CRUD.sectionManagers => "manager.png",
      CRUD.sections => "section.png",
      CRUD.trainers => "trainer.png",
      CRUD.schedules => "schedule.png",
      CRUD.activities => "activity.png",
      CRUD.routes => "route.png",
      CRUD.trips => "trip.png",
      CRUD.competitions => "competition.png"
    };
    return "$path$postfix";
  }

  String get name {
    return switch (this) {
      CRUD.tourists => "Tourists",
      CRUD.groups => "Groups",
      CRUD.sectionManagers => "Managers",
      CRUD.sections => "Sections",
      CRUD.trainers => "Trainers",
      CRUD.schedules => "Schedules",
      CRUD.activities => "Activities",
      CRUD.routes => "Routes",
      CRUD.trips => "Trips",
      CRUD.competitions => "Competitions"
    };
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: getTiles(context)),
    );
  }

  List<Widget> getTiles(BuildContext context) {
    List<Widget> res = [];
    res.add(DrawerHeader(
        child: Image.asset(
      "assets/images/logo.png",
      height: 200,
    )));
    res.addAll(CRUD.values.map((e) => DrawerListTile(item: e)));
    return res;
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.item,
  }) : super(key: key);

  final CRUD item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.read<MenuAppController>().changeCRUD(item),
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        item.imagePath,
        height: 20,
      ),
      title: Text(
        item.name,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
