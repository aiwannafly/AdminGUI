import 'package:tourist_admin_panel/controllers/menu_app_controller.dart';
import 'package:tourist_admin_panel/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../config/config.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: context.read<MenuAppController>().controlMenu,
            ),
          if (!Responsive.isMobile(context))
            Text(
              Config.appName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          if (!Responsive.isMobile(context))
            Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
          // const Expanded(child: SearchField()),
          const Spacer(),
          const ProfileCard()
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: Config.defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: Config.defaultPadding,
        vertical: Config.defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Config.secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/admin.png",
          ),
          if (!Responsive.isMobile(context))
            const Padding(
              padding:
              EdgeInsets.symmetric(horizontal: Config.defaultPadding / 2),
              child: Text("Admin"),
            ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: Config.secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          borderRadius: Config.borderRadius,
          child: Container(
            height: 40,
            width: 40,
            // padding: const EdgeInsets.all(Config.defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: Config.defaultPadding / 2),
            decoration: const BoxDecoration(
              color: Config.primaryColor,
              borderRadius: Config.borderRadius,
            ),
            child: Icon(Icons.search, color: Config.iconColor, size: 30,)
          ),
        ),
      ),
    );
  }
}