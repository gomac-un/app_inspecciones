part of 'moor_database.dart';

//Esto es una mazamorra de clases que ayudan a manejar mejor las respuestas de las consultas
// pero no es muy mantenible
// TODO: mirar como hacer esto mantenible
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

class CuadriculaConPreguntasYConOpcionesDeRespuesta {
  final CuadriculaDePreguntas cuadricula;
  final List<PreguntaConOpcionesDeRespuesta> preguntas;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  CuadriculaConPreguntasYConOpcionesDeRespuesta(
      this.cuadricula, this.preguntas, this.opcionesDeRespuesta);
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

/*
@JsonSerializable()
class InspeccionConRespuestas {
  final Inspeccion inspeccion;
  final List<RespuestaConOpcionesDeRespuesta2> respuestas;

  InspeccionConRespuestas(this.inspeccion, this.respuestas);

  factory InspeccionConRespuestas.fromJson(Map<String, dynamic> json) =>
      _$InspeccionConRespuestasFromJson(json);
  Map<String, dynamic> toJson() => _$InspeccionConRespuestasToJson(this);
}*/
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
