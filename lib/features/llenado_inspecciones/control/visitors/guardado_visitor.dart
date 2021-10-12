import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';

import '../../domain/bloques/pregunta.dart';
import '../../domain/bloques/preguntas/preguntas.dart';
import '../../domain/respuesta.dart';
import '../../infrastructure/inspecciones_repository.dart';
import '../controlador_de_pregunta.dart';
import '../controladores_de_pregunta/controladores_de_pregunta.dart';
import 'controlador_de_pregunta_visitor.dart';

class GuardadoVisitor implements ControladorDePreguntaVisitor<Pregunta> {
  final InspeccionesRepository _repository;
  final List<ControladorDePregunta> _controladores;
  final Inspeccion _inspeccion;

  /// Clase que usa el patrón visitor para pasar por todos los tipos de controles,
  /// extraer su pregunta y agregarle la respuesta que tiene en ese momento.
  /// Por ahora se muta la pregunta con la nueva respuesta pero se debe considerar
  /// hacer este proceso inmutable.
  GuardadoVisitor(
    this._repository,
    this._controladores, {
    required Inspeccion inspeccion,
  }) : _inspeccion = inspeccion;

  Future<void> guardarInspeccion() {
    final preguntasRespondidas = _controladores.map((c) => c.accept(this));
    return _repository.guardarInspeccion(preguntasRespondidas, _inspeccion);
  }

  @override
  visitSeleccionUnica(ControladorDePreguntaDeSeleccionUnica controlador) =>
      _buildSeleccionUnica(controlador);

  PreguntaDeSeleccionUnica _buildSeleccionUnica(
          ControladorDePreguntaDeSeleccionUnica controlador) =>
      controlador.pregunta
        ..respuesta = RespuestaDeSeleccionUnica(
          controlador.guardarMetaRespuesta(),
          controlador.respuestaEspecificaControl.value,
        );

  @override
  visitControladorDePreguntaNumerica(
          ControladorDePreguntaNumerica controlador) =>
      controlador.pregunta
        ..respuesta = RespuestaNumerica(
          controlador.guardarMetaRespuesta(),
          respuestaNumerica: controlador.respuestaEspecificaControl.value,
        );

  @override
  visitCuadriculaSeleccionUnica(
          ControladorDeCuadriculaDeSeleccionUnica controlador) =>
      controlador.pregunta
        ..respuesta = RespuestaDeCuadriculaDeSeleccionUnica(
          controlador.guardarMetaRespuesta(),
          controlador.controladoresPreguntas.map(_buildSeleccionUnica).toList(),
        );

  @override
  visitCuadriculaSeleccionMultiple(
          ControladorDeCuadriculaDeSeleccionMultiple controlador) =>
      controlador.pregunta
        ..respuesta = RespuestaDeCuadriculaDeSeleccionMultiple(
          controlador.guardarMetaRespuesta(),
          controlador.controladoresPreguntas
              .map(_buildSeleccionMultiple)
              .toList(),
        );

  @override
  visitSeleccionMultiple(ControladorDePreguntaDeSeleccionMultiple pregunta) =>
      _buildSeleccionMultiple(pregunta);

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
