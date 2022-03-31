import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:inspecciones/utils/hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../control/controlador_llenado_inspeccion.dart';
import '../../domain/inspeccion.dart';

class AvanceCard extends HookWidget {
  final ControladorLlenadoInspeccion control;
  const AvanceCard(this.control, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //TODO: arreglar la reactividad
    final controles = control.formArray;
    final int criticas = useValueStream(control.controladoresCriticos).length;
    final estadoDeInspeccion = useValueStream(control.estadoDeInspeccion);
    return Container(
      color: estadoDeInspeccion == EstadoDeInspeccion.enReparacion
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.primary,
      child: ReactiveValueListenableBuilder(
        formControl: controles,
        builder: (context, value, child) {
          final double avance;
          switch (estadoDeInspeccion) {
            case EstadoDeInspeccion.borrador:
              avance = (value as FormArray)
                      .controls
                      .where((element) => element.valid)
                      .toList()
                      .length /
                  value.controls.length;
              break;
            case EstadoDeInspeccion.enReparacion:
              avance = criticas == 0
                  ? 0.0
                  : (value as FormArray)
                          .controls
                          .where((element) =>
                              ((element as FormGroup).control('metaRespuesta')
                                      as FormGroup)
                                  .control('reparado')
                                  .value as bool &&
                              element.valid)
                          .toList()
                          .length /
                      criticas;
              break;
            case EstadoDeInspeccion.finalizada:
              avance = 1.0;
              break;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  value: avance,
                  //backgroundColor: Colors.white,
                  color: estadoDeInspeccion == EstadoDeInspeccion.enReparacion
                      ? const Color.fromRGBO(67, 140, 201, 1)
                      : Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 3),
              Text(
                estadoDeInspeccion == EstadoDeInspeccion.enReparacion
                    ? '${(avance * 100).round()}% reparado'
                    : '${(avance * 100).round()}% completado',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                textAlign: TextAlign.end,
              ),
            ],
          );
        },
      ),
    );
  }
}
