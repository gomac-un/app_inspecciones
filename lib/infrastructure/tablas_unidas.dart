part of 'moor_database.dart';

///Esto es una mazamorra de clases que ayudan a manejar mejor las respuestas de las consultas
/// pero no es muy mantenible. Estoy de acuerdo
// TODO: mirar como hacer esto mantenible

/// Reune [pregunta] con sus rangos de criticidad [criticidades].
class PreguntaNumerica {
  final Pregunta pregunta;
  final List<CriticidadesNumerica> criticidades;

  PreguntaNumerica(this.pregunta, this.criticidades);
}

class GrupoXTipoInspeccion {
  final TiposDeInspeccione tipoInspeccion;
  final List<GruposInspecciones> grupos;
  GrupoXTipoInspeccion({this.tipoInspeccion, this.grupos});

  GrupoXTipoInspeccion copyWith({
    TiposDeInspeccione tipoInspeccion,
    List<GruposInspecciones> grupos,
  }) {
    return GrupoXTipoInspeccion(
      tipoInspeccion: tipoInspeccion ?? this.tipoInspeccion,
      grupos: grupos ?? this.grupos,
    );
  }
}

/// Reune los modelos de un cuestionario y su respectivo contratista.
class CuestionarioConContratista {
  final List<CuestionarioDeModelo> cuestionarioDeModelo;
  final Contratista contratista;

  CuestionarioConContratista(this.cuestionarioDeModelo, this.contratista);
}

/// Reune [pregunta] con sus posibles respuestas.
///
/// Usado en [creacion_dao.dart] a la hora de cargar el cuestionario para editar  y en [llenado_dao.dart] para mostrar todas las posibles opciones.
/// Lo manejan [creacion_controls] y [llenado_controls]
class PreguntaConOpcionesDeRespuesta {
  final Pregunta pregunta;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  PreguntaConOpcionesDeRespuesta(
    this.pregunta,
    this.opcionesDeRespuesta,
  );
}

//TODO: Refactorizar a RespuestaCompanionConOpcionesDeRespuesta
// El enredo con los companions es porque al insertar la primera vez es mas
// comodo trabajar con el companion pero luego, al traerlos de la bd es mejor trabajar con la dataclass
// la clase RespuestaConOpcionesDeRespuesta2 en este momento maneja la dataclass en lugar del compnaion

class RespuestaConOpcionesDeRespuesta {
  /// Guarda información sobre las observaciones, fotos y reparaciones.
  RespuestasCompanion respuesta;

  /// Respuesta seleccionada.
  OpcionDeRespuesta opcionesDeRespuesta;

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

/// Usada en las cuadriculas, ver [BloqueConCuadricula] más abajo.
///
/// Reúne pregunta con sus respectivas respuestas
class PreguntaConRespuestaConOpcionesDeRespuesta {
  final Pregunta pregunta;
  List<RespuestaConOpcionesDeRespuesta> respuesta;

  PreguntaConRespuestaConOpcionesDeRespuesta(this.pregunta, this.respuesta);
}

/// Reune [cuadricula] con sus posibles [opcionesDeRespuesta] (Columnas de la cuadrícula)
class CuadriculaDePreguntasConOpcionesDeRespuesta {
  final CuadriculaDePreguntas cuadricula;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  CuadriculaDePreguntasConOpcionesDeRespuesta(
      this.cuadricula, this.opcionesDeRespuesta);
}

/// Reune [cuadricula] con sus respectivas [preguntas] (filas) y [opcionesDeRespuesta] (columnas)
/// Se usa en el método [toDataClass()] y [toDB()] de la cuadricula en creacion_controls.
class CuadriculaConPreguntasYConOpcionesDeRespuesta {
  final CuadriculaDePreguntas cuadricula;
  final List<PreguntaConOpcionesDeRespuesta> preguntas;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  CuadriculaConPreguntasYConOpcionesDeRespuesta(
      this.cuadricula, this.preguntas, this.opcionesDeRespuesta);
}

/// Hace que todos los tipos de bloque (con titulo, con pregunta numerica, simple o cuadricula) se puedan ordenar de
///  acuerdo a [bloque.nOrden].
/// Los campos de respuesta en cada [IBloqueOrdenable] son opcionales porque en la parte de edición de cuestionarios no
/// existe ninguna respuesta, pero al usarlo para cargar el borrador de la inspección si se le envía el parametro [respuesta]
abstract class IBloqueOrdenable {
  Bloque bloque;

  IBloqueOrdenable(this.bloque);

  int get nOrden => bloque.nOrden;
}

class BloqueConTitulo extends IBloqueOrdenable {
  Titulo titulo;

  BloqueConTitulo(Bloque bloque, this.titulo) : super(bloque);
}

/// Reúne la pregunta numérica [pregunta] con su respectiva respuesta
class BloqueConPreguntaNumerica extends IBloqueOrdenable {
  final PreguntaNumerica pregunta;

  /// En este caso, la respuesta es [respuesta.valor], por eso no se hace uso de la clase [RespuestaConOpcionesDeRespuesta]
  final RespuestasCompanion respuesta;
  BloqueConPreguntaNumerica(Bloque bloque, this.pregunta, {this.respuesta})
      : super(bloque);
}

/// Reune las preguntas de seleccion [pregunta] con sus respectivas respuesta
class BloqueConPreguntaSimple extends IBloqueOrdenable {
  final PreguntaConOpcionesDeRespuesta pregunta;

  /// List para el caso de las multiples
  final List<RespuestaConOpcionesDeRespuesta> respuesta;

  BloqueConPreguntaSimple(Bloque bloque, this.pregunta, {this.respuesta})
      : super(bloque);
}

/// Reúne la cuadricula con sus
class BloqueConCuadricula extends IBloqueOrdenable {
  /// Cuadricula y sus posibles opciones de respuesta (filas)
  final CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula;

  /// En caso de que se use al cargar una inspeccion, trae las preguntas que se han contestado con su respectiva respuesta
  final List<PreguntaConRespuestaConOpcionesDeRespuesta> preguntasRespondidas;

  /// Todas las preguntas (sin opciones de respuesta, porque ya estan en [cuadricula])
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

/// Inspecciones empezadas a llenar localmente, se usan en [borrador_screen.dart]
class Borrador {
  Activo activo;
  Inspeccion inspeccion;
  late final Cuestionario cuestionario;

  /// [avance] y [total] son usados para mostrar el porcentaje de avance de la inspeccion en la UI
  /// Total de Preguntas respondidas (así estén incompletas, por ejemplo, que no tengan fotos o no estén reparadas)
  late final int avance;

  /// Total de preguntas del cuestionario
  late final int total;
  Borrador(this.activo, this.inspeccion);

  /// Ver [BorradoresDao.borradores()].
  Borrador copyWith({
    Activo activo,
    Inspeccion inspeccion,
    Cuestionario cuestionario,
    int avance,
    int total,
  }) {
    return Borrador(
        activo ?? this.activo,
        inspeccion ?? this.inspeccion,
        cuestionario ?? this.cuestionario,
        avance ?? this.avance,
        total ?? this.total);
  }

  @override
  String toString() =>
      'Borrador(activo: $activo, inspeccion: $inspeccion, cuestionario: $cuestionario)';
}

class Programacion {
  ProgramacionSistemasCompanion programacion;
  List<Sistema> sistemas;
  Programacion({this.programacion, this.sistemas});
}
