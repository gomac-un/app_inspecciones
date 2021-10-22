import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) => ThemeNotifier(
          _buildGomacTheme(Brightness
              .light), //TODO: guardarlo y traerlo de un almacenamiento permanente
        ));

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier(ThemeData state) : super(state);
  switchTheme() => state.brightness == Brightness.light
      ? state = _buildGomacTheme(Brightness.dark)
      : state = _buildGomacTheme(Brightness.light);
}

ThemeData _buildGomacTheme(Brightness brightness) {
  //TODO: usar colores del logo de Gomac.
  const color1 = Colors.indigo;
  const color2 = Colors.orange;
  final primaryColor = brightness == Brightness.light ? color1 : color2;
  final secondaryColor = brightness == Brightness.light ? color2 : color1;

  return ThemeData(
    brightness: brightness,
    //primaryColor: primaryColor,
    primarySwatch: primaryColor,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: primaryColor,
      accentColor: secondaryColor,
      brightness: brightness,
    ),
    toggleableActiveColor: primaryColor,
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
    ),
  );
}

// ignore: unused_element
ThemeData _buildFlutterTheme(Brightness brightness) {
  switch (brightness) {
    case Brightness.dark:
      return ThemeData.dark();

    case Brightness.light:
      return ThemeData.light();
  }
}

// ignore: unused_element
ThemeData _buildGomacThemeFromBase(Brightness brightness) {
  final ThemeData baseTheme;
  switch (brightness) {
    case Brightness.dark:
      baseTheme = ThemeData.dark();
      break;
    case Brightness.light:
      baseTheme = ThemeData.light();
      break;
  }
  return baseTheme.copyWith(
    inputDecorationTheme: baseTheme.inputDecorationTheme.copyWith(
      filled: true,
    ),
    primaryColorLight: const Color.fromRGBO(229, 236, 233, 1),
    colorScheme: baseTheme.colorScheme.copyWith(
      primary: const Color.fromRGBO(28, 44, 59, 1),
      secondary: const Color.fromRGBO(237, 181, 34, 1),
    ),
    highlightColor: const Color.fromRGBO(237, 181, 34, 0.5),
    scaffoldBackgroundColor: const Color.fromRGBO(114, 163, 141, 1),
    visualDensity: VisualDensity.compact,
    textTheme: baseTheme.textTheme.copyWith(
      headline1: baseTheme.textTheme.headline1?.copyWith(
          fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.25),
    ),
    /*inputDecorationTheme: theme.inputDecorationTheme.copyWith(
      border: const UnderlineInputBorder(),
      fillColor: Colors.grey.withOpacity(.3),
      filled: true,
    ),*/
  );
}
