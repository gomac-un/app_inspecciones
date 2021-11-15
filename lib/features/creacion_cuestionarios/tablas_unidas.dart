import 'package:drift/drift.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';

/// Clases que agrupan [Dataclass]es de drift que están relacionadas
/// Las que tienen sufijo Companion, contienen tipos [UpdateCompanion], los
/// cuales se suelen usar para información editable que puede estar en un estado
///  parcial, mientras que las [Dataclass]es normales son útiles para
/// información traída de la BD que está completa y que no se va a editar.
///
/// Por ahora los companions (compuestos) definidos aquí, no implementan el
/// ==, es decir no se pueden comparar por valor, de ser necesario se puede
/// implementar facilmente

abstract class DataClass<T> {
  Companion<DataClass<T>> toCompanion();
}

abstract class Companion<T extends DataClass> {}

class CuestionarioCompleto implements DataClass {
  final Cuestionario cuestionario;
  final List<EtiquetaDeActivo> etiquetas;
  final List<DataClass> bloques;

  const CuestionarioCompleto(
    this.cuestionario,
    this.etiquetas,
    this.bloques,
  );

  @override
  CuestionarioCompletoCompanion toCompanion() =>
      CuestionarioCompletoCompanion.fromDataClass(this);
}

class CuestionarioCompletoCompanion implements Companion<CuestionarioCompleto> {
  final CuestionariosCompanion cuestionario;
  final List<EtiquetasDeActivoCompanion> etiquetas;
  final List<Companion> bloques;

  const CuestionarioCompletoCompanion(
    this.cuestionario,
    this.etiquetas,
    this.bloques,
  );
  CuestionarioCompletoCompanion.fromDataClass(CuestionarioCompleto e)
      : cuestionario = e.cuestionario.toCompanion(true),
        etiquetas = e.etiquetas.map((b) => b.toCompanion(true)).toList(),
        bloques = e.bloques.map((b) => b.toCompanion()).toList();

  const CuestionarioCompletoCompanion.vacio()
      : cuestionario = const CuestionariosCompanion(),
        etiquetas = const [],
        bloques = const [TituloDCompanion.vacio()];

  CuestionarioCompletoCompanion copyWith({
    CuestionariosCompanion? cuestionario,
    List<EtiquetasDeActivoCompanion>? etiquetas,
    List<Companion>? bloques,
  }) =>
      CuestionarioCompletoCompanion(
        cuestionario ?? this.cuestionario,
        etiquetas ?? this.etiquetas,
        bloques ?? this.bloques,
      );
}

class TituloD implements DataClass<Titulo> {
  final Titulo titulo;

  TituloD(this.titulo);

  @override
  TituloDCompanion toCompanion() => TituloDCompanion.fromDataClass(this);
}

class TituloDCompanion implements Companion<TituloD> {
  final TitulosCompanion titulo;

  TituloDCompanion(this.titulo);

  TituloDCompanion.fromDataClass(TituloD e)
      : titulo = e.titulo.toCompanion(true);

  const TituloDCompanion.vacio() : titulo = const TitulosCompanion();

  TituloDCompanion copyWith({
    TitulosCompanion? titulo,
  }) =>
      TituloDCompanion(
        titulo ?? this.titulo,
      );
}

/// Reune [pregunta] con sus posibles respuestas.
///
/// Usado en [creacion_dao.dart] a la hora de cargar el cuestionario para editar
///  y en [llenado_dao.dart] para mostrar todas las posibles opciones.
/// Lo manejan [creacion_controls] y [llenado_controls]
class PreguntaDeSeleccion implements DataClass<PreguntaDeSeleccion> {
  final Pregunta pregunta;
  final List<OpcionDeRespuesta> opcionesDeRespuesta;
  final List<EtiquetaDePregunta> etiquetas;

  const PreguntaDeSeleccion(
    this.pregunta,
    this.opcionesDeRespuesta,
    this.etiquetas,
  );

  @override
  PreguntaDeSeleccionCompanion toCompanion() =>
      PreguntaDeSeleccionCompanion.fromDataClass(this);
}

class PreguntaDeSeleccionCompanion implements Companion<PreguntaDeSeleccion> {
  final PreguntasCompanion pregunta;
  final List<OpcionesDeRespuestaCompanion> opcionesDeRespuesta;
  final List<EtiquetasDePreguntaCompanion> etiquetas;

  const PreguntaDeSeleccionCompanion(
    this.pregunta,
    this.opcionesDeRespuesta,
    this.etiquetas,
  );
  PreguntaDeSeleccionCompanion.fromDataClass(PreguntaDeSeleccion p)
      : pregunta = p.pregunta.toCompanion(true),
        opcionesDeRespuesta =
            p.opcionesDeRespuesta.map((o) => o.toCompanion(true)).toList(),
        etiquetas = p.etiquetas.map((o) => o.toCompanion(true)).toList();

  const PreguntaDeSeleccionCompanion.vacio()
      : pregunta = const PreguntasCompanion(),
        opcionesDeRespuesta = const [],
        etiquetas = const [];

  PreguntaDeSeleccionCompanion copyWith({
    PreguntasCompanion? pregunta,
    List<OpcionesDeRespuestaCompanion>? opcionesDeRespuesta,
    List<EtiquetasDePreguntaCompanion>? etiquetas,
  }) =>
      PreguntaDeSeleccionCompanion(
        pregunta ?? this.pregunta,
        opcionesDeRespuesta ?? this.opcionesDeRespuesta,
        etiquetas ?? this.etiquetas,
      );
}

/// Reune [pregunta] con sus rangos de criticidad [criticidades].
class PreguntaNumerica implements DataClass<PreguntaNumerica> {
  final Pregunta pregunta;
  final List<CriticidadNumerica> criticidades;
  final List<EtiquetaDePregunta> etiquetas;

  const PreguntaNumerica(this.pregunta, this.criticidades, this.etiquetas);

  @override
  PreguntaNumericaCompanion toCompanion() =>
      PreguntaNumericaCompanion.fromDataClass(this);
}

class PreguntaNumericaCompanion implements Companion<PreguntaNumerica> {
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

/// Reune [cuadricula] con sus respectivas [preguntas] (filas) y [opcionesDeRespuesta] (columnas)
/// Se usa en el método [toDataClass()] y [toDB()] de la cuadricula en creacion_controls.
class CuadriculaConPreguntasYConOpcionesDeRespuesta
    implements DataClass<CuadriculaConPreguntasYConOpcionesDeRespuesta> {
  final PreguntaDeSeleccion cuadricula;
  final List<PreguntaDeSeleccion> preguntas;

  const CuadriculaConPreguntasYConOpcionesDeRespuesta(
      this.cuadricula, this.preguntas);

  @override
  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion toCompanion() =>
      CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.fromDataClass(
          this);
}

class CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion
    implements Companion<CuadriculaConPreguntasYConOpcionesDeRespuesta> {
  final PreguntaDeSeleccionCompanion cuadricula;
  final List<PreguntaDeSeleccionCompanion> preguntas;

  const CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
    this.cuadricula,
    this.preguntas,
  );
  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.fromDataClass(
      CuadriculaConPreguntasYConOpcionesDeRespuesta c)
      : cuadricula = PreguntaDeSeleccionCompanion.fromDataClass(c.cuadricula),
        preguntas = c.preguntas
            .map((p) => PreguntaDeSeleccionCompanion.fromDataClass(p))
            .toList();

  const CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.vacio()
      : cuadricula = const PreguntaDeSeleccionCompanion.vacio(),
        preguntas = const [];

  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion copyWith({
    PreguntaDeSeleccionCompanion? cuadricula,
    List<PreguntaDeSeleccionCompanion>? preguntas,
  }) =>
      CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
        cuadricula ?? this.cuadricula,
        preguntas ?? this.preguntas,
      );
}
