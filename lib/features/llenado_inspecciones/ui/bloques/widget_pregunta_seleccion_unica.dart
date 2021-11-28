import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../control/controladores_de_pregunta/controlador_de_pregunta_de_seleccion_unica.dart';
import '../../domain/bloques/preguntas/opcion_de_respuesta.dart';
import '../widgets/widget_criticidad_inspector.dart';

class WidgetPreguntaDeSeleccionUnica extends StatelessWidget {
  final ControladorDePreguntaDeSeleccionUnica controlador;

  const WidgetPreguntaDeSeleccionUnica(
    this.controlador, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReactiveDropdownField(
          isExpanded: true,
          itemHeight: null,
          items: controlador.pregunta.opcionesDeRespuesta
              .map((e) => DropdownMenuItem(value: e, child: Text(e.titulo)))
              .toList(),
          formControl: controlador.respuestaEspecificaControl,
          validationMessages: (control) => {
            ValidationMessage.required: 'Seleccione una opción',
          },
        ),
        ReactiveValueListenableBuilder<OpcionDeRespuesta?>(
          formControl: controlador.respuestaEspecificaControl,
          builder: (context, control, child) {
            if (control.value?.requiereCriticidadDelInspector ?? false) {
              return WidgetCriticidadInspector(
                  controlador.criticidadDelInspectorControl);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
