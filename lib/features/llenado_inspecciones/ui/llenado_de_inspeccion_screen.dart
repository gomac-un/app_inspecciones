import 'package:flutter/material.dart';

import 'pregunta_card_factory.dart';

import '../control/controlador_llenado_inspeccion.dart';

class LlenadoDeInspeccionScreen extends StatelessWidget {
  final ControladorLlenadoInspeccion control;
  final PreguntaCardFactory factory;
  late final widgets = control.cuestionario.bloques
      .map(
        (b) => factory.crearCard(
          b,
          control.controladores.singleWhereOrNull((e) => e.pregunta == b),
        ),
      )
      .toList();

  LlenadoDeInspeccionScreen(this.control, this.factory, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemBuilder: (_, i) {
        return widgets[i];
      }),
    );
  }
}

extension NullableWhere<E> on Iterable<E> {
  E? singleWhereOrNull(bool Function(E element) test) {
    try {
      singleWhere(test);
    } catch (e) {
      return null;
    }
  }
}
