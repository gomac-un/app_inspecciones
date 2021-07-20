import 'package:flutter/material.dart';

/// Pantalla mostrada cuando se navega entre pantallas
class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
