import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../control/controlador_de_pregunta.dart';
import '../../control/controlador_llenado_inspeccion.dart';
import '../../control/providers.dart';
import '../../domain/inspeccion.dart';
import '../pregunta_card_factory.dart';

class IconDialogPregunta extends ConsumerWidget {
  const IconDialogPregunta({
    Key? key,
    required this.controladorPregunta,
  }) : super(key: key);

  final ControladorDePregunta controladorPregunta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoDeInspeccion = ref.watch(estadoDeInspeccionProvider);
    final reparado =
        ref.watch(reparadoProvider(controladorPregunta.reparadoControl));
    final controlValido =
        ref.watch(controlValidoProvider(controladorPregunta.control));
    final criticidadCalculada =
        ref.watch(criticidadCalculadaProvider(controladorPregunta));

    final Color? color;
    final IconData icon;
    switch (estadoDeInspeccion) {
      case EstadoDeInspeccion.borrador:
        color = !controlValido ? Colors.red : null;
        icon = Icons.remove_red_eye_outlined;
        break;
      case EstadoDeInspeccion.enReparacion:
        color = reparado ? Colors.green : null;
        icon = criticidadCalculada > 0
            ? Icons.assignment_late_outlined
            : Icons.remove_red_eye_outlined;
        break;
      case EstadoDeInspeccion.finalizada:
        color = null;
        icon = Icons.remove_red_eye_outlined;
        break;
    }
    return Icon(
      icon,
      color: color,
    );
  }
}

void mostrarDialogPregunta(
    BuildContext context, ControladorDePregunta controladorPregunta) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Consumer(builder: (context, ref, child) {
                  final factory = ref.watch(preguntaCardFactoryProvider);
                  return factory.crearCard(
                    controladorPregunta.pregunta,
                    controlador: controladorPregunta,
                    nOrden: 0,
                  );
                }),
              ),
            ),
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Ok"),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
