import 'package:flutter/material.dart';

import '../../model/bloques/preguntas/pregunta_numerica.dart';
import '../../control/controlador_de_pregunta.dart';

class WidgetPreguntaNumerica extends StatelessWidget {
  final PreguntaNumerica preguntaNumerica;
  final ControladorDePregunta controlador;
  const WidgetPreguntaNumerica(
    this.preguntaNumerica,
    this.controlador, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
