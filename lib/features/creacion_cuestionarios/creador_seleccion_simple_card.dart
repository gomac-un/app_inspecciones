import 'package:flutter/material.dart';
import 'package:inspecciones/presentation/widgets/app_image_multi_image_picker.dart';
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

          InputDecorator(
            decoration: const InputDecoration(
                labelText: 'Criticidad de la pregunta', filled: false),
            child: ReactiveSlider(
              formControl: controller.criticidadControl,
              max: 4,
              divisions: 4,
              labelBuilder: (v) => v.round().toString(),
              activeColor: Colors.red,
            ),
          ),

          AppImageMultiImagePicker(
            formControl: controller.fotosGuiaControl,
            label: 'Fotos guía',
            maxImages: 3,
          ),

          const SizedBox(height: 10),

          /// Este widget ([CreadorSeleccionSimpleCard]) también es usado cuando se añade una pregunta (fila) a una cuadricula
          /// para añadir los detalles (fotosGuia, descripcion...) por lo cual hay que hacer está validación
          /// para que al ser parte de cuadricula no de la opción de añadir respuestas o más bloques.
          if (!controller.parteDeCuadricula)
            Column(
              children: [
                WidgetRespuestas(controlPregunta: controller),
                BotonesDeBloque(controllerActual: controller),
              ],
            )
        ],
      ),
    );
  }
}
