import 'package:flutter/material.dart';
import 'presentation/pages/home_screen.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(MaterialApp(
    theme: ThemeData.light(),
    home: HomeScreen(), //InspeccionScreen(),
  ));
}
