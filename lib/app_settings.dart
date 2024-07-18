import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  var _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  static bool deactivateFirebaseAuth = false;
}
