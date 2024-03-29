import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:inspecciones/utils/hooks.dart';

import '../../control/controlador_de_pregunta.dart';
import '../../domain/inspeccion.dart';

class WidgetCriticidad extends HookWidget {
  final ControladorDePregunta control;

  const WidgetCriticidad(
    this.control, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final estadoDeInspeccion =
        useValueStream(control.controlInspeccion.estadoDeInspeccion);
    final criticidadCalculada =
        useValueStream(control.criticidadCalculadaConReparaciones);

    return estadoDeInspeccion == EstadoDeInspeccion.borrador
        ? _WidgetCriticidad.borrador(
            criticidadPregunta: control.criticidadPregunta)
        : _WidgetCriticidad.noBorrador(
            criticidadCalculada: criticidadCalculada);
  }
}

class _WidgetCriticidad extends StatelessWidget {
  final int criticidad;
  final String mensajeCriticidad;

  const _WidgetCriticidad.borrador({Key? key, required int criticidadPregunta})
      : criticidad = criticidadPregunta,
        mensajeCriticidad = 'Criticidad pregunta',
        super(key: key);

  const _WidgetCriticidad.noBorrador(
      {Key? key, required int criticidadCalculada})
      : criticidad = criticidadCalculada,
        mensajeCriticidad = 'Criticidad',
        super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          criticidad > 0 ? _iconCritico : _iconNoCritico,
          Text(
            '$mensajeCriticidad: $criticidad',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      );

  static const _iconCritico =
      Icon(Icons.warning_amber_rounded, color: Colors.red); //size 25
  static const _iconNoCritico = Icon(Icons.remove_red_eye, color: Colors.green);
}
