import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'creacion_controls.dart';
import 'creacion_widgets.dart';
import 'pregunta_card.dart';

//TODO: Unificar las cosas en común de los dos tipos de pregunta: las de seleccion y la numéricas.
/// Widget usado para la creación de preguntas numericas

class CreadorNumericaCard extends StatelessWidget {
  final CreadorPreguntaNumericaController preguntaController;

  const CreadorNumericaCard({Key? key, required this.preguntaController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreguntaCard(
        titulo: 'Pregunta numérica',
        child: Column(
          children: [
            CamposGenerales(
              controller: preguntaController.controllerCamposGenerales,
            ),
            const SizedBox(height: 10),
            ReactiveTextField(
              formControl: preguntaController.unidadesControl,
              decoration: const InputDecoration(
                labelText: 'Unidades ej:(cm)',
              ),
              keyboardType: TextInputType.text,
              maxLines: 1,
            ),
            const SizedBox(height: 10),

            /// Widget para añadir los rangos y su respectiva criticidad
            CriticidadCard(preguntaController: preguntaController),
            const SizedBox(height: 20),

            /// Row con widgets que permiten añadir o pegar otro bloque debajo del actual.
            BotonesDeBloque(controllerActual: preguntaController),
          ],
        ));
  }
}

/// Widget usado para añadir rangos de criticidad a las preguntas numericas
class CriticidadCard extends StatelessWidget {
  const CriticidadCard({
    Key? key,
    required this.preguntaController,
  }) : super(key: key);

  final CreadorPreguntaNumericaController preguntaController;

  @override
  Widget build(BuildContext context) {
    /// Como los rangos se van añadiendo dinámicamente, este  ReactiveValueListenableBuilder escucha, por decirlo asi,
    /// el length del 'criticidadRespuesta' respuestas [formControl], así cada que se va añadiendo una criticidad, se muestra el nuevo widget en la UI
    return ReactiveValueListenableBuilder(
        formControl: preguntaController.criticidadesControl,
        builder: (context, control, child) {
          final controlesCriticidades =
              preguntaController.controllersCriticidades;
          return Column(
            children: [
              ExpansionTile(
                title: Text(
                  'Criticidad de las respuestas',
                  style: Theme.of(context).textTheme.headline6,
                ),
                childrenPadding: const EdgeInsets.all(5.0),
                children: [
                  Text(
                    'La criticidad de la respuesta está dada por rangos. Empiece con el menor rango posible hasta llegar al máximo.',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.subtitle1,
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Por ejemplo:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                ' Si el minimo valor que puede tomar la respuesta es -100, empiece a llenar los valores así [-100,0), [0,50), [50,100), etc.'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (control.invalid)
                Text(
                  control.errors.entries.first.key,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),
              if ((control as FormArray).controls.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controlesCriticidades.length,
                  itemBuilder: (context, i) {
                    final controlCriticidad = controlesCriticidades[i];
                    //Las keys sirven para que flutter maneje correctamente los widgets de la lista
                    return Column(
                      key: ValueKey(controlCriticidad),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ReactiveTextField(
                                keyboardType: TextInputType.number,
                                formControl: controlCriticidad.minimoControl,
                                validationMessages: (control) => {
                                  ValidationMessage.required:
                                      'Este valor es requerido'
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Valor Minimo',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: ReactiveTextField(
                                  keyboardType: TextInputType.number,
                                  formControl: controlCriticidad.maximoControl,
                                  validationMessages: (control) => {
                                    ValidationMessage.required:
                                        'Este valor es requerido',
                                    'verificarRango': 'El valor debe ser mayor'
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Valor Máximo',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ReactiveSlider(
                                formControl:
                                    controlCriticidad.criticidadControl,
                                max: 4,
                                divisions: 4,
                                labelBuilder: (v) => v.round().toString(),
                                activeColor: Colors.red,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Borrar respuesta',
                              onPressed: () => preguntaController
                                  .borrarCriticidad(controlCriticidad),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              OutlinedButton(
                onPressed: preguntaController.agregarCriticidad,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add),
                    Text("Agregar Rango"),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
