import 'package:drift/drift.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:meta/meta.dart';

/// Clases que agrupan [Dataclass]es de drift que están relacionadas
/// Las que tienen sufijo Companion, contienen tipos [UpdateCompanion], los
/// cuales se suelen usar para información editable que puede estar en un estado
///  parcial, mientras que las [Dataclass]es normales son útiles para
/// información traída de la BD que está completa y que no se va a editar.
///
/// Por ahora los companions (compuestos) definidos aquí, no implementan el
/// ==, es decir no se pueden comparar por valor, de ser necesario se puede
/// implementar facilmente

/// Reune [pregunta] con sus rangos de criticidad [criticidades].
@immutable
class PreguntaNumerica {
  final Pregunta pregunta;
  final List<CriticidadNumerica> criticidades;
  final List<EtiquetaDePregunta> etiquetas;

  const PreguntaNumerica(this.pregunta, this.criticidades, this.etiquetas);
}

/// version con companions de la clase de arriba
@immutable
class PreguntaNumericaCompanion {
  final PreguntasCompanion pregunta;
  final List<CriticidadesNumericasCompanion> criticidades;
  final List<EtiquetasDePreguntaCompanion> etiquetas;

  const PreguntaNumericaCompanion(
      this.pregunta, this.criticidades, this.etiquetas);
  PreguntaNumericaCompanion.fromDataClass(PreguntaNumerica p)
      : pregunta = p.pregunta.toCompanion(true),
        criticidades = p.criticidades.map((o) => o.toCompanion(true)).toList(),
        etiquetas = p.etiquetas.map((o) => o.toCompanion(true)).toList();

  const PreguntaNumericaCompanion.vacio()
      : pregunta = const PreguntasCompanion(),
        criticidades = const [],
        etiquetas = const [];

  PreguntaNumericaCompanion copyWith({
    PreguntasCompanion? pregunta,
    List<CriticidadesNumericasCompanion>? criticidades,
    List<EtiquetasDePreguntaCompanion>? etiquetas,
  }) =>
      PreguntaNumericaCompanion(
        pregunta ?? this.pregunta,
        criticidades ?? this.criticidades,
        etiquetas ?? this.etiquetas,
      );
}

class CuestionarioConEtiquetas {
  final Cuestionario cuestionario;
  final List<EtiquetaDeActivo> etiquetas;

  const CuestionarioConEtiquetas(
    this.cuestionario,
    this.etiquetas,
  );
}

/// version con companions de la clase de arriba
@immutable
class CuestionarioConEtiquetasCompanion {
  final CuestionariosCompanion cuestionario;
  final List<EtiquetaDeActivo> etiquetas;

  const CuestionarioConEtiquetasCompanion(
    this.cuestionario,
    this.etiquetas,
  );
  CuestionarioConEtiquetasCompanion.fromDataClass(CuestionarioConEtiquetas e)
      : cuestionario = e.cuestionario.toCompanion(true),
        etiquetas = e.etiquetas;
  const CuestionarioConEtiquetasCompanion.vacio()
      : cuestionario = const CuestionariosCompanion(),
        etiquetas = const [];

  CuestionarioConEtiquetasCompanion copyWith({
    CuestionariosCompanion? cuestionario,
    List<EtiquetaDeActivo>? etiquetas,
  }) =>
      CuestionarioConEtiquetasCompanion(
        cuestionario ?? this.cuestionario,
        etiquetas ?? this.etiquetas,
      );
}

/// Reune [pregunta] con sus posibles respuestas.
///
/// Usado en [creacion_dao.dart] a la hora de cargar el cuestionario para editar
///  y en [llenado_dao.dart] para mostrar todas las posibles opciones.
/// Lo manejan [creacion_controls] y [llenado_controls]
@immutable
class PreguntaConOpcionesDeRespuesta {
  final Pregunta pregunta;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;
  final List<EtiquetaDePregunta> etiquetas;

  const PreguntaConOpcionesDeRespuesta(
    this.pregunta,
    this.opcionesDeRespuesta,
    this.etiquetas,
  );
}

/// version con companions de la clase de arriba
@immutable
class PreguntaConOpcionesDeRespuestaCompanion {
  final PreguntasCompanion pregunta;
  final List<OpcionesDeRespuestaCompanion> opcionesDeRespuesta;
  final List<EtiquetasDePreguntaCompanion> etiquetas;

  const PreguntaConOpcionesDeRespuestaCompanion(
    this.pregunta,
    this.opcionesDeRespuesta,
    this.etiquetas,
  );
  PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(
      PreguntaConOpcionesDeRespuesta p)
      : pregunta = p.pregunta.toCompanion(true),
        opcionesDeRespuesta =
            p.opcionesDeRespuesta.map((o) => o.toCompanion(true)).toList(),
        etiquetas = p.etiquetas.map((o) => o.toCompanion(true)).toList();
  const PreguntaConOpcionesDeRespuestaCompanion.vacio()
      : pregunta = const PreguntasCompanion(),
        opcionesDeRespuesta = const [],
        etiquetas = const [];

  PreguntaConOpcionesDeRespuestaCompanion copyWith({
    PreguntasCompanion? pregunta,
    List<OpcionesDeRespuestaCompanion>? opcionesDeRespuesta,
    List<EtiquetasDePreguntaCompanion>? etiquetas,
  }) =>
      PreguntaConOpcionesDeRespuestaCompanion(
        pregunta ?? this.pregunta,
        opcionesDeRespuesta ?? this.opcionesDeRespuesta,
        etiquetas ?? this.etiquetas,
      );
}

/// Usada para el llenado de preguntas de seleccion Múltiple, donde cada
/// [OpcionDeRespuesta] de la pregunta debe tener una [respuesta] la cual
/// es companion porque es editable

@immutable
class RespuestaCompanionConOpcionDeRespuesta {
  /// Guarda información sobre las observaciones, fotos y reparaciones.
  final RespuestasCompanion respuesta;

  /// Respuesta seleccionada.
  final OpcionDeRespuesta opcionDeRespuesta;

  const RespuestaCompanionConOpcionDeRespuesta(
      this.respuesta, this.opcionDeRespuesta);
}

/// Usada para preguntas de seleccion única, [respuesta] es companion porque es
/// editable
@immutable
class RespuestaConOpcionDeRespuestaCompanion {
  /// Guarda información sobre las observaciones, fotos y reparaciones.
  final RespuestasCompanion respuesta;

  /// Respuesta seleccionada.
  final Value<OpcionDeRespuesta> opcionDeRespuesta;

  const RespuestaConOpcionDeRespuestaCompanion(
      this.respuesta, this.opcionDeRespuesta);
  const RespuestaConOpcionDeRespuestaCompanion.vacio()
      : respuesta = const RespuestasCompanion(),
        opcionDeRespuesta = const Value.absent();
}

/*
/// Usada para preguntas de seleccion múltiple, [respuesta] es companion porque es
/// editable
@immutable
class RespuestaConOpcionesDeRespuestaCompanion {
  /// Guarda información sobre las observaciones, fotos y reparaciones.
  final RespuestasCompanion respuesta;

  /// Respuestas seleccionada.
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  const RespuestaConOpcionesDeRespuestaCompanion(
      this.respuesta, this.opcionesDeRespuesta);
  const RespuestaConOpcionesDeRespuestaCompanion.vacio()
      : respuesta = const RespuestasCompanion(),
        opcionesDeRespuesta = const [];
  RespuestaConOpcionesDeRespuestaCompanion copyWith({
    RespuestasCompanion? respuesta,
    List<OpcionDeRespuesta>? opcionesDeRespuesta,
  }) {
    return RespuestaConOpcionesDeRespuestaCompanion(
      respuesta ?? this.respuesta,
      opcionesDeRespuesta ?? this.opcionesDeRespuesta,
    );
  }
}
*/

/// Usada en las cuadriculas, ver [BloqueConCuadricula] más abajo.
///
/// Reúne pregunta con sus respectivas respuestas
class PreguntaConRespuestaConOpcionesDeRespuesta {
  final Pregunta pregunta;

  PreguntaConRespuestaConOpcionesDeRespuesta(this.pregunta);
}
/*
/// Reune [cuadricula] con sus posibles [opcionesDeRespuesta] (Columnas de la cuadrícula)
class CuadriculaDePreguntasConOpcionesDeRespuesta {
  final Pregunta cuadricula;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;

  CuadriculaDePreguntasConOpcionesDeRespuesta(
      this.cuadricula, this.opcionesDeRespuesta);
}*/

/// Reune [cuadricula] con sus respectivas [preguntas] (filas) y [opcionesDeRespuesta] (columnas)
/// Se usa en el método [toDataClass()] y [toDB()] de la cuadricula en creacion_controls.
@immutable
class CuadriculaConPreguntasYConOpcionesDeRespuesta {
  final PreguntaConOpcionesDeRespuesta cuadricula;
  final List<PreguntaConOpcionesDeRespuesta> preguntas;

  const CuadriculaConPreguntasYConOpcionesDeRespuesta(
      this.cuadricula, this.preguntas);
}

/// version con companions de la clase de arriba
@immutable
class CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion {
  final PreguntaConOpcionesDeRespuestaCompanion cuadricula;
  final List<PreguntaConOpcionesDeRespuestaCompanion> preguntas;

  const CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
    this.cuadricula,
    this.preguntas,
  );
  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.fromDataClass(
      CuadriculaConPreguntasYConOpcionesDeRespuesta c)
      : cuadricula =
            PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(c.cuadricula),
        preguntas = c.preguntas
            .map(
                (p) => PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(p))
            .toList();

  const CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.vacio()
      : cuadricula = const PreguntaConOpcionesDeRespuestaCompanion.vacio(),
        preguntas = const [];

  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion copyWith({
    PreguntaConOpcionesDeRespuestaCompanion? cuadricula,
    List<PreguntaConOpcionesDeRespuestaCompanion>? preguntas,
  }) =>
      CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
        cuadricula ?? this.cuadricula,
        preguntas ?? this.preguntas,
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

  /// En este caso, la respuesta es [respuesta.valor], por eso no se hace uso de
  ///  la clase [RespuestaConOpcionesDeRespuesta]
  final RespuestasCompanion? respuesta;

  const BloqueConPreguntaNumerica(Bloque bloque, this.pregunta,
      [this.respuesta])
      : super(bloque);
}

/// Reune las preguntas de seleccion [pregunta] con sus respectivas respuesta
class BloqueConPreguntaSimple extends IBloqueOrdenable {
  final PreguntaConOpcionesDeRespuesta pregunta;

  const BloqueConPreguntaSimple(
    Bloque bloque,
    this.pregunta,
  ) : super(bloque);
}

/// Reúne la cuadricula con sus
class BloqueConCuadricula extends IBloqueOrdenable {
  /// Cuadricula y sus posibles opciones de respuesta (filas)
  final CuadriculaConPreguntasYConOpcionesDeRespuesta cuadricula;

  /*/// Todas las preguntas (sin opciones de respuesta, porque ya estan en [cuadricula])
  final List<PreguntaConOpcionesDeRespuesta> preguntas;*/

  const BloqueConCuadricula(Bloque bloque, this.cuadricula) : super(bloque);
}

class RespuestaconOpcionDeRespuestaId {
  final Respuesta respuesta;
  final int opcionDeRespuestaId;

  RespuestaconOpcionDeRespuestaId(this.respuesta, this.opcionDeRespuestaId);
}

/// Inspecciones empezadas a llenar localmente, se usan en [borrador_screen.dart]
class Borrador {
  final Activo activo;
  final Inspeccion inspeccion;
  late final Cuestionario cuestionario;

  /// [avance] y [total] son usados para mostrar el porcentaje de avance de la inspeccion en la UI
  /// Total de Preguntas respondidas (así estén incompletas, por ejemplo, que no tengan fotos o no estén reparadas)
  late final int avance;

  /// Total de preguntas del cuestionario
  late final int total;
  Borrador(this.activo, this.inspeccion);

  Borrador._copy(
      this.activo, this.inspeccion, this.cuestionario, this.avance, this.total);

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
      Borrador._copy(
        activo ?? this.activo,
        inspeccion ?? this.inspeccion,
        cuestionario ?? this.cuestionario,
        avance ?? this.avance,
        total ?? this.total,
      );
}
