import 'package:flutter/material.dart';

class PreguntaQuemada extends StatelessWidget {
  final String textoPregunta;
  final Widget respuesta;

  const PreguntaQuemada({Key key, this.textoPregunta, this.respuesta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      //margin: const EdgeInsets.all(8.0),
      /*decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),*/
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              textoPregunta,
              style: textTheme.headline6,
            ),
          ),
          respuesta,
        ],
      ),
    );
  }
}
