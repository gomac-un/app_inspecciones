import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) =>
    ThemeNotifier(
        _buildGomacTheme(
            ref.watch(localPreferencesDataSourceProvider).getTema() ?? true
                ? Brightness.light
                : Brightness.dark),
        ref.read));

class ThemeNotifier extends StateNotifier<ThemeData> {
  final Reader read;
  ThemeNotifier(ThemeData state, this.read) : super(state);
  void switchTheme() {
    state.brightness == Brightness.light
        ? _setTheme(Brightness.dark)
        : _setTheme(Brightness.light);
  }

  void _setTheme(Brightness brightness) {
    read(localPreferencesDataSourceProvider)
        .saveTema(brightness == Brightness.light);
    state = _buildGomacTheme(brightness);
  }
}

const MaterialColor gomacPrimaryColor = MaterialColor(
  _gomacPrimaryValue,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFadb2b9),
    200: Color(0xFFd5d8db),
    300: Color(0xFF868e97),
    400: Color(0xFF203040),
    500: Color(_gomacPrimaryValue),
    600: Color.fromRGBO(28, 44, 59, .8),
    700: Color.fromRGBO(28, 44, 59, .6),
    800: Color.fromRGBO(28, 44, 59, .4),
    900: Color.fromRGBO(28, 44, 59, .2),
  },
);

const MaterialColor gomacSecondaryColor = MaterialColor(
  _gomacSecondaryValue,
  <int, Color>{
    50: Color(0xFFfff3dc),
    100: Color(0xFFffe6ba),
    200: Color(0xFFffdb98),
    300: Color(0xFFfccf76),
    400: Color(0xFFf6c351),
    500: Color(_gomacSecondaryValue),
    600: Color(0xFFe1b03e),
    700: Color(0xFFd4a000),
    800: Color(0xFFe2ac0e),
    900: Color(0xFFc69400),
  },
);
const int _gomacPrimaryValue = 0xFF1c2c3b;
const int _gomacSecondaryValue = 0xFFf0b823;

ThemeData _buildGomacTheme(Brightness brightness) {
  const color1 = gomacPrimaryColor;
  const color2 = gomacSecondaryColor;
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
      backgroundColor: Colors.grey,
    ),
    toggleableActiveColor: primaryColor,
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
    ),
    textTheme: const TextTheme(headline6: TextStyle(color: Colors.grey)),
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
