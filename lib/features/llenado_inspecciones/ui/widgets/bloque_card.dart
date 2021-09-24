import 'package:flutter/material.dart';

class BloqueCard extends StatelessWidget {
  final Widget widgetBloque;
  const BloqueCard({Key? key, required this.widgetBloque}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(child: widgetBloque);
  }
}
