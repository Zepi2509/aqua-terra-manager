import 'package:aqua_terra_manager/locator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChangeNotifier extends ValueNotifier<ThemeMode> {
  final _prefs = locator<SharedPreferences>();

  ThemeChangeNotifier() : super(ThemeMode.system) {
    value = getThemeMode();
  }

  ThemeMode getThemeMode() {
    var themeModeString = _prefs.getString('themeMode') ?? '';

    if (themeModeString == ThemeMode.light.toString()) return ThemeMode.light;
    if (themeModeString == ThemeMode.dark.toString()) return ThemeMode.dark;
    return ThemeMode.system;
  }

  void updateTheme(ThemeMode themeMode) {
    value = themeMode;
    _prefs.setString('themeMode', themeMode.toString());
  }
}
