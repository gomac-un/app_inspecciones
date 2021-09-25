import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
    (ref) => ThemeNotifier(ThemeData.light()));

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier(ThemeData state) : super(state);
  switchTheme() => state.brightness == Brightness.light
      ? state = ThemeData.dark()
      : state = ThemeData.light();
}
