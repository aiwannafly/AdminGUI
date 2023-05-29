import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/tourist_admin_panel_app.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:window_size/window_size.dart';
import 'package:flutter/services.dart';

import 'config/config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowTitle(Config.appName);
      setWindowMinSize(const Size(860, 480));
    }
    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
  }
  runApp(const TouristAdminPanelApp());
}
