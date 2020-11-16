import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/router.gr.dart';
import 'presentation/pages/home_screen.dart';
import 'injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(
    MaterialApp(
      builder: ExtendedNavigator.builder(
        router: AutoRouter(),
        builder: (context, extendedNav) => Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: extendedNav,
        ),
      ), //InspeccionScreen(),
    ),
  );
}
