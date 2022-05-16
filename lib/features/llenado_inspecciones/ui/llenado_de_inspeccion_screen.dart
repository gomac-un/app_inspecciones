import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/domain.dart';
import 'package:inspecciones/features/llenado_inspecciones/infrastructure/inspecciones_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/utils/future_either_x.dart';
import 'package:inspecciones/utils/hooks.dart';

import '../control/controlador_llenado_inspeccion.dart';
import 'llenado_screen/actions.dart';
import 'llenado_screen/filter_widget.dart';
import 'llenado_screen/floating_action_button.dart';
import 'llenado_screen/paginador.dart';
import 'pregunta_card_factory.dart';
import 'widgets/avance_card.dart';
import 'widgets/icon_menu.dart';

class InspeccionPage extends HookConsumerWidget {
  final IdentificadorDeInspeccion inspeccionId;
  const InspeccionPage({Key? key, required this.inspeccionId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlFuture =
        ref.watch(controladorLlenadoInspeccionProvider(inspeccionId));

    return controlFuture.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Text(e.toString()),
        data: (controladorInspeccion) {
          final estadoDeInspeccion =
              useValueStream(controladorInspeccion.estadoDeInspeccion);

          final mostrarBotonesDeNavegacion =
              kIsWeb && ref.watch(showFABProvider);

          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            /* drawer: const UserDrawer(), */
            //TODO: mirar si es necesario deshabilitar el drawer mientras se está llenando una inspeccion
            appBar: AppBar(
              title: Text(
                inspeccionId.activo == "previsualizacion"
                    ? "Previsualización"
                    : "Inspección " +
                        EnumToString.convertToString(
                          estadoDeInspeccion,
                          camelCase: true,
                        ).toLowerCase(),
              ),
              backgroundColor:
                  estadoDeInspeccion == EstadoDeInspeccion.enReparacion
                      ? Theme.of(context).colorScheme.secondary
                      : null,
              actions: [
                FilterWidget(controladorInspeccion),
              ],
            ),

            body: Column(children: [
              AvanceCard(controladorInspeccion),
              const SizedBox(height: 3),
              Expanded(
                child: PaginadorYFiltradorDePreguntas(controladorInspeccion,
                    factory: ref.watch(preguntaCardFactoryProvider)),
              ),
            ]),
            floatingActionButton: mostrarBotonesDeNavegacion
                ? FABNavigation(
                    botonGuardar: _buildBotonGuardar(controladorInspeccion,
                        estadoDeInspeccion, context, ref),
                  )
                : _buildBotonGuardar(
                    controladorInspeccion,
                    estadoDeInspeccion,
                    context,
                    ref,
                  ),
            floatingActionButtonLocation: mostrarBotonesDeNavegacion
                ? FloatingActionButtonLocation.centerFloat
                : FloatingActionButtonLocation.endFloat,
          );
        });
  }

  Widget _buildBotonGuardar(
      ControladorLlenadoInspeccion control,
      EstadoDeInspeccion estadoDeInspeccion,
      BuildContext context,
      WidgetRef ref) {
    final int criticas = useValueStream(control.controladoresCriticos).length;
    return estadoDeInspeccion == EstadoDeInspeccion.finalizada
        ? const SizedBox.shrink()
        : BotonGuardar(
            firstChild: PopupMenuButton<IconMenu>(
              offset: const Offset(0, -135),
              icon: const Icon(Icons.done),
              onSelected: (value) {
                switch (value) {
                  case IconsMenu.reparar:
                    control.iniciarReparaciones(
                      onInvalid: () => mostrarInvalido(context, control),
                      mensajeReparacion: () =>
                          mostrarMensajeReparacion(context),
                    );
                    break;
                  case IconsMenu.finalizar:
                    control.finalizar(
                        confirmation: () => _confirmarFinalizacion(context),
                        ejecutarGuardado: agregarMensajesAccion(context),
                        onInvalid: () => mostrarInvalido(context, control));
                    break;
                  case IconsMenu.informacion:
                    _mostrarInformacionInspeccion(context, control);
                    break;
                  case IconsMenu.enviar:
                    _subirInspeccion(context, ref);
                    break;
                }
              },
              itemBuilder: (context) => IconsMenu.getItems(
                      estadoDeInspeccion, inspeccionId.activo, criticas)
                  .map((item) => PopupMenuItem<IconMenu>(
                      value: item,
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(item.icon,
                              color: Theme.of(context).colorScheme.primary),
                          title: Text(item.text))))
                  .toList(),
            ),
            guardar: control.guardarInspeccion,
            icon: const Icon(Icons.save),
            tooltip: "Guardar borrador",
            isDisabled: inspeccionId.activo == "previsualizacion",
          );
  }

  Future<void> _subirInspeccion(BuildContext context, WidgetRef ref) async {
    final confirmacion = await _confirmarEnvio(context);
    if (confirmacion ?? false) {
      final remoteRepo = ref.read(inspeccionesRemoteRepositoryProvider);
      final localRepo = ref.read(inspeccionesRepositoryProvider);
      await remoteRepo
          .subirInspeccion(IdentificadorDeInspeccion(
            activo: inspeccionId.activo,
            cuestionarioId: inspeccionId.cuestionarioId,
          ))
          .leftMap((f) => apiFailureToInspeccionesFailure(f))
          .flatMap((id) => localRepo.eliminarRespuestas(id: id))
          .leftMap((f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$f"),
              )))
          .nestedEvaluatedMap((_) => showDialog(
                context: context,
                barrierColor: Theme.of(context).primaryColorLight,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentTextStyle: Theme.of(context).textTheme.headline5,
                    title: const Icon(Icons.done_sharp,
                        size: 100, color: Colors.green),
                    actions: [
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Aceptar'),
                        ),
                      )
                    ],
                    content: const Text(
                      'Inspección enviada correctamente',
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ));
    }
  }

  Future<bool?> _confirmarEnvio(BuildContext context) => mostrarConfirmacion(
        context: context,
        content: RichText(
          text: TextSpan(
            text: '¿Desea enviar la inspección sin finalizar?\n',
            style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: 'IMPORTANTE: ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Si lo hace, alguien deberá terminarla después',
                style:
                    TextStyle(color: Theme.of(context).hintColor, fontSize: 15),
              ),
            ],
          ),
        ),
      );

  Future<bool?> _confirmarFinalizacion(BuildContext context) =>
      mostrarConfirmacion(
        context: context,
        content: RichText(
          text: TextSpan(
            text: '¿Está seguro que desea finalizar esta inspección?\n',
            style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                text: 'Si lo hace, no podrá editarla después.\n\n',
                style:
                    TextStyle(color: Theme.of(context).hintColor, fontSize: 17),
              ),
              TextSpan(
                text: 'IMPORTANTE: ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text:
                    'En caso de que otro usuario deba terminar la inspección, presione cancelar, guarde el avance y envíela sin finalizar',
                style:
                    TextStyle(color: Theme.of(context).hintColor, fontSize: 15),
              ),
            ],
          ),
        ),
      );

  void _mostrarInformacionInspeccion(
      BuildContext context, ControladorLlenadoInspeccion control) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogInformacionInspeccion(control);
      },
    );
  }
}

class DialogInformacionInspeccion extends HookWidget {
  final ControladorLlenadoInspeccion control;
  const DialogInformacionInspeccion(
    this.control, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final criticidadTotal = useValueStream(control.criticidadTotal);
    final criticidadTotalConReparaciones =
        useValueStream(control.criticidadTotalConReparaciones);
    return AlertDialog(
        title: const Text('Información'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Criticidad: $criticidadTotal', textAlign: TextAlign.left),
            Text('Criticidad con reparaciones: $criticidadTotalConReparaciones',
                textAlign: TextAlign.left),
            const Text('Tiempo transcurrido: 2m', textAlign: TextAlign.left),
            const Text('Número de preguntas: 65', textAlign: TextAlign.left),
          ],
        ));
  }
}
