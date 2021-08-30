import 'dart:io';
import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_multi_image_picker/reactive_multi_image_picker.dart';

import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';

import 'creacion_controls.dart';
import 'creacion_widgets.dart';

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
            /// Intento de unificar los widgets de cada pregunta
            /// Para poder hacer la unificacion exitosa hay que crear una
            /// interfaz o clase padre que implementen todos los tipos de pregunta
            TipoPreguntaCard(preguntaController: preguntaController),
            const SizedBox(height: 20),

            /// Widget para añadir los rangos y su respectiva criticidad
            CriticidadCard(preguntaController: preguntaController),
            const SizedBox(height: 20),

            /// Row con widgets que permiten añadir o pegar otro bloque debajo del actual.
            BotonesDeBloque(controllerActual: preguntaController),
          ],
        ));
  }
}

class TipoPreguntaCard extends StatelessWidget {
  /// Validaciones.
  final CreadorPreguntaNumericaController preguntaController;

  const TipoPreguntaCard({Key? key, required this.preguntaController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    /// Se accede a este provider del formulario base de creación para poder cargar los sistemas

    return Column(
      children: [
        CamposGenerales(
          controller: preguntaController.controllerCamposGenerales,
        ),
        const SizedBox(height: 10),
        InputDecorator(
          decoration: const InputDecoration(
              labelText: 'Criticidad de la pregunta', filled: false),
          child: ReactiveSlider(
            formControl: preguntaController.criticidadControl,
            max: 4,
            divisions: 4,
            labelBuilder: (v) => v.round().toString(),
            activeColor: Colors.red,
          ),
        ),
        ReactiveMultiImagePicker<AppImage, AppImage>(
          formControl: preguntaController.fotosGuiaControl,
          //valueAccessor: FileValueAccessor(),
          decoration: const InputDecoration(labelText: 'Fotos guía'),
          maxImages: 3,
          imageBuilder: (image) => image.when(
            remote: (url) => Image.network(url),
            mobile: (path) => Image.file(File(path)),
            web: (path) => Image.network(path),
          ),
          xFileConverter: (file) =>
              kIsWeb ? AppImage.web(file.path) : AppImage.mobile(file.path),
        ),
      ],
    );
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