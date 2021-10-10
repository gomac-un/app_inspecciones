import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';

import '../../domain/bloques/pregunta.dart';
import '../../domain/bloques/preguntas/preguntas.dart';
import '../../domain/respuesta.dart';
import '../../infrastructure/inspecciones_repository.dart';
import '../controlador_de_pregunta.dart';
import '../controladores_de_pregunta/controladores_de_pregunta.dart';
import 'controlador_de_pregunta_visitor.dart';

/// Clase que usa el patrón visitor para pasar por todos los tipos de controles,
/// extraer su pregunta y agregarle la respuesta que tiene en ese momento.
/// Por ahora se muta la pregunta con la nueva respuesta pero se debe considerar
/// hacer este proceso inmutable.
class GuardadoVisitor implements ControladorDePreguntaVisitor {
  final InspeccionesRepository _repository;
  final List<ControladorDePregunta> _controladores;
  final Inspeccion _inspeccion;

  final List<Pregunta> preguntasRespondidas = [];

  GuardadoVisitor(this._repository, this._controladores,
      {required Inspeccion inspeccion})
      : _inspeccion = inspeccion;

  Future<void> guardarInspeccion() {
    preguntasRespondidas.clear();
    for (final c in _controladores) {
      c.accept(this);
    }
    return _repository.guardarInspeccion(preguntasRespondidas,
        inspeccion: _inspeccion);
  }

  @override
  void visitSeleccionUnica(ControladorDePreguntaDeSeleccionUnica controlador) {
    preguntasRespondidas.add(_buildSeleccionUnica(controlador));
  }

  PreguntaDeSeleccionUnica _buildSeleccionUnica(
          ControladorDePreguntaDeSeleccionUnica controlador) =>
      controlador.pregunta
        ..respuesta = RespuestaDeSeleccionUnica(
          controlador.guardarMetaRespuesta(),
          controlador.respuestaEspecificaControl.value,
        );

  @override
  void visitControladorDePreguntaNumerica(
      ControladorDePreguntaNumerica controlador) {
    preguntasRespondidas.add(
      controlador.pregunta
        ..respuesta = RespuestaNumerica(
          controlador.guardarMetaRespuesta(),
          respuestaNumerica: controlador.respuestaEspecificaControl.value,
        ),
    );
  }

  @override
  void visitCuadriculaSeleccionUnica(
      ControladorDeCuadriculaDeSeleccionUnica controlador) {
    preguntasRespondidas.add(
      controlador.pregunta
        ..respuesta = RespuestaDeCuadriculaDeSeleccionUnica(
          controlador.guardarMetaRespuesta(),
          controlador.controladoresPreguntas.map(_buildSeleccionUnica).toList(),
        ),
    );
  }

  @override
  void visitCuadriculaSeleccionMultiple(
      ControladorDeCuadriculaDeSeleccionMultiple controlador) {
    preguntasRespondidas.add(
      controlador.pregunta
        ..respuesta = RespuestaDeCuadriculaDeSeleccionMultiple(
          controlador.guardarMetaRespuesta(),
          controlador.controladoresPreguntas
              .map(_buildSeleccionMultiple)
              .toList(),
        ),
    );
  }

  @override
  void visitSeleccionMultiple(
      ControladorDePreguntaDeSeleccionMultiple pregunta) {
    preguntasRespondidas.add(_buildSeleccionMultiple(pregunta));
  }

  PreguntaDeSeleccionMultiple _buildSeleccionMultiple(
          ControladorDePreguntaDeSeleccionMultiple controlador) =>
      controlador.pregunta
        ..respuesta = RespuestaDeSeleccionMultiple(
          controlador.guardarMetaRespuesta(),
          controlador.controladoresPreguntas
              .map((c) => c.pregunta
                ..respuesta = SubRespuestaDeSeleccionMultiple(
                  c.guardarMetaRespuesta(),
                  estaSeleccionada: c.respuestaEspecificaControl.value!,
                ))
              .toList(),
        );
}
