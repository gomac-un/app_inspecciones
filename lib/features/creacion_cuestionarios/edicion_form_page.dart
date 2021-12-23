import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/configuracion_organizacion/administrador_de_etiquetas.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/presentation/widgets/reactive_textfield_tags.dart';
import 'package:reactive_forms/reactive_forms.dart';

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
        final formController =
            ref.watch(creacionFormControllerFutureProvider(cuestionarioId));
        return formController.when(
            data: (_) => EdicionForm(
                  cuestionarioId: cuestionarioId,
                ),
            loading: () => const CircularProgressIndicator(),
            error: (e, s) => throw e);
      }),
    );
  }
}

class EdicionForm extends ConsumerWidget {
  final String? cuestionarioId;
  const EdicionForm({Key? key, required this.cuestionarioId}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller =
        ref.watch(creacionFormControllerProvider(cuestionarioId));
    return ReactiveForm(
      formGroup: controller.control,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("cuestionario"),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: _ListCuestionario(controller: controller),
          ),
        ),
        floatingActionButton: controller.datosIniciales.cuestionario.estado
                    .valueOrDefault(EstadoDeCuestionario.borrador) ==
                EstadoDeCuestionario.borrador
            ? BotonesGuardado(
                controller: controller,
              )
            : null,
      ),
    );
  }
}

class _ListCuestionario extends StatelessWidget {
  const _ListCuestionario({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final CreacionFormController controller;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                child: Consumer(builder: (context, ref, _) {
                  final todasLasJerarquias = ref
                          .watch(listaEtiquetasDeActivosProvider)
                          .asData
                          ?.value ??
                      const <Jerarquia>[];

                  return ReactiveTextFieldTags(
                    decoration: const InputDecoration(labelText: "etiquetas"),
                    formControl: controller.etiquetasControl,
                    validationMessages: (control) => {
                      ValidationMessage.minLength:
                          'Se requiere al menos una etiqueta'
                    },
                    optionsBuilder: (TextEditingValue val) => controller
                        .getTodasLasEtiquetas(todasLasJerarquias)
                        .where((e) => e.clave
                            .toLowerCase()
                            .contains(val.text.toLowerCase())),
                    onMenu: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            const MenuDeEtiquetas(TipoDeEtiqueta.activo),
                      );
                    },
                  );
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
            ],
          ),
        ),

        /// Cuando se agrega un bloque, esta lista empieza a mostrarlos en la pantalla.
        SliverAnimatedList(
          initialItemCount: controller.controllersBloques.length,
          itemBuilder: (context, index, animation) {
            return ProviderScope(
              overrides: [numeroDeBloqueProvider.overrideWithValue(index)],
              child: ControlWidgetAnimado(
                controller: controller.controllersBloques[index],
                animation: animation,
              ),
            );
          },
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}

/// Row con botón de guardar borrador y finalizar cuestionario
class BotonesGuardado extends ConsumerWidget {
  final CreacionFormController controller;
  const BotonesGuardado({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cuestionario guardado'),
      ),
    );
  }

  /// Muestra alerta de finalización de cuestionario (error o éxito), o retrocede a la pantalla
  /// principal si el cuestionario ya esta finalizado.
  Future<void> _finalizar(
      BuildContext context, CreacionFormController controller) async {
    final form = controller.control;
    form.markAllAsTouched();
    if (!form.valid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("El cuestionario tiene errores, por favor revise"),
        action: SnackBarAction(
          label: "ver errores",
          onPressed: () => _mostrarErrores(context, form),
        ),
      ));
      //TODO: hacer primero scroll hasta abajo para que el control
      // que falla quede en la parte de arriba de la pantalla si
      // es que estaba abajo
      try {
        _focusFirstError(form);
      } on StateError {
        _mostrarErrores(context, form);
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Alerta"),
          content: const Text(
              "¿Está seguro que desea finalizar este cuestionario? Si lo hace, "
              "no podrá editarlo después y tendrá que crear una nueva versión"),
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

                Navigator.of(context).pop(true);
              },
              child: const Text("Aceptar"),
            ),
          ],
        ),
      );
    }
  }

  void _mostrarErrores(BuildContext context, FormGroup form) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Errores:"),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Text(
                    const JsonEncoder.withIndent('  ').convert(form.errors)),
              ),
            ),
          ));

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
