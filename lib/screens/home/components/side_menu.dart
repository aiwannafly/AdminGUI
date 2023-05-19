import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tourist_admin_panel/controllers/menu_app_controller.dart';
import 'package:tourist_admin_panel/screens/dashboard/dashboard_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Tourists",
            svgSrc: "assets/icons/tourist.svg",
            press: () => context
                .read<MenuAppController>()
                .changeCRUD(CRUD.tourists),
          ),
          DrawerListTile(
            title: "Groups",
            svgSrc: "assets/icons/tourist.svg",
            press: () => context
                .read<MenuAppController>()
                .changeCRUD(CRUD.groups),
          ),
          DrawerListTile(
            title: "Section managers",
            svgSrc: "assets/icons/tourist.svg",
            press: () => context
                .read<MenuAppController>()
                .changeCRUD(CRUD.sectionManagers),
          ),
          DrawerListTile(
            title: "Sections",
            svgSrc: "assets/icons/tourist.svg",
            press: () => context
                .read<MenuAppController>()
                .changeCRUD(CRUD.sections),
          ),
          DrawerListTile(
            title: "Trainers",
            svgSrc: "assets/icons/tourist.svg",
            press: () => context
                .read<MenuAppController>()
                .changeCRUD(CRUD.trainers),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: const ColorFilter.mode(Colors.white54, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
