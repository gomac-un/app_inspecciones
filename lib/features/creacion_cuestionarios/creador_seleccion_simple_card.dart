import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'creacion_controls.dart';
import 'creacion_widgets.dart';
import 'pregunta_card.dart';
import 'widget_respuestas.dart';

/// Widget  usado en la creación de preguntas de selección
class CreadorSeleccionSimpleCard extends StatelessWidget {
  /// Validaciones y métodos utiles
  final CreadorPreguntaController controller;

  const CreadorSeleccionSimpleCard({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreguntaCard(
      titulo: 'Pregunta de selección',
      child: Column(
        children: [
          CamposGenerales(
            controller: controller.controllerCamposGenerales,
          ),

          const SizedBox(height: 10),

          /// Este widget ([CreadorSeleccionSimpleCard]) también es usado cuando se añade una pregunta (fila) a una cuadricula
          /// para añadir los detalles (fotosGuia, descripcion...) por lo cual hay que hacer está validación
          /// para que al ser parte de cuadricula no de la opción de añadir respuestas o más bloques.
          if (!controller.parteDeCuadricula)
            Column(
              children: [
                ReactiveDropdownField<TipoDePregunta>(
                  formControl: controller.tipoDePreguntaControl,
                  validationMessages: (control) => {
                    ValidationMessage.required: 'Seleccione el tipo de pregunta'
                  },
                  items: [
                    TipoDePregunta.seleccionUnica,
                    TipoDePregunta.seleccionMultiple
                  ]
                      .map((e) => DropdownMenuItem<TipoDePregunta>(
                            value: e,
                            child: Text(EnumToString.convertToString(e,
                                camelCase: true)),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Tipo de pregunta',
                  ),
                  onTap: () {
                    FocusScope.of(context)
                        .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
                  },
                ),
                const SizedBox(height: 10),
                WidgetRespuestas(controlPregunta: controller),
                BotonesDeBloque(controllerActual: controller),
              ],
            )
        ],
      ),
    );
  }
}
