import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../control/controladores_de_pregunta/controlador_de_pregunta_de_seleccion_multiple.dart';
import '../widgets/dialog_pregunta.dart';

class WidgetPreguntaDeSeleccionMultiple extends StatelessWidget {
  final ControladorDePreguntaDeSeleccionMultiple controlador;

  const WidgetPreguntaDeSeleccionMultiple(
    this.controlador, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: controlador.controladoresPreguntas
          .map((controladorSubPregunta) => ReactiveCheckboxListTile(
                title: Text(controladorSubPregunta.pregunta.titulo),
                formControl: controladorSubPregunta.respuestaEspecificaControl,
                controlAffinity: ListTileControlAffinity.leading,
                secondary: IconButton(
                  icon: IconDialogPregunta(
                      controladorPregunta: controladorSubPregunta),
                  onPressed: () =>
                      mostrarDialogPregunta(context, controladorSubPregunta),
                ),
              ))
          .toList(),
    );
  }
}
