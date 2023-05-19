import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tourist_admin_panel/screens/home/home_screen.dart';

import 'config/config.dart';
import 'controllers/menu_app_controller.dart';

class TouristAdminPanelApp extends StatelessWidget {
  const TouristAdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Config.bgColor,
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: Config.secondaryColor,
      ),
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
}
