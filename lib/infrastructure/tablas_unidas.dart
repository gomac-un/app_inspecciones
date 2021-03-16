part of 'moor_database.dart';

//Esto es una mazamorra de clases que ayudan a manejar mejor las respuestas de las consultas
// pero no es muy mantenible. Estoy de acuerdo
// TODO: mirar como hacer esto mantenible
class PreguntaNumerica {
  final Pregunta pregunta;
  final List<CriticidadesNumerica> criticidades;

  PreguntaNumerica(this.pregunta, this.criticidades);
}

class CuestionarioConContratista {
  final List<CuestionarioDeModelo> cuestionarioDeModelo;
  final Contratista contratista;

  CuestionarioConContratista(this.cuestionarioDeModelo, this.contratista);
}

class PreguntaConOpcionesDeRespuesta {
  final Pregunta pregunta;
  final List<OpcionDeRespuestaConCondicional> opcionesDeRespuestaConCondicional;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  PreguntaConOpcionesDeRespuesta(this.pregunta, this.opcionesDeRespuesta,
      {this.opcionesDeRespuestaConCondicional});
}

//TODO: Refactorizar a RespuestaCompanionConOpcionesDeRespuesta
// El enredo con los companions es porque al insertar la primera vez es mas
// comodo trabajar con el companion pero luego, al traerlos de la bd es mejor trabajar con la dataclass
// la clase RespuestaConOpcionesDeRespuesta2 en este momento maneja la dataclass en lugar del compnaion
class RespuestaConOpcionesDeRespuesta {
  RespuestasCompanion respuesta;
  List<OpcionDeRespuesta> opcionesDeRespuesta;

  RespuestaConOpcionesDeRespuesta(this.respuesta, this.opcionesDeRespuesta);
}

@JsonSerializable()
class RespuestaConOpcionesDeRespuesta2 {
  Respuesta respuesta;
  List<OpcionDeRespuesta> opcionesDeRespuesta;

  RespuestaConOpcionesDeRespuesta2(this.respuesta, this.opcionesDeRespuesta);

  factory RespuestaConOpcionesDeRespuesta2.fromJson(
          Map<String, dynamic> json) =>
      _$RespuestaConOpcionesDeRespuesta2FromJson(json);
  Map<String, dynamic> toJson() =>
      _$RespuestaConOpcionesDeRespuesta2ToJson(this);
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

class OpcionDeRespuestaConCondicional extends OpcionDeRespuesta {
  final OpcionDeRespuesta opcionRespuesta;
  final PreguntasCondicionalData condiciones;

  OpcionDeRespuestaConCondicional(this.opcionRespuesta, {this.condiciones});
}

class CuadriculaConPreguntasYConOpcionesDeRespuesta {
  final CuadriculaDePreguntas cuadricula;
  final List<PreguntaConOpcionesDeRespuesta> preguntas;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  CuadriculaConPreguntasYConOpcionesDeRespuesta(
      this.cuadricula, this.preguntas, this.opcionesDeRespuesta);
}

abstract class IBloqueOrdenable {
  Bloque bloque;

  IBloqueOrdenable(this.bloque);

  int get nOrden => bloque.nOrden;
}

class BloqueConTitulo extends IBloqueOrdenable {
  Titulo titulo;

  BloqueConTitulo(Bloque bloque, this.titulo) : super(bloque);
}

class BloqueConCondicional extends IBloqueOrdenable {
  final PreguntaConOpcionesDeRespuesta pregunta;
  final RespuestaConOpcionesDeRespuesta respuesta;
  final List<PreguntasCondicionalData> condiciones;

  BloqueConCondicional(Bloque bloque, this.pregunta, this.condiciones,
      {this.respuesta})
      : super(bloque);
}

class BloqueConPreguntaNumerica extends IBloqueOrdenable {
  final PreguntaNumerica pregunta;
  final RespuestasCompanion respuesta;
  BloqueConPreguntaNumerica(Bloque bloque, this.pregunta, {this.respuesta})
      : super(bloque);
}

class BloqueConPreguntaSimple extends IBloqueOrdenable {
  final PreguntaConOpcionesDeRespuesta pregunta;
  final RespuestaConOpcionesDeRespuesta respuesta;

  BloqueConPreguntaSimple(Bloque bloque, this.pregunta, {this.respuesta})
      : super(bloque);
}

class BloqueConCuadricula extends IBloqueOrdenable {
  final CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula;
  final List<PreguntaConRespuestaConOpcionesDeRespuesta> preguntasRespondidas;
  final List<PreguntaConOpcionesDeRespuesta> preguntas;

  BloqueConCuadricula(
    Bloque bloque,
    this.cuadricula, {
    this.preguntasRespondidas,
    this.preguntas,
  }) : super(bloque);
}

class RespuestaconOpcionDeRespuestaId {
  final Respuesta respuesta;
  final int opcionDeRespuestaId;

  RespuestaconOpcionDeRespuestaId(this.respuesta, this.opcionDeRespuestaId);
}

class Borrador {
  Activo activo;
  Inspeccion inspeccion;
  Cuestionario cuestionario;
  Borrador(
    this.activo,
    this.inspeccion,
    this.cuestionario,
  );

  Borrador copyWith({
    Activo activo,
    Inspeccion inspeccion,
    Cuestionario cuestionario,
  }) {
    return Borrador(
      activo ?? this.activo,
      inspeccion ?? this.inspeccion,
      cuestionario ?? this.cuestionario,
    );
  }

  @override
  String toString() =>
      'Borrador(activo: $activo, inspeccion: $inspeccion, cuestionario: $cuestionario)';
}
