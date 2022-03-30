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
            criticidadPregunta: control.criticidadPregunta,
            criticidadCalculada: criticidadCalculada,
          )
        : _WidgetCriticidad.noBorrador(
            criticidadCalculada: criticidadCalculada);
  }
}

class _WidgetCriticidad extends StatelessWidget {
  final int criticidad;
  final String mensajeCriticidad;
  final int? criticidadRespuesta;
  final String? mensajeCriticidadRespuesta;

  const _WidgetCriticidad.borrador(
      {Key? key,
      required int criticidadPregunta,
      required int criticidadCalculada})
      : criticidad = criticidadPregunta,
        mensajeCriticidad = 'Criticidad pregunta',
        criticidadRespuesta = criticidadCalculada,
        mensajeCriticidadRespuesta = 'Criticidad respuesta',
        super(key: key);

  const _WidgetCriticidad.noBorrador(
      {Key? key, required int criticidadCalculada})
      : criticidad = criticidadCalculada,
        mensajeCriticidad = 'Criticidad',
        criticidadRespuesta = null,
        mensajeCriticidadRespuesta = null,
        super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(flex: 1, child: Container()),
          Flexible(
            child: Column(
              children: [
                ListTile(
                  leading: criticidad > 0 ? _iconCritico : _iconNoCritico,
                  title: Text(
                    '$mensajeCriticidad: $criticidad',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                if (criticidadRespuesta != null &&
                    mensajeCriticidadRespuesta != null)
                  ListTile(
                    leading: criticidadRespuesta! > 0
                        ? _iconCritico
                        : _iconNoCritico,
                    title: Text(
                      '$mensajeCriticidadRespuesta: $criticidadRespuesta',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
              ],
            ),
          ),
        ],
      );

  static const _iconCritico =
      Icon(Icons.warning_amber_rounded, color: Colors.red); //size 25
  static const _iconNoCritico = Icon(Icons.remove_red_eye, color: Colors.green);
}
