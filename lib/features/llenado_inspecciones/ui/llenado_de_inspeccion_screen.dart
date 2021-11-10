import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';
import 'package:inspecciones/features/llenado_inspecciones/ui/avance_card.dart';

import '../control/controlador_llenado_inspeccion.dart';
import '../domain/inspeccion.dart';
import 'llenado_screen/actions.dart';
import 'llenado_screen/filter_widget.dart';
import 'llenado_screen/floating_action_button.dart';
import 'llenado_screen/paginador.dart';

class InspeccionPage extends ConsumerWidget {
  final IdentificadorDeInspeccion inspeccionId;
  const InspeccionPage({Key? key, required this.inspeccionId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlFuture =
        ref.watch(controladorLlenadoInspeccionProvider(inspeccionId));

    return controlFuture.when(
        loading: (prev) => const Center(child: CircularProgressIndicator()),
        error: (e, s, prev) => Text(e.toString()),
        data: (control) {
          final estadoDeInspeccion =
              ref.watch(estadoDeInspeccionProvider).state;
          final mostrarFab = kIsWeb && ref.watch(showFABProvider).state;
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            drawer: estadoDeInspeccion == EstadoDeInspeccion.finalizada
                ? const UserDrawer()
                : const UserDrawer(), //TODO: mirar si es necesario deshabilitar el drawer mientras se está llenando una inspeccion
            appBar: AppBar(
              title: Text(
                "Inspección " +
                    EnumToString.convertToString(
                      estadoDeInspeccion,
                      camelCase: true,
                    ).toLowerCase(),
              ),
              actions: [
                const FilterWidget(),
                if (estadoDeInspeccion != EstadoDeInspeccion.finalizada) ...[
                  BotonGuardar(
                    guardar: control.guardarInspeccion,
                    icon: const Icon(Icons.save),
                    tooltip: "Guardar borrador",
                  ),
                  IconButton(
                    // TODO: mostrar solo si hay preguntas que necesiten reparacion
                    onPressed: () => control.iniciarReparaciones(
                      onInvalid: () => mostrarInvalido(context),
                      mensajeReparacion: () =>
                          mostrarMensajeReparacion(context),
                    ),
                    icon: const Icon(Icons.home_repair_service),
                    tooltip: "Iniciar reparaciones",
                  ),
                  IconButton(
                    onPressed: () => control.finalizar(
                      confirmation: () => _confirmarFinalizacion(context),
                      ejecutarGuardado: agregarMensajesAccion(context),
                      onInvalid: () => mostrarInvalido(context),
                    ),
                    icon: const Icon(Icons.done),
                    tooltip: "Finalizar",
                  ),
                ]
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
              Expanded(child: PaginadorYFiltradorDePreguntas(control)),
            ]),
            floatingActionButton: mostrarFab ? const FABNavigation() : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        });
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
}
