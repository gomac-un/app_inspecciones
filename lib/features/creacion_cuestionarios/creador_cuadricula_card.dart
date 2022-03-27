import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'creacion_controls.dart';
import 'creacion_widgets.dart';
import 'creador_seleccion_simple_card.dart';
import 'pregunta_card.dart';
import 'widget_respuestas.dart';

/// TODO: evitar la duplicacion de codigo con [CreadorSeleccionSimpleCard]
class CreadorCuadriculaCard extends StatelessWidget {
  /// Validaciones
  final CreadorPreguntaCuadriculaController controller;

  const CreadorCuadriculaCard({Key? key, required this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PreguntaCard(
      titulo: 'Pregunta tipo cuadricula',
      child: Column(
        children: [
          CamposGenerales(
            controller: controller.controllerCamposGenerales,
          ),
          const SizedBox(height: 10),
          ReactiveDropdownField<TipoDePregunta>(
            formControl: controller.tipoDePreguntaControl,
            validationMessages: (control) =>
                {ValidationMessage.required: 'Seleccione el tipo de pregunta'},
            items: [
              TipoDePregunta.seleccionUnica,
              TipoDePregunta.seleccionMultiple
            ]
                .map((e) => DropdownMenuItem<TipoDePregunta>(
                      value: e,
                      child: Text(
                          EnumToString.convertToString(e, camelCase: true)),
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
          WidgetPreguntas(controlCuadricula: controller),
          WidgetRespuestas(controlPregunta: controller),
          BotonesDeBloque(controllerActual: controller),
        ],
      ),
    );
  }
}

/// Widget usado para añadir las preguntas de cuadricula
class WidgetPreguntas extends StatelessWidget {
  const WidgetPreguntas({
    Key? key,
    required this.controlCuadricula,
  }) : super(key: key);

  /// Validaciones
  final CreadorPreguntaCuadriculaController controlCuadricula;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final formControl = controlCuadricula.preguntasControl;

    /// Como las preguntas se van añadiendo dinámicamente, este  ReactiveValueListenableBuilder escucha, por decirlo asi,
    /// el length del control 'preguntas' [formControl], así cada que se va añadiendo una opción, se muestra el nuevo widget en la UI
    return ReactiveValueListenableBuilder(
        formControl: formControl,
        builder: (context, control, child) {
          final controllersPreguntas = controlCuadricula.controllersPreguntas;
          return Column(
            children: [
              Text(
                'Preguntas',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 10),
              if (controllersPreguntas.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controllersPreguntas.length,
                  itemBuilder: (context, i) {
                    final controllerPregunta = controllersPreguntas[i];
                    //Las keys sirven para que flutter maneje correctamente los widgets de la lista
                    return Column(
                      key: ValueKey(controllerPregunta),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  ReactiveTextField(
                                    formControl: controllerPregunta
                                        .controllerCamposGenerales
                                        .tituloControl,
                                    validationMessages: (control) => {
                                      ValidationMessage.required:
                                          'Escriba el titulo'
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Titulo',
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 1,
                                    maxLines: 3,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                      Icons.add_circle_outline_sharp),
                                  tooltip: 'Más detalles',
                                  onPressed: () async {
                                    final maincontext = context;
                                    showDialog(
                                      context: maincontext,
                                      builder: (context) => AlertDialog(
                                        content: SingleChildScrollView(
                                            child: SizedBox(
                                          width: media.width * 0.7,
                                          //TODO: arreglar este dialog
                                          child: CreadorSeleccionSimpleCard(
                                            controller: controllerPregunta,
                                          ),
                                        )),
                                        actions: [
                                          OutlinedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("Ok"),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                if (formControl.enabled)
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    tooltip: 'Borrar pregunta',
                                    onPressed: () => controlCuadricula
                                        .borrarPregunta(controllerPregunta),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),

              /// Se muestra este botón por defecto, al presionarlo se añade un nuevo control al FormArray [formGroup.control('preguntas')]
              /// Y así se va actualizando la lista
              if (formControl.enabled)
                OutlinedButton(
                  onPressed: controlCuadricula.agregarPregunta,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add),
                      Text("Agregar pregunta"),
                    ],
                  ),
                ),
            ],
          );
        });
  }
}
