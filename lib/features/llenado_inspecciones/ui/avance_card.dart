import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/llenado_inspecciones/control/controlador_llenado_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AvanceCard extends ConsumerWidget {
  final FormArray control;
  final int criticas;
  const AvanceCard(this.control, this.criticas, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estadoDeInspeccion = ref.watch(estadoDeInspeccionProvider).state;
    return Container(
      width: double.infinity,
      color: const Color.fromRGBO(28, 44, 60, 1),
      child: ReactiveValueListenableBuilder(
        formControl: control,
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
            children: [
              LinearProgressIndicator(
                  value: avance,
                  backgroundColor: Colors.white,
                  color: Theme.of(context).colorScheme.secondary),
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
