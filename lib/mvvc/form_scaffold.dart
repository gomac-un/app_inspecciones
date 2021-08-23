import 'package:flutter/material.dart';

/// Widget usado como Scaffold de los formularios en creación y llenado de inspección
class FormScaffold extends StatelessWidget {
  final Widget body;
  final Widget title;
  final Widget? floatingActionButton;
  final List<Widget>? actions;

  const FormScaffold({
    Key? key,
    required this.body,
    required this.title,
    this.floatingActionButton,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: title,
        actions: actions,
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: Container(child: body),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatingActionButton,
    );
  }
}
