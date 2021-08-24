import 'package:meta/meta.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:json_annotation/json_annotation.dart';
part 'tablas_unidas.g.dart';

///Esto es una mazamorra de clases que ayudan a manejar mejor las respuestas de las consultas
/// pero no es muy mantenible. Estoy de acuerdo
// TODO: mirar como hacer esto mantenible

/// Reune [pregunta] con sus rangos de criticidad [criticidades].
@immutable
class PreguntaNumerica {
  final Pregunta pregunta;
  final List<CriticidadesNumerica> criticidades;

  const PreguntaNumerica(this.pregunta, this.criticidades);
}

/// version con companions de la clase de arriba
@immutable
class PreguntaNumericaCompanion {
  final PreguntasCompanion pregunta;
  final List<CriticidadesNumericasCompanion> criticidades;

  const PreguntaNumericaCompanion(
    this.pregunta,
    this.criticidades,
  );
  PreguntaNumericaCompanion.fromDataClass(PreguntaNumerica p)
      : pregunta = p.pregunta.toCompanion(true),
        criticidades = p.criticidades.map((o) => o.toCompanion(true)).toList();
  const PreguntaNumericaCompanion.vacio()
      : pregunta = const PreguntasCompanion(),
        criticidades = const [];

  PreguntaNumericaCompanion copyWith({
    PreguntasCompanion? pregunta,
    List<CriticidadesNumericasCompanion>? criticidades,
  }) =>
      PreguntaNumericaCompanion(
        pregunta ?? this.pregunta,
        criticidades ?? this.criticidades,
      );
}

/// Reune los modelos de un cuestionario y su respectivo contratista.
@immutable
class CuestionarioConContratistaYModelos {
  final Cuestionario cuestionario;
  final List<CuestionarioDeModelo> cuestionarioDeModelo;
  final Contratista contratista;

  const CuestionarioConContratistaYModelos(
    this.cuestionario,
    this.cuestionarioDeModelo,
    this.contratista,
  );
}

/// version con companions de la clase de arriba
@immutable
class CuestionarioConContratistaYModelosCompanion {
  final CuestionariosCompanion cuestionario;
  final List<CuestionarioDeModelosCompanion> cuestionarioDeModelo;
  final Contratista? contratista;

  const CuestionarioConContratistaYModelosCompanion(
    this.cuestionario,
    this.cuestionarioDeModelo,
    this.contratista,
  );
  CuestionarioConContratistaYModelosCompanion.fromDataClass(
      CuestionarioConContratistaYModelos e)
      : cuestionario = e.cuestionario.toCompanion(true),
        cuestionarioDeModelo =
            e.cuestionarioDeModelo.map((o) => o.toCompanion(true)).toList(),
        contratista = e.contratista;
  const CuestionarioConContratistaYModelosCompanion.vacio()
      : cuestionario = const CuestionariosCompanion(),
        cuestionarioDeModelo = const [],
        contratista = null;

  CuestionarioConContratistaYModelosCompanion copyWith({
    CuestionariosCompanion? cuestionario,
    List<CuestionarioDeModelosCompanion>? cuestionarioDeModelo,
    Contratista? contratista,
  }) =>
      CuestionarioConContratistaYModelosCompanion(
        cuestionario ?? this.cuestionario,
        cuestionarioDeModelo ?? this.cuestionarioDeModelo,
        contratista ?? this.contratista,
      );
}

/// Reune [pregunta] con sus posibles respuestas.
///
/// Usado en [creacion_dao.dart] a la hora de cargar el cuestionario para editar  y en [llenado_dao.dart] para mostrar todas las posibles opciones.
/// Lo manejan [creacion_controls] y [llenado_controls]
@immutable
class PreguntaConOpcionesDeRespuesta {
  final Pregunta pregunta;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  const PreguntaConOpcionesDeRespuesta(
    this.pregunta,
    this.opcionesDeRespuesta,
  );
}

/// version con companions de la clase de arriba
@immutable
class PreguntaConOpcionesDeRespuestaCompanion {
  final PreguntasCompanion pregunta;
  final List<OpcionesDeRespuestaCompanion> opcionesDeRespuesta;

  const PreguntaConOpcionesDeRespuestaCompanion(
    this.pregunta,
    this.opcionesDeRespuesta,
  );
  PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(
      PreguntaConOpcionesDeRespuesta p)
      : pregunta = p.pregunta.toCompanion(true),
        opcionesDeRespuesta =
            p.opcionesDeRespuesta.map((o) => o.toCompanion(true)).toList();
  const PreguntaConOpcionesDeRespuestaCompanion.vacio()
      : pregunta = const PreguntasCompanion(),
        opcionesDeRespuesta = const [];

  PreguntaConOpcionesDeRespuestaCompanion copyWith({
    PreguntasCompanion? pregunta,
    List<OpcionesDeRespuestaCompanion>? opcionesDeRespuesta,
  }) =>
      PreguntaConOpcionesDeRespuestaCompanion(
        pregunta ?? this.pregunta,
        opcionesDeRespuesta ?? this.opcionesDeRespuesta,
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
@immutable
class CuadriculaConPreguntasYConOpcionesDeRespuesta {
  final CuadriculaDePreguntas cuadricula;
  final List<PreguntaConOpcionesDeRespuesta> preguntas;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  const CuadriculaConPreguntasYConOpcionesDeRespuesta(
      this.cuadricula, this.preguntas, this.opcionesDeRespuesta);
}

/// version con companions de la clase de arriba
@immutable
class CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion {
  final CuadriculasDePreguntasCompanion cuadricula;
  final List<PreguntaConOpcionesDeRespuestaCompanion> preguntas;
  final List<OpcionesDeRespuestaCompanion> opcionesDeRespuesta;

  const CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
    this.cuadricula,
    this.preguntas,
    this.opcionesDeRespuesta,
  );
  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.fromDataClass(
      CuadriculaConPreguntasYConOpcionesDeRespuesta c)
      : cuadricula = c.cuadricula.toCompanion(true),
        preguntas = c.preguntas
            .map(
                (p) => PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(p))
            .toList(),
        opcionesDeRespuesta =
            c.opcionesDeRespuesta.map((o) => o.toCompanion(true)).toList();
  const CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.vacio()
      : cuadricula = const CuadriculasDePreguntasCompanion(),
        preguntas = const [],
        opcionesDeRespuesta = const [];

  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion copyWith({
    CuadriculasDePreguntasCompanion? cuadricula,
    List<PreguntaConOpcionesDeRespuestaCompanion>? preguntas,
    List<OpcionesDeRespuestaCompanion>? opcionesDeRespuesta,
  }) =>
      CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
        cuadricula ?? this.cuadricula,
        preguntas ?? this.preguntas,
        opcionesDeRespuesta ?? this.opcionesDeRespuesta,
      );
}

/// Hace que todos los tipos de bloque (con titulo, con pregunta numerica, simple o cuadricula) se puedan ordenar de
///  acuerdo a [bloque.nOrden].
/// Los campos de respuesta en cada [IBloqueOrdenable] son opcionales porque en la parte de edición de cuestionarios no
/// existe ninguna respuesta, pero al usarlo para cargar el borrador de la inspección si se le envía el parametro [respuesta]
@immutable
abstract class IBloqueOrdenable {
  final Bloque bloque;

  const IBloqueOrdenable(this.bloque);

  int get nOrden => bloque.nOrden;
}

class BloqueConTitulo extends IBloqueOrdenable {
  final Titulo titulo;

  const BloqueConTitulo(Bloque bloque, this.titulo) : super(bloque);
}

/// Reúne la pregunta numérica [pregunta] con su respectiva respuesta
class BloqueConPreguntaNumerica extends IBloqueOrdenable {
  final PreguntaNumerica pregunta;

  /// En este caso, la respuesta es [respuesta.valor], por eso no se hace uso de la clase [RespuestaConOpcionesDeRespuesta]
  /// TODO: mirar si se necesita esto (en la creacion no se necesita)
  final RespuestasCompanion? respuesta;
  const BloqueConPreguntaNumerica(Bloque bloque, this.pregunta,
      [this.respuesta])
      : super(bloque);
}

/// Reune las preguntas de seleccion [pregunta] con sus respectivas respuesta
class BloqueConPreguntaSimple extends IBloqueOrdenable {
  final PreguntaConOpcionesDeRespuesta pregunta;

  /// List para el caso de las multiples
  /// TODO: mirar si se necesita esto (en la creacion no se necesita)
  final List<RespuestaConOpcionesDeRespuesta>? respuesta;

  const BloqueConPreguntaSimple(Bloque bloque, this.pregunta, [this.respuesta])
      : super(bloque);
}

/// Reúne la cuadricula con sus
class BloqueConCuadricula extends IBloqueOrdenable {
  /// Cuadricula y sus posibles opciones de respuesta (filas)
  final CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula;

  /// Todas las preguntas (sin opciones de respuesta, porque ya estan en [cuadricula])
  final List<PreguntaConOpcionesDeRespuesta> preguntas;

  /// En caso de que se use al cargar una inspeccion, trae las preguntas que se han contestado con su respectiva respuesta
  final List<PreguntaConRespuestaConOpcionesDeRespuesta>? preguntasRespondidas;

  const BloqueConCuadricula(
    Bloque bloque,
    this.cuadricula,
    this.preguntas, {
    this.preguntasRespondidas,
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
  Cuestionario? cuestionario;

  /// [avance] y [total] son usados para mostrar el porcentaje de avance de la inspeccion en la UI
  /// Total de Preguntas respondidas (así estén incompletas, por ejemplo, que no tengan fotos o no estén reparadas)
  int? avance;

  /// Total de preguntas del cuestionario
  int? total;
  Borrador(this.activo, this.inspeccion,
      [this.cuestionario, this.avance, this.total]);

  /// Ver [BorradoresDao.borradores()].

  @override
  String toString() =>
      'Borrador(activo: $activo, inspeccion: $inspeccion, cuestionario: $cuestionario)';

  Borrador copyWith({
    Activo? activo,
    Inspeccion? inspeccion,
    Cuestionario? cuestionario,
    int? avance,
    int? total,
  }) =>
      Borrador(
        activo ?? this.activo,
        inspeccion ?? this.inspeccion,
        cuestionario ?? this.cuestionario,
        avance ?? this.avance,
        total ?? this.total,
      );
}

class Programacion {
  ProgramacionSistemasCompanion programacion;
  List<Sistema> sistemas;
  Programacion(this.programacion, this.sistemas);
}

class GrupoXTipoInspeccion {
  final TiposDeInspeccione tipoInspeccion;
  final List<GruposInspecciones> grupos;
  GrupoXTipoInspeccion(this.tipoInspeccion, this.grupos);
}
