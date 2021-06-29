import 'package:flutter/material.dart';

class FormScaffold extends StatelessWidget {
  
  final Widget body;
  final Widget title;
  final Widget floatingActionButton;
  final List<Widget> actions;

  const FormScaffold({
    this.body,
    this.title,
    this.floatingActionButton,
    this.actions,
  }) : super();

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
