import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../control/controlador_de_pregunta.dart';
import '../control/controladores_de_pregunta/controladores_de_pregunta.dart';
import '../domain/bloque.dart';
import '../domain/bloques/bloques.dart';
import 'bloques/bloques.dart';
import 'widgets/pregunta_card.dart';

final preguntaCardFactoryProvider =
    Provider((ref) => const PreguntaCardFactory());

class PreguntaCardFactory {
  const PreguntaCardFactory();

  Widget crearCard(Bloque bloque,
      {ControladorDePregunta? controlador, required int nOrden}) {
    if (bloque is Titulo) {
      return WidgetTitulo(
        bloque,
        key: ObjectKey(bloque),
      );
    }

    if (bloque is Pregunta) {
      if (controlador == null) {
        throw Exception(
            "Los bloques de tipo pregunta requieren un controlador");
      }
      return PreguntaCard(
        pregunta: bloque,
        controlador: controlador,
        child: _crearPregunta(
          bloque,
          controlador,
        ),
        nOrden: nOrden,
        key: ObjectKey(bloque),
      );
    }
    throw Exception("tipo de bloque no esperado");
  }

  Widget _crearPregunta(Pregunta pregunta, ControladorDePregunta controlador) {
    if (pregunta is PreguntaNumerica) {
      return WidgetPreguntaNumerica(
          controlador as ControladorDePreguntaNumerica);
    }
    if (pregunta is PreguntaDeSeleccionUnica) {
      return WidgetPreguntaDeSeleccionUnica(
          controlador as ControladorDePreguntaDeSeleccionUnica);
    }
    if (pregunta is CuadriculaDeSeleccionUnica) {
      return WidgetCuadriculaDeSeleccionUnica(
          controlador as ControladorDeCuadriculaDeSeleccionUnica);
    }
    if (pregunta is CuadriculaDeSeleccionMultiple) {
      return WidgetCuadriculaDeSeleccionMultiple(
          controlador as ControladorDeCuadriculaDeSeleccionMultiple);
    }
    if (pregunta is PreguntaDeSeleccionMultiple) {
      return WidgetPreguntaDeSeleccionMultiple(
          controlador as ControladorDePreguntaDeSeleccionMultiple);
    }
    if (pregunta is SubPreguntaDeSeleccionMultiple) {
      return const SizedBox
          .shrink(); // a este tipo de pregunta solo le importa la metarespuesta
    }
    throw UnimplementedError(
        "La pregunta de tipo ${pregunta.runtimeType} no tiene asociado un widget en el pregunta_card_factory, por favor asignele uno");
  }
}
