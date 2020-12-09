import 'package:flutter/material.dart';

class FormScaffold extends StatelessWidget {
  final Widget body;
  final Widget title;

  const FormScaffold({Key key, this.body, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: title),
        body: SafeArea(
          child: Theme(
            data: Theme.of(context).copyWith(highlightColor: Colors.purple),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  //const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: this.body,
                ),
              ),
            ),
          ),
        ));
  }
}
