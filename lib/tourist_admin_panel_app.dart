import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/screens/home/home_screen.dart';

import 'config/config.dart';
import 'controllers/menu_app_controller.dart';
import 'model/tourist.dart';

class TouristAdminPanelApp extends StatelessWidget {
  const TouristAdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.appName,
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Config.bgColor,
          textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: Config.secondaryColor,
          sliderTheme: const SliderThemeData(
              valueIndicatorColor: Config.secondaryColor)),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuAppController(),
          ),
        ],
        child: const HomeScreen(),
      ),
    );
  }

  // static bool sent = false;
  //
  // void createTourists() {
  //   String text = '''''';
  //   List<String> names = text.split('\n');
  //   List<Tourist> tourists = [];
  //   print(names.length);
  //   Future.microtask(() async {
  //     if (sent) {
  //       return;
  //     }
  //     sent = true;
  //
  //     // for (int id = 13; id <= 112; id++) {
  //     //   await TouristApi().delete(Tourist(
  //     //       id: id,
  //     //       gender: Gender.male,
  //     //       firstName: "a",
  //     //       secondName: "a",
  //     //       birthYear: 1,
  //     //       skillCategory: SkillCategory.beginner));
  //     // }
  //     // List<String> errors = [];
  //     // for (var name in names) {
  //     //   var words = name.split(' ');
  //     //   int age = 18 + Random().nextInt(20);
  //     //   int genderIdx = Random().nextInt(Gender.values.length);
  //     //   int categoryIdx = Random().nextInt(SkillCategory.values.length);
  //     //   tourists.add(Tourist(
  //     //       id: 0,
  //     //       gender: Gender.values[genderIdx],
  //     //       firstName: words.first,
  //     //       secondName: words.last,
  //     //       birthYear: 2023 - age,
  //     //       skillCategory: SkillCategory.values[categoryIdx]));
  //     //   int? id = await TouristApi().create(tourists.last, errors);
  //     //   if (id == null) {
  //     //     print(errors);
  //     //     break;
  //     //   }
  //     //   print(name);
  //     // }
  //   });
  // }
}
