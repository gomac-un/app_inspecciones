import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/presentation/widgets/alertas.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:textfield_tags/textfield_tags.dart';

import 'creacion_form_controller.dart';
import 'creacion_widgets.dart';
import 'pregunta_card.dart';

/// pantalla de edicion de un cuestionario
class EdicionFormPage extends ConsumerWidget {
  final String? cuestionarioId;

  const EdicionFormPage({Key? key, this.cuestionarioId}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return ProviderScope(
      overrides: [
        cuestionarioIdProvider.overrideWithValue(cuestionarioId),
      ],
      child: Consumer(builder: (context, ref, _) {
        final formController = ref.watch(creacionFormControllerFutureProvider);
        return formController.when(
            data: (_) => const EdicionForm(),
            loading: (prev) => const CircularProgressIndicator(),
            error: (e, s, prev) => throw e);
      }),
    );
  }
}

class EdicionForm extends ConsumerWidget {
  const EdicionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(creacionFormControllerProvider);
    return ReactiveForm(
      formGroup: controller.control,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("cuestionario"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PreguntaCard(
                titulo: 'Tipo de inspección',
                child: Column(
                  children: [
                    ReactiveDropdownField<String?>(
                      formControl: controller.tipoDeInspeccionControl,
                      validationMessages: (control) => {
                        ValidationMessage.required: 'Este valor es requerido'
                      },
                      items: controller.todosLosTiposDeInspeccion
                          .map((e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Seleccione el tipo de inspeccion',
                      ),
                      onTap: () {
                        FocusScope.of(context)
                            .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
                      },
                    ),

                    const SizedBox(height: 10),

                    /// En caso de que se seleccione 'Otra', se activa textfield para que escriba el tipo de inspeccion
                    ReactiveValueListenableBuilder<String?>(
                        formControl: controller.tipoDeInspeccionControl,
                        builder: (context, value, child) {
                          if (value.value ==
                              CreacionFormController.otroTipoDeInspeccion) {
                            return ReactiveTextField(
                              formControl:
                                  controller.nuevoTipoDeInspeccionControl,
                              validationMessages: (control) => {
                                ValidationMessage.required:
                                    'Este valor es requerido'
                              },
                              decoration: const InputDecoration(
                                labelText: 'Escriba el tipo de inspeccion',
                                prefixIcon: Icon(Icons.text_fields),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                  ],
                ),
              ),
              PreguntaCard(
                titulo: 'Etiquetas aplicables',
                child: ReactiveTextFieldTags(
                    formControl: controller.etiquetasControl,
                    //etiquetasDisponibles: controller.todasLasEtiquetas,
                    validator: (String tag) {
                      if (tag.isEmpty) return "ingrese algo";

                      final splited = tag.split(":");

                      if (splited.length == 1) {
                        return "agregue : para separar la etiqueta";
                      }

                      if (splited.length > 2) return "solo se permite un :";

                      if (splited[0].isEmpty || splited[1].isEmpty) {
                        return "agregue texto antes y despues de :";
                      }

                      return null;
                    }),
              ),
              PreguntaCard(
                titulo: 'Periodicidad (en días)',
                child: ReactiveSlider(
                  formControl: controller.periodicidadControl,
                  max: 100.0,
                  divisions: 100,
                  labelBuilder: (v) => v.round().toString(),
                ),
              ),

              /// Cuando se agrega un bloque, esta lista empieza a mostrarlos en la pantalla.
              AnimatedList(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                initialItemCount: controller.controllersBloques.length,
                itemBuilder: (context, index, animation) {
                  return ProviderScope(
                    overrides: [
                      numeroDeBloqueProvider.overrideWithValue(index)
                    ],
                    child: ControlWidgetAnimado(
                      controller: controller.controllersBloques[index],
                      animation: animation,
                    ),
                  );
                },
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
        floatingActionButton: //controller.estado == EstadoDeCuestionario.borrador ?
            const BotonesGuardado()
        //: null
        ,
      ),
    );
  }
}

/// Row con botón de guardar borrador y finalizar cuestionario
class BotonesGuardado extends ConsumerWidget {
  const BotonesGuardado({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(creacionFormControllerProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            icon: const Icon(Icons.archive),
            label: const Text('Guardar'),
            onPressed: () => _guardar(context, controller),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            icon: const Icon(Icons.done_all_outlined),
            label: const Text('Finalizar'),
            onPressed: () => _finalizar(context, controller),
          ),
        ],
      ),
    );
  }

  Future<void> _guardar(
      BuildContext context, CreacionFormController controller) async {
    await controller.guardarCuestionarioEnLocal(EstadoDeCuestionario.borrador);
    //TODO: Mostrar tambien cuando hay un error.

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Guardado exitoso"),
          actions: [
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Aceptar'),
            )
          ],
        );
      },
    );
  }

  /// Muestra alerta de finalización de cuestionario (error o éxito), o retrocede a la pantalla
  /// principal si el cuestionario ya esta finalizado.
  Future<void> _finalizar(
      BuildContext context, CreacionFormController controller) async {
    final form = controller.control;
    form.markAllAsTouched();
    return !form.valid
        ? showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Alerta"),
              content:
                  const Text("El cuestionario tiene errores, por favor revise"),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    //TODO: hacer primero scroll hasta abajo para que el control
                    // que falla quede en la parte de arriba de la pantalla si
                    // es que estaba abajo
                    try {
                      _focusFirstError(form);
                    } on StateError {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text(const JsonEncoder.withIndent('  ')
                                    .convert(form.errors)),
                              ));
                    }
                  },
                  child: const Text("Ok"),
                ),
              ],
            ),
          )
        : showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Alerta"),
              content: const Text(
                  "¿Está seguro que desea finalizar este cuestionario? Si lo hace, no podrá editarlo después"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();

                    await controller.guardarCuestionarioEnLocal(
                        EstadoDeCuestionario.finalizado);

                    mostrarMensaje(context, TipoDeMensaje.exito,
                        'Cuestionario creado exitosamente');
                  },
                  child: const Text("Aceptar"),
                ),
              ],
            ),
          );
  }

  void _focusFirstError(AbstractControl control) {
    // esto solo deberia pasar si el controlador superior no tiene ningun descendiente invalido
    if (control.valid) return;

    if (control is FormControl) {
      control.focus();
    } else if (control is FormArray) {
      _focusFirstError(control.controls.firstWhere((e) => e.invalid));
    } else if (control is FormGroup) {
      _focusFirstError(control.controls.values.firstWhere((e) => e.invalid));
    }
  }
}
