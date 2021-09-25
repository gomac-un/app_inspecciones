import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../control/controladores_de_pregunta/controlador_de_cuadricula.dart';
import '../../control/controladores_de_pregunta/controlador_de_pregunta_de_seleccion_multiple.dart';
import '../widgets/widget_cuadricula.dart';

class WidgetCuadriculaDeSeleccionMultiple extends StatelessWidget {
  final ControladorDeCuadriculaDeSeleccionMultiple controlador;
  const WidgetCuadriculaDeSeleccionMultiple(this.controlador, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetCuadricula(
      controlador,
      rowsBuilder: (controladorPregunta) => (controladorPregunta
              as ControladorDePreguntaDeSeleccionMultiple)
          .controladoresPreguntas
          .map((controladorSubPregunta) => ReactiveCheckbox(
                formControl: controladorSubPregunta.respuestaEspecificaControl,
              )),
    );
  }
}
