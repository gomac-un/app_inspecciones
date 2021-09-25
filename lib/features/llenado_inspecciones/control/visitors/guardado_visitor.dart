import '../../domain/respuesta.dart';
import '../../infrastructure/inspecciones_repository.dart';
import '../controlador_de_pregunta.dart';
import '../controladores_de_pregunta/controladores_de_pregunta.dart';
import 'controlador_de_pregunta_visitor.dart';

class GuardadoVisitor implements ControladorDePreguntaVisitor {
  final InspeccionesRepository _repository;
  final List<ControladorDePregunta> _controladores;
  final int _inspeccionId;

  final List<Respuesta> respuestas = [];

  GuardadoVisitor(this._repository, this._controladores,
      {required int inspeccionId})
      : _inspeccionId = inspeccionId;

  Future<void> guardarInspeccion() async {
    await Future.delayed(const Duration(seconds: 3));
    respuestas.clear();
    for (final c in _controladores) {
      c.accept(this);
    }
    return _repository.guardarInspeccion(respuestas,
        inspeccionId: _inspeccionId);
  }

  @override
  void visitSeleccionUnica(ControladorDePreguntaDeSeleccionUnica pregunta) {
    respuestas.add(_buildSeleccionUnica(pregunta));
  }

  RespuestaDeSeleccionUnica _buildSeleccionUnica(
          ControladorDePreguntaDeSeleccionUnica pregunta) =>
      RespuestaDeSeleccionUnica(pregunta.guardarMetaRespuesta(),
          pregunta.respuestaEspecificaControl.value);

  @override
  void visitControladorDePreguntaNumerica(
      ControladorDePreguntaNumerica pregunta) {
    respuestas.add(
      RespuestaNumerica(
        pregunta.guardarMetaRespuesta(),
        respuestaNumerica: pregunta.respuestaEspecificaControl.value,
      ),
    );
  }

  @override
  void visitCuadriculaSeleccionUnica(
      ControladorDeCuadriculaDeSeleccionUnica pregunta) {
    respuestas.add(
      RespuestaDeCuadriculaDeSeleccionUnica(
        pregunta.guardarMetaRespuesta(),
        pregunta.controladoresPreguntas.map(_buildSeleccionUnica).toList(),
      ),
    );
  }

  @override
  void visitCuadriculaSeleccionMultiple(
      ControladorDeCuadriculaDeSeleccionMultiple pregunta) {
    respuestas.add(
      RespuestaDeCuadriculaDeSeleccionMultiple(
        pregunta.guardarMetaRespuesta(),
        pregunta.controladoresPreguntas.map(_buildSeleccionMultiple).toList(),
      ),
    );
  }

  @override
  void visitSeleccionMultiple(
      ControladorDePreguntaDeSeleccionMultiple pregunta) {
    respuestas.add(_buildSeleccionMultiple(pregunta));
  }

  RespuestaDeSeleccionMultiple _buildSeleccionMultiple(
          ControladorDePreguntaDeSeleccionMultiple pregunta) =>
      RespuestaDeSeleccionMultiple(
        pregunta.guardarMetaRespuesta(),
        pregunta.controladoresPreguntas
            .map((c) => SubRespuestaDeSeleccionMultiple(
                  c.guardarMetaRespuesta(),
                  estaSeleccionada: c.respuestaEspecificaControl.value!,
                ))
            .toList(),
      );
}
