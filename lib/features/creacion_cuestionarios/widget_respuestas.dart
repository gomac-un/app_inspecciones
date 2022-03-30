import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

import 'creacion_controls.dart';

/// Widget usado para añadir las opciones de respuesta a las preguntas de cuadricula o de selección
class WidgetRespuestas extends HookWidget {
  const WidgetRespuestas({
    Key? key,
    required this.controlPregunta,
  }) : super(key: key);

  final ConRespuestas controlPregunta;

  @override
  Widget build(BuildContext context) {
    final showTooltipNotifier = useState(false);

    /// Como las respuestas se van añadiendo dinámicamente, este
    /// [ReactiveValueListenableBuilder] escucha cambios en el control respuestas
    /// así cada que se va añadiendo una opción, se muestra el nuevo widget en la UI
    return ReactiveValueListenableBuilder(
        formControl: controlPregunta.respuestasControl,
        builder: (context, formControl, child) {
          final controlesRespuestas = controlPregunta.controllersRespuestas;
          return Column(
            children: [
              Text(
                'Respuestas',
                style: Theme.of(context).textTheme.headline6,
              ),

              /// Si no se ha añadido ninguna opción de respuesta
              if (formControl.errors.containsKey(ValidationMessage.minLength))
                const Text(
                  'Agregue una opción de respuesta',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              if (controlesRespuestas.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controlesRespuestas.length,
                  itemBuilder: (context, i) {
                    final controlRespuesta = controlesRespuestas[i];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //Las keys sirven para que flutter maneje correctamente los widgets de la lista
                      key: ValueKey(controlRespuesta),
                      children: [
                        Row(
                          children: [
                            SimpleTooltip(
                              show: showTooltipNotifier.value,
                              tooltipDirection: TooltipDirection.right,
                              content: Text(
                                "Seleccione si el inspector puede asignar una criticidad propia al elegir esta respuesta",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              ballonPadding: const EdgeInsets.all(2),
                              borderColor: Theme.of(context).primaryColor,
                              borderWidth: 0,
                              child: IconButton(
                                  iconSize: 20,
                                  icon: const Icon(
                                    Icons.info,
                                  ),
                                  onPressed: () => showTooltipNotifier.value =
                                      !showTooltipNotifier.value),
                            ),
                            Flexible(
                              child: ReactiveCheckboxListTile(
                                formControl: controlRespuesta
                                    .requiereCriticidadDelInspectorControl,
                                title: const Text(
                                    'Requiere criticidad del inspector'),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ReactiveTextField(
                                formControl: controlRespuesta.tituloControl,
                                validationMessages: (control) => {
                                  ValidationMessage.required:
                                      'Este valor es requerido'
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Respuesta',
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                minLines: 1,
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                            ),
                            if (formControl.enabled)
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Borrar respuesta',
                                onPressed: () => controlPregunta
                                    .borrarRespuesta(controlRespuesta),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ReactiveTextField(
                          formControl: controlRespuesta.descripcionControl,
                          decoration: const InputDecoration(
                            labelText: 'Descripción',
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          minLines: 1,
                        ),
                        ReactiveSlider(
                          formControl: controlRespuesta.criticidadControl,
                          max: 4,
                          divisions: 4,
                          labelBuilder: (v) => v.round().toString(),
                          activeColor: Colors.red,
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),

              /// Se muestra este botón por defecto, al presionarlo se añade un
              ///  nuevo control al FormArray [controlesRespuestas]
              if (formControl.enabled)
                OutlinedButton(
                  onPressed: () => controlPregunta.agregarRespuesta(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add),
                      Text("Agregar respuesta"),
                    ],
                  ),
                ),
            ],
          );
        });
  }
}
