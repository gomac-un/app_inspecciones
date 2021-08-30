import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/presentation/widgets/reactive_filter_chip_selection.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:inspecciones/mvvc/form_scaffold.dart';
import 'package:inspecciones/presentation/widgets/action_button.dart';
import 'package:inspecciones/presentation/widgets/alertas.dart';
import 'package:inspecciones/presentation/widgets/loading_dialog.dart';
import 'package:inspecciones/application/creacion/creacion_form_controller_cubit.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/common_widgets.dart';

import 'creacion_form_controller.dart';
import 'creacion_widgets.dart';

/// pantalla de edicion de un cuestionario
/// TODO: opcion para la creacion de cuestionarios con excel
class EdicionFormPage extends StatelessWidget implements AutoRouteWrapper {
  final int? cuestionarioId;

  const EdicionFormPage({Key? key, @pathParam this.cuestionarioId})
      : super(key: key);

  /// Definición del provider, para poder acceder a [CreacionFormViewModel]
  /// desde las rutas hijo (creacion_cards y creacion_controls)
  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (ctx) =>
            getIt<CreacionFormControllerCubit>(param1: cuestionarioId),
        child: this,
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreacionFormControllerCubit,
        CreacionFormControllerState>(
      builder: (context, state) {
        return state.when(
          initial: () => const CircularProgressIndicator(),
          inProgress: () => const CircularProgressIndicator(),
          success: (controller) =>
              Provider.value(value: controller, child: const EdicionForm()),
          failure: (e) => Text("Error cargando el cuestionario: $e"),
        );
      },
    );
  }
}

class EdicionForm extends StatelessWidget {
  const EdicionForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreacionFormController>();
    return ReactiveForm(
      formGroup: controller.control,
      child: FormScaffold(
        title: Text(
          controller.estado == EstadoDeCuestionario.borrador
              ? 'Creación de cuestionario'
              : 'Visualización cuestionario',
        ),
        body: Column(
          children: [
            PreguntaCard(
              titulo: 'Tipo de inspección',
              child: Column(
                children: [
                  ReactiveDropdownField<String>(
                    formControl: controller.tipoDeInspeccionControl,
                    validationMessages: (control) =>
                        {ValidationMessage.required: 'Este valor es requerido'},
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
                  ReactiveValueListenableBuilder<String>(
                      formControl: controller.tipoDeInspeccionControl,
                      builder: (context, value, child) {
                        if (value.value ==
                            CreacionFormController.otroTipoDeInspeccion) {
                          return ReactiveTextField(
                            formControl:
                                controller.nuevoTipoDeInspeccionControl,
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
              titulo: 'Modelos de vehículo',
              child: ReactiveFilterChipSelection(
                formControl: controller.modelosControl,
                posibleItems: controller.todosLosModelos,
                decoration: const InputDecoration(
                  labelText: 'Modelos a los que aplica esta inspección',
                ),
                labelAccesor: id,
                validationMessages: (control) => {
                  ValidationMessage.minLength: 'Seleccione al menos un modelo',
                  'yaExiste':
                      'Ya existe un cuestionario de este tipo para este modelo'
                },
              ),
            ),

            PreguntaCard(
              titulo: 'Contratista',
              child: ReactiveDropdownField(
                formControl: controller.contratistaControl,
                validationMessages: (control) =>
                    {ValidationMessage.required: 'Seleccione un contratista'},
                items: controller.todosLosContratistas
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.nombre),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Seleccione un contratista',
                ),
                onTap: () {
                  FocusScope.of(context)
                      .unfocus(); // para que no salte el teclado si tenia un textfield seleccionado
                },
              ),
            ),
            PreguntaCard(
              titulo: 'Periodicidad',
              descripcion: '(en días)',
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
                return Provider.value(
                  value: index,
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
        floatingActionButton: BotonesGuardado(
          estado: controller.estado as EstadoDeCuestionario,
        ),
      ),
    );
  }
}

/// TODO: reestructurar el flujo de estos botones
/// Row con botón de guardar borrador y finalizar cuestionario
class BotonesGuardado extends StatelessWidget {
  const BotonesGuardado({
    Key? key,
    required this.estado,
  }) : super(key: key);
  final EstadoDeCuestionario estado;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CreacionFormController>();
    final form = controller.control;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          /// Solo aparece guardar cuando no se ha finalizado el cuestionario.
          if (estado == EstadoDeCuestionario.borrador)
            ActionButton(
              key: const ObjectKey("borrador"),
              iconData: Icons.archive,
              label: 'Guardar',
              onPressed: () async {
                /// Que haya seleccionado modelos y tipo de inspeccion
                if (controller.modelosControl.value!.isEmpty ||
                    controller.tipoDeInspeccionControl.value!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Seleccione el tipo de inspección y elija por lo menos un modelo antes de guardar el cuestionario")));
                } else {
                  /// Muestra que errores hay

                  await controller.guardarCuestionarioEnLocal(estado);
                  //TODO: Mostrar tambien cuando hay un error.
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text("Guardado exitoso"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Aceptar'),
                          )
                        ],
                      );
                    },
                  );
                }
              },
            ),
          FloatingActionButton.extended(
            heroTag: null,
            icon: const Icon(Icons.done_all_outlined),
            label: Text(estado == EstadoDeCuestionario.borrador
                ? 'Finalizar'

                /// Solo se puede finalizar una vez.
                : 'Aceptar'),
            onPressed: !form.valid
                ? () {
                    if (estado == EstadoDeCuestionario.borrador) {
                      form.markAllAsTouched();

                      /// Si tiene errores y aunn no está finalizado
                      mostrarErrores(context, form);
                    } else {
                      /// Cuando ya está finalizado y el label es 'Aceptar', no sé que tan necesaria sea esta parte
                      Navigator.of(context).pop();
                    }
                  }
                : () {
                    finalizarCuestionario(context);
                  },
          ),
        ],
      ),
    );
  }

  /// Muestra alerta de finalización de cuestionario (error o éxito), o retrocede a la pantalla
  /// principal si el cuestionario ya esta finalizado.
  void finalizarCuestionario(BuildContext context) {
    final controller = context.read<CreacionFormController>();
    // set up the buttons
    final cancelButton = TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text("Cancelar"), // OJO con el context
    );
    final Widget continueButton = TextButton(
      onPressed: () async {
        Navigator.of(context).pop();

        if (estado == EstadoDeCuestionario.borrador) {
          LoadingDialog.show(context);
          await controller
              .guardarCuestionarioEnLocal(EstadoDeCuestionario.finalizada);
          LoadingDialog.hide(context);
          mostrarMensaje(
              context, TipoDeMensaje.exito, 'Cuestionario creado exitosamente');
        }
      },
      child: const Text("Aceptar"),
    );
    // set up the AlertDialog
    final alert = AlertDialog(
      title: const Text("Alerta"),
      content: const Text(
          "¿Está seguro que desea finalizar este cuestionario? Si lo hace, no podrá editarlo después"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    /// Se guarda si es borrador
    if (estado == EstadoDeCuestionario.borrador) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    /// Se retrocede hasta la principal de cuestionarios cuando ya esta finalizado
    else {
      context.router.pop();
    }
  }
}
