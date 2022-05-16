import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/utils/hooks.dart';

import '../control/controlador_llenado_inspeccion.dart';
import '../domain/identificador_inspeccion.dart';
import '../domain/inspeccion.dart';
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
                    botonGuardar: _buildBotonGuardar(
                        controladorInspeccion, estadoDeInspeccion, context),
                  )
                : _buildBotonGuardar(
                    controladorInspeccion, estadoDeInspeccion, context),
            floatingActionButtonLocation: mostrarBotonesDeNavegacion
                ? FloatingActionButtonLocation.centerFloat
                : FloatingActionButtonLocation.endFloat,
          );
        });
  }

  Widget _buildBotonGuardar(ControladorLlenadoInspeccion control,
      EstadoDeInspeccion estadoDeInspeccion, BuildContext context) {
    final int criticas = useValueStream(control.controladoresCriticos).length;
    return estadoDeInspeccion == EstadoDeInspeccion.finalizada
        ? const SizedBox.shrink()
        : BotonGuardar(
            firstChild: PopupMenuButton<IconMenu>(
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
                }
              },
              itemBuilder: (context) => IconsMenu.getItems(
                      estadoDeInspeccion, inspeccionId.activo, criticas)
                  .map((item) => PopupMenuItem<IconMenu>(
                      value: item,
                      child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(item.icon),
                          title: Text(item.text))))
                  .toList(),
            ),
            guardar: control.guardarInspeccion,
            icon: const Icon(Icons.save),
            tooltip: "Guardar borrador",
            isDisabled: inspeccionId.activo == "previsualizacion",
          );
  }

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
