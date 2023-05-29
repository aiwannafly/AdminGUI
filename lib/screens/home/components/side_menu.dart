import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tourist_admin_panel/config/config.dart';
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
      CRUD.instructors => "instructor.png",
      CRUD.competitions => "competition.png",
      CRUD.sportsmen => "sportsman.png"
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
      CRUD.instructors => "Instructors",
      CRUD.competitions => "Competitions",
      CRUD.sportsmen => "Sportsmen"
    };
  }
}

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  static const limitMillis = 150;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final keyboardFocusNode = FocusNode();

  final List<DateTime> lastPressed = [DateTime.now()];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: getTiles(context)),
    );
    return KeyboardListener(
      focusNode: keyboardFocusNode,
      autofocus: true,
      onKeyEvent: (e) => handleKeyEvent(context, e),
      child: Drawer(
        child: ListView(children: getTiles(context)),
      ),
    );
  }

  void handleKeyEvent(BuildContext context, KeyEvent e) {
    var curr = DateTime.now();
    if (curr.difference(lastPressed.first).inMilliseconds <
        SideMenu.limitMillis) {
      return;
    }
    if (e.physicalKey == PhysicalKeyboardKey.arrowDown) {
      var current = context.read<MenuAppController>().currentCRUD();
      int nextIdx = (current.index + 1) % CRUD.values.length;
      context.read<MenuAppController>().changeCRUD(CRUD.values[nextIdx]);
      lastPressed.clear();
      lastPressed.add(curr);
      setState(() {});
    } else if (e.physicalKey == PhysicalKeyboardKey.arrowUp) {
      var current = context.read<MenuAppController>().currentCRUD();
      int nextIdx = current.index - 1;
      if (nextIdx < 0) {
        nextIdx = CRUD.values.length - 1;
      }
      context.read<MenuAppController>().changeCRUD(CRUD.values[nextIdx]);
      lastPressed.clear();
      lastPressed.add(curr);
      setState(() {});
    }
  }

  List<Widget> getTiles(BuildContext context) {
    List<Widget> res = [];
    res.add(DrawerHeader(
        child: Image.asset(
      "assets/images/logo.png",
      height: 200,
    )));
    res.addAll(CRUD.values.map((e) => DrawerListTile(
          item: e,
          onTap: () {
            setState(() {});
          },
        )));
    return res;
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.item,
    required this.onTap,
  }) : super(key: key);

  final CRUD item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool selected = context.read<MenuAppController>().currentCRUD() == item;
    return ListTile(
      onTap: () {
        context.read<MenuAppController>().changeCRUD(item);
        onTap();
      },
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        item.imagePath,
        height: 20,
      ),
      selected: selected,
      selectedTileColor: Config.bgColor.withOpacity(.5),
      hoverColor: Config.bgColor.withOpacity(.5),
      splashColor: Config.bgColor.withOpacity(.2),
      focusColor: Config.bgColor.withOpacity(.1),
      title: Text(
        item.name,
        style: TextStyle(color: selected ? Colors.white : Colors.white54),
      ),
    );
  }
}
