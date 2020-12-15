import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/router.gr.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(
    MaterialApp(
      builder: ExtendedNavigator.builder(
        router: AutoRouter(),
        builder: (context, extendedNav) => Theme(
          data: customTheme, //TODO: seleccion de tema
          child: BlocProvider(
            create: (context) => getIt<AuthBloc>()..add(AppStarted()),
            child: extendedNav,
          ),
        ),
      ), //InspeccionScreen(),
    ),
  );
}

final customTheme = ThemeData(
  //brightness: Brightness.dark,
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  accentColor: Colors.deepPurple,
  highlightColor: Colors.purple,
  scaffoldBackgroundColor: Colors.blue,
  visualDensity: VisualDensity.compact,
  inputDecorationTheme: InputDecorationTheme(
    border: const UnderlineInputBorder(),
    fillColor: Colors.grey.withOpacity(.3),
    filled: true,
  ),
);
