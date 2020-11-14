import 'package:flutter/material.dart';
import 'presentation/pages/home_screen.dart';
import 'injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      home: HomeScreen(), //InspeccionScreen(),
    ),
  );
}
