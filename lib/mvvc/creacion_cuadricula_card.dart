import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';
import 'package:inspecciones/mvvc/creacion_cards.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_form_controller.dart';
import 'package:inspecciones/presentation/pages/ayuda_screen.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// !SUPER TODO!!
/// TODO: evitar la duplicacion de codigo con [CreadorSeleccionSimpleCard]
class CreadorCuadriculaCard extends StatelessWidget {
  /// Validaciones
  final CreadorPreguntaCuadriculaController controller;

  const CreadorCuadriculaCard({Key? key, required this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    /// Formulario base
    final formController = context.watch<CreacionFormController>();
    return PreguntaCard(
      titulo: 'Pregunta tipo cuadricula',
      child: Column(
        children: [
          ReactiveTextField(
            formControl: controller.tituloControl,
            decoration: const InputDecoration(
              labelText: 'Titulo',
            ),
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          ReactiveTextField(
            formControl: controller.descripcionControl,
            decoration: const InputDecoration(
              labelText: 'Descripción',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 50,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 10),
          ReactiveDropdownField<Sistema?>(
            formControl: controller.sistemaControl,
            items: formController.todosLosSistemas
                .map((e) => DropdownMenuItem<Sistema>(
                      value: e,
                      child: Text(e.nombre),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Sistema',
            ),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<List<SubSistema>>(
              valueListenable: controller.subSistemasDisponibles,
              builder: (context, value, child) {
                return ReactiveDropdownField<SubSistema?>(
                  formControl: controller.subSistemaControl,
                  validationMessages: (control) =>
                      {ValidationMessage.required: 'Elija el subSistema'},
                  items: value
                      .map((e) => DropdownMenuItem<SubSistema>(
                            value: e,
                            child: Text(e.nombre),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Subsistema',
                  ),
                  onTap: () {
                    FocusScope.of(context)
                        .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
                  },
                );
              }),
          const SizedBox(height: 5),
          const Divider(height: 15, color: Colors.black),
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: Text(
                  'Posición',
                  textAlign: TextAlign.start,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const Dialog(child: AyudaPage()),
                    );
                  },
                  child: const Text(
                    '¿Necesitas ayuda?',
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ReactiveDropdownField<String?>(
            formControl: controller.ejeControl,
            validationMessages: (control) =>
                {ValidationMessage.required: 'Este valor es requerido'},
            items: formController.ejes
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Posición Y',
            ),
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
            },
          ),
          const SizedBox(height: 10),
          ReactiveDropdownField<String?>(
            formControl: controller.ladoControl,
            validationMessages: (control) =>
                {ValidationMessage.required: 'Este valor es requerido'},
            items: formController.lados
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Posición X',
            ),
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
            },
          ),
          const SizedBox(height: 10),
          ReactiveDropdownField<String?>(
            formControl: controller.posicionZControl,
            validationMessages: (control) =>
                {ValidationMessage.required: 'Este valor es requerido'},
            items: formController.posZ
                .map((e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
            decoration: const InputDecoration(
              labelText: 'Posición Z',
            ),
            onTap: () {
              FocusScope.of(context)
                  .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
            },
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          ReactiveDropdownField<TipoDePregunta>(
            formControl: controller.tipoDePreguntaControl,
            validationMessages: (control) =>
                {ValidationMessage.required: 'Seleccione el tipo de pregunta'},
            items: [
              TipoDePregunta.parteDeCuadriculaUnica,
              TipoDePregunta.parteDeCuadriculaMultiple,
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

    /// Como las preguntas se van añadiendo dinámicamente, este  ReactiveValueListenableBuilder escucha, por decirlo asi,
    /// el length del control 'preguntas' [formControl], así cada que se va añadiendo una opción, se muestra el nuevo widget en la UI
    return ReactiveValueListenableBuilder(
        formControl: controlCuadricula.preguntasControl,
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
                                    formControl:
                                        controllerPregunta.tituloControl,
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
                                  icon: const Icon(Icons.fullscreen),
                                  tooltip: 'Más detalles',
                                  onPressed: () async {
                                    final maincontext = context;
                                    showDialog(
                                      context: maincontext,
                                      builder: (context) => AlertDialog(
                                        content: SingleChildScrollView(
                                            child: Provider.value(
                                          // se vuelve a proveer el control del formulario principal ya que el nuevo contexto no tiene acceso, supongo
                                          value: maincontext
                                              .watch<CreacionFormController>(),
                                          // ignore: sized_box_for_whitespace
                                          child: SizedBox(
                                            width: media.width * 0.7,
                                            child: CreadorSeleccionSimpleCard(
                                              controller: controllerPregunta,
                                            ),
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
                        ReactiveSlider(
                          formControl: controllerPregunta.criticidadControl,
                          max: 4,
                          divisions: 4,
                          labelBuilder: (v) => v.round().toString(),
                          activeColor: Colors.red,
                        ),
                      ],
                    );
                  },
                ),

              /// Se muestra este botón por defecto, al presionarlo se añade un nuevo control al FormArray [formGroup.control('preguntas')]
              /// Y así se va actualizando la lista
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
