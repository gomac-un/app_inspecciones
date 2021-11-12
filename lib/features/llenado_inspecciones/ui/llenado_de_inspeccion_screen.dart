import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/llenado_inspecciones/ui/avance_card.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';

import '../control/controlador_llenado_inspeccion.dart';
import '../domain/identificador_inspeccion.dart';
import '../domain/inspeccion.dart';
import 'icon_menu.dart';
import 'llenado_screen/actions.dart';
import 'llenado_screen/filter_widget.dart';
import 'llenado_screen/floating_action_button.dart';
import 'llenado_screen/paginador.dart';
import 'pregunta_card_factory.dart';

class InspeccionPage extends ConsumerWidget {
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
        data: (control) {
          final estadoDeInspeccion = ref.watch(estadoDeInspeccionProvider);
          final mostrarBotonesDeNavegacion =
              kIsWeb && ref.watch(showFABProvider);

          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            drawer: estadoDeInspeccion == EstadoDeInspeccion.finalizada
                ? const UserDrawer()
                : const UserDrawer(),
            //TODO: mirar si es necesario deshabilitar el drawer mientras se está llenando una inspeccion
            appBar: AppBar(
              title: Text(
                "Inspección " +
                    EnumToString.convertToString(
                      estadoDeInspeccion,
                      camelCase: true,
                    ).toLowerCase(),
              ),
              backgroundColor:
                  estadoDeInspeccion == EstadoDeInspeccion.enReparacion
                      ? const Color.fromRGBO(240, 184, 35, 1)
                      : null,
              actions: [
                const FilterWidget(),
                PopupMenuButton<IconMenu>(
                    onSelected: (value) {
                      switch (value) {
                        case IconsMenu.reparar:
                          control.iniciarReparaciones(
                            onInvalid: () => mostrarInvalido(context),
                            mensajeReparacion: () =>
                                mostrarMensajeReparacion(context),
                          );
                          break;
                        case IconsMenu.finalizar:
                          control.finalizar(
                              confirmation: () =>
                                  _confirmarFinalizacion(context),
                              ejecutarGuardado: agregarMensajesAccion(context),
                              onInvalid: () => mostrarInvalido(context));
                          break;
                        case IconsMenu.informacion:
                          _mostrarInformacionInspeccion(context);
                          break;
                      }
                    },
                    itemBuilder: (context) => IconsMenu.items
                        .map((item) => PopupMenuItem<IconMenu>(
                            value: item,
                            child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(item.icon),
                                title: Text(item.text))))
                        .toList()),
              ],
            ),

            body: Column(children: [
              AvanceCard(
                  control.formArray,
                  control.controladores
                      .where((c) => c.criticidadCalculada > 0)
                      .toList()
                      .length),
              const SizedBox(height: 3),
              Expanded(
                  child: PaginadorYFiltradorDePreguntas(control,
                      factory: ref.watch(preguntaCardFactoryProvider))),
            ]),
            floatingActionButton: mostrarBotonesDeNavegacion
                ? FABNavigation(
                    botonGuardar: _buildBotonGuardar(control),
                  )
                : _buildBotonGuardar(control),
            floatingActionButtonLocation: mostrarBotonesDeNavegacion
                ? FloatingActionButtonLocation.centerFloat
                : FloatingActionButtonLocation.endFloat,
          );
        });
  }

  Widget _buildBotonGuardar(ControladorLlenadoInspeccion control) {
    return BotonGuardar(
      guardar: control.guardarInspeccion,
      icon: const Icon(Icons.save),
      tooltip: "Guardar borrador",
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

  void _mostrarInformacionInspeccion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Información'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text('Criticidad: Criticidad total', textAlign: TextAlign.left),
                Text('Tiempo transcurrido: 2m', textAlign: TextAlign.left),
                Text('Número de preguntas: 65', textAlign: TextAlign.left),
              ],
            ));
      },
    );
  }
}
