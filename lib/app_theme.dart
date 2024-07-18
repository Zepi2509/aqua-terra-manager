import 'package:aqua_terra_manager/constants.dart';
import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context, [bool? isDark]) {
  isDark = isDark ?? false;

  final baseTheme = isDark
      ? ThemeData.dark(useMaterial3: true)
      : ThemeData.light(useMaterial3: true);

  final appBarTheme = _appBarTheme(context);

  return baseTheme.copyWith(
    appBarTheme: appBarTheme,
    colorScheme: _colorScheme(isDark),
  );
}

AppBarTheme _appBarTheme(BuildContext context) =>
    Theme.of(context).appBarTheme.copyWith(
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: FontConstants.s500,
            fontWeight: FontWeight.bold,
          ),
        );

ColorScheme _colorScheme(bool isDark) {
  return ColorScheme.fromSeed(
    brightness: isDark ? Brightness.dark : Brightness.light,
    seedColor: const Color(0xFF012d48),
  );
}
