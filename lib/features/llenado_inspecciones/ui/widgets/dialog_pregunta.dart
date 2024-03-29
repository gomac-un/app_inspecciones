import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/utils/hooks.dart';

import '../../control/controlador_de_pregunta.dart';
import '../../domain/inspeccion.dart';
import '../pregunta_card_factory.dart';

class IconDialogPregunta extends HookWidget {
  const IconDialogPregunta({
    Key? key,
    required this.controladorPregunta,
  }) : super(key: key);

  final ControladorDePregunta controladorPregunta;

  @override
  Widget build(BuildContext context) {
    final estadoDeInspeccion = useValueStream(
        controladorPregunta.controlInspeccion.estadoDeInspeccion);
    final reparado = useControlValue(controladorPregunta.reparadoControl)!;
    final controlValido = useControlValid(controladorPregunta.control);
    final criticidadCalculada =
        useValueStream(controladorPregunta.criticidadCalculadaConReparaciones);

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
