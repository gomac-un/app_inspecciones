import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../control/controlador_llenado_inspeccion.dart';
import '../domain/inspeccion.dart';
import 'llenado_screen/actions.dart';
import 'llenado_screen/filter_widget.dart';
import 'llenado_screen/floating_action_button.dart';
import 'llenado_screen/paginador.dart';
import 'theme.dart';

class InspeccionPage extends ConsumerWidget {
  const InspeccionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlFuture = ref.watch(controladorLlenadoInspeccionProvider);

    return controlFuture.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, __) => Text(e.toString()),
        data: (control) {
          final estadoDeInspeccion =
              ref.watch(estadoDeInspeccionProvider).state;
          final mostrarFab = kIsWeb && ref.watch(showFABProvider).state;

          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
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
                      ? Colors.deepOrange
                      : null,
              actions: [
                /*IconButton(
                    onPressed: () => ref.read(inspeccionIdProvider).state = 1,
                    icon: const Icon(Icons.filter_1)),
                IconButton(
                    onPressed: () => ref.read(inspeccionIdProvider).state = 2,
                    icon: const Icon(Icons.filter_2)),*/
                IconButton(
                    onPressed: () {
                      ref.read(themeProvider.notifier).switchTheme();
                    },
                    icon: const Icon(Icons.dark_mode_outlined)),
                const FilterWidget(),
                if (estadoDeInspeccion != EstadoDeInspeccion.finalizada) ...[
                  LlenadoAppBarButton(
                    action: control.guardarInspeccion,
                    icon: const Icon(Icons.save),
                    tooltip: "guardar borrador",
                  ),
                  IconButton(
                    onPressed: () => control.iniciarReparaciones(
                      onInvalid: () => mostrarInvalido(context),
                    ),
                    icon: const Icon(Icons.home_repair_service),
                    tooltip: "iniciar reparaciones",
                  ),
                  IconButton(
                    onPressed: control.finalizar,
                    icon: const Icon(Icons.done),
                    tooltip: "finalizar",
                  ),
                ]
              ],
            ),
            body: PaginadorYFiltradorDePreguntas(control),
            floatingActionButton: mostrarFab ? const FABNavigation() : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        });
  }
}
