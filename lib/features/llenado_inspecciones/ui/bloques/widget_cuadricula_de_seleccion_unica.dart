import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../control/controladores_de_pregunta/controlador_de_cuadricula.dart';
import '../../control/controladores_de_pregunta/controlador_de_pregunta_de_seleccion_unica.dart';
import '../widgets/widget_cuadricula.dart';

class WidgetCuadriculaDeSeleccionUnica extends StatelessWidget {
  final ControladorDeCuadriculaDeSeleccionUnica controlador;
  const WidgetCuadriculaDeSeleccionUnica(this.controlador, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetCuadricula(
      controlador,
      rowsBuilder: (controladorPregunta) =>
          (controladorPregunta as ControladorDePreguntaDeSeleccionUnica)
              .pregunta
              .opcionesDeRespuesta
              .map((res) => ReactiveRadio(
                    formControl: controladorPregunta.respuestaEspecificaControl,
                    value: res,
                  )),
    );
  }
}
