import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/router.gr.dart';
import 'injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(
    MaterialApp(
      builder: ExtendedNavigator.builder(
        router: AutoRouter(),
        builder: (context, extendedNav) => Theme(
          data: ThemeData(
              brightness: Brightness.dark, //TODO: seleccion de tema
              scaffoldBackgroundColor: Colors.lightBlue),
          child: extendedNav,
        ),
      ), //InspeccionScreen(),
    ),
  );
}
