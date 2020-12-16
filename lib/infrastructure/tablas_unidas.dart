part of 'moor_database.dart';

class BloqueConPreguntaRespondida {
  Bloque bloque;
  Pregunta pregunta;
  RespuestasCompanion respuesta; //Insertable<Respuestas>

  BloqueConPreguntaRespondida({
    @required this.bloque,
    @required this.pregunta,
    @required this.respuesta,
  });
}

class BloqueConPregunta {
  final Bloque bloque;
  final Pregunta pregunta;

  BloqueConPregunta({
    @required this.bloque,
    @required this.pregunta,
  });
}

class PreguntaConOpcionDeRespuesta {
  final Pregunta pregunta;
  final OpcionDeRespuesta opcionDeRespuesta;

  PreguntaConOpcionDeRespuesta(this.pregunta, this.opcionDeRespuesta);
}

class PreguntaConOpcionesDeRespuesta {
  final Pregunta pregunta;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  PreguntaConOpcionesDeRespuesta(this.pregunta, this.opcionesDeRespuesta);
}

class RespuestaConOpcionesDeRespuesta {
  RespuestasCompanion respuesta;
  List<OpcionDeRespuesta> opcionesDeRespuesta;

  RespuestaConOpcionesDeRespuesta(this.respuesta, this.opcionesDeRespuesta);
}

class PreguntaConRespuestaConOpcionesDeRespuesta {
  final Pregunta pregunta;
  RespuestaConOpcionesDeRespuesta respuesta;

  PreguntaConRespuestaConOpcionesDeRespuesta(this.pregunta, this.respuesta);
}

class CuadriculaDePreguntasConOpcionesDeRespuesta {
  final CuadriculaDePreguntas cuadricula;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  CuadriculaDePreguntasConOpcionesDeRespuesta(
      this.cuadricula, this.opcionesDeRespuesta);
}

abstract class IBloqueOrdenable {
  final Bloque bloque;

  IBloqueOrdenable(this.bloque);

  int get nOrden => bloque.nOrden;
}

class BloqueConTitulo extends IBloqueOrdenable {
  final Titulo titulo;

  BloqueConTitulo(Bloque bloque, this.titulo) : super(bloque);
}

class BloqueConPreguntaSimple extends IBloqueOrdenable {
  final PreguntaConOpcionesDeRespuesta pregunta;
  final RespuestaConOpcionesDeRespuesta respuesta;

  BloqueConPreguntaSimple(Bloque bloque, this.pregunta, this.respuesta)
      : super(bloque);
}

class BloqueConCuadricula extends IBloqueOrdenable {
  final CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula;
  final List<PreguntaConRespuestaConOpcionesDeRespuesta> preguntasRespondidas;

  BloqueConCuadricula(Bloque bloque, this.cuadricula, this.preguntasRespondidas)
      : super(bloque);
}

class Borrador {
  Activo activo;
  Inspeccion inspeccion;
  CuestionarioDeModelo cuestionarioDeModelo;
  Borrador(
    this.activo,
    this.inspeccion,
    this.cuestionarioDeModelo,
  );

  Borrador copyWith({
    Activo activo,
    Inspeccion inspeccion,
    CuestionarioDeModelo cuestionarioDeModelo,
  }) {
    return Borrador(
      activo ?? this.activo,
      inspeccion ?? this.inspeccion,
      cuestionarioDeModelo ?? this.cuestionarioDeModelo,
    );
  }

  @override
  String toString() =>
      'Borrador(activo: $activo, inspeccion: $inspeccion, cuestionarioDeModelo: $cuestionarioDeModelo)';
}
