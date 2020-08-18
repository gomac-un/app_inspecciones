import 'package:flutter/material.dart';

class PreguntaForm extends StatelessWidget {
  final String textoPregunta;
  final Widget respuesta;

  const PreguntaForm({Key key, this.textoPregunta, this.respuesta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          Text(textoPregunta),
          respuesta,
          Row(
            children: [
              //MaterialButton(onPressed: null),
              Text("solucionado"),
              Checkbox(value: false, onChanged: null),
            ],
          ),
        ],
      ),
    );
  }
}

class PreguntaCreateForm extends StatelessWidget {
  final String textoPregunta;
  final Widget respuesta;

  const PreguntaCreateForm({Key key, this.textoPregunta, this.respuesta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      //margin: const EdgeInsets.all(8.0),
      /*padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),*/
      child: Column(
        children: [
          Text(
            textoPregunta,
            style: textTheme.headline6,
          ),
          respuesta,
        ],
      ),
    );
  }
}
