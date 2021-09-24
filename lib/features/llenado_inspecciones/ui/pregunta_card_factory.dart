import 'package:flutter/widgets.dart';

import '../model/bloque.dart';
import '../model/bloques/bloques.dart';

import '../control/controlador_de_pregunta.dart';

import 'widgets/bloque_card.dart';
import 'bloques/bloques.dart';

class PreguntaCardFactory {
  BloqueCard crearCard(Bloque bloque, [ControladorDePregunta? controlador]) {
    return BloqueCard(widgetBloque: _crearCard(bloque, controlador));
  }

  Widget _crearCard(Bloque bloque, [ControladorDePregunta? controlador]) {
    if (bloque is Titulo) {
      return WidgetTitulo(bloque);
    }
    if (controlador == null) throw Exception("se require controlador");
    if (bloque is PreguntaNumerica) {
      return WidgetPreguntaNumerica(bloque, controlador);
    }
    throw UnimplementedError();
  }
}
