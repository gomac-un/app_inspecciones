import 'package:drift/drift.dart';
import 'package:inspecciones/core/error/errors.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';

part 'guardado_cuestionario_dao.drift.dart';

@DriftAccessor(tables: [
  EtiquetasDeActivo,
  Cuestionarios,
  CuestionariosXEtiquetas,
  Bloques,
  Titulos,
  EtiquetasDePregunta,
  Preguntas,
  PreguntasXEtiquetas,
  OpcionesDeRespuesta,
  CriticidadesNumericas,
])
class GuardadoDeCuestionarioDao extends DatabaseAccessor<Database>
    with _$GuardadoDeCuestionarioDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  GuardadoDeCuestionarioDao(Database db) : super(db);

  /// Guarda o crea un cuestionario con sus respectivas preguntas.
  Future<void> guardarCuestionario(
    CuestionariosCompanion cuestionarioForm,
    List<EtiquetasDeActivoCompanion> etiquetasAplicablesForm,
    List<Object> bloquesForm,
  ) async {
    /// Como es una transaccion si algo falla, ningun cambio queda en la DB
    return transaction(
      () async {
        final cuestionario = await _upsertCuestionario(cuestionarioForm);
        await _insertEtiquetasDeActivo(etiquetasAplicablesForm, cuestionario);

        // La estrategia es borrar todo y volverlo a crear para que sea mas simple
        await (delete(bloques)
              ..where(
                  (bloque) => bloque.cuestionarioId.equals(cuestionario.id)))
            .go();

        /// Procesamiento de cada object del formulario de acuerdo a si es
        /// titulo, pregunta de selección o numerica y cuadricula.
        /// Hay que tener especial cuidado en tratar todo tipo posible que
        /// venga desde el formulario creacion (metodos toDB), ya que si llega
        /// uno de distinto tipo, va a fallar, esto se debería evitar usando
        /// algun tipo de tagged union o el patrón visitor
        ///
        /// Se le asigna a cada pregunta o titulo [bloqueId]
        await Future.forEach<MapEntry<int, Object>>(bloquesForm.asMap().entries,
            (entry) async {
          final i = entry.key;
          final element = entry.value;
          final bloque = await into(bloques).insertReturning(
            BloquesCompanion.insert(nOrden: i, cuestionarioId: cuestionario.id),
          );

          if (element is TitulosCompanion) {
            await into(titulos).insert(element.copyWith(
              bloqueId: Value(bloque.id),
            ));
          } else if (element is PreguntaNumericaCompanion) {
            await _procesarPregunta(
              element.pregunta,
              cuestionario,
              bloque,
              criticidades: element.criticidades,
              etiquetas: element.etiquetas,
            );
          } else if (element is PreguntaConOpcionesDeRespuestaCompanion) {
            await _procesarPregunta(
              element.pregunta,
              cuestionario,
              bloque,
              opcionesDeRespuesta: element.opcionesDeRespuesta,
              etiquetas: element.etiquetas,
            );
          } else if (element
              is CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion) {
            final cuadricula = await _procesarPregunta(
              element.cuadricula.pregunta,
              cuestionario,
              bloque,
              opcionesDeRespuesta: element.cuadricula.opcionesDeRespuesta,
              etiquetas: element.cuadricula.etiquetas,
            );

            await (delete(preguntas)
                  ..where((p) => p.cuadriculaId.equals(cuadricula.id)))
                .go();

            for (final pregunta in element.preguntas) {
              await _procesarPregunta(
                pregunta.pregunta,
                cuestionario,
                bloque,
                opcionesDeRespuesta: [],
              );
            }
          } else {
            throw TaggedUnionError(element);
          }
        });
      },
    );
  }

  /// crea o actualiza un cuestionario
  /// Si el companion viene con id TIENE que estar ya en la db entonces se actualiza, sino se inserta
  Future<Cuestionario> _upsertCuestionario(
      CuestionariosCompanion cuestionarioForm) async {
    if (cuestionarioForm.id.present) {
      await update(cuestionarios).replace(cuestionarioForm);
      return (select(cuestionarios)
            ..where((c) => c.id.equals(cuestionarioForm.id.value)))
          .getSingle();
    } else {
      return into(cuestionarios).insertReturning(cuestionarioForm);
    }
  }

  /// Actualiza los modelos asociados a [cuestionario]
  Future<void> _insertEtiquetasDeActivo(
    List<EtiquetasDeActivoCompanion> etiquetasForm,
    Cuestionario cuestionario,
  ) async {
    // borras las antiguas asociaciones
    await (delete(cuestionariosXEtiquetas)
          ..where((cxe) => cxe.cuestionarioId.equals(cuestionario.id)))
        .go();

    for (final etiqueta in etiquetasForm) {
      final etiquetaDeActivo = await into(etiquetasDeActivo)
          .insertReturning(etiqueta, mode: InsertMode.insertOrIgnore);

      await into(cuestionariosXEtiquetas).insert(
        CuestionariosXEtiquetasCompanion.insert(
          cuestionarioId: cuestionario.id,
          etiquetaId: etiquetaDeActivo.id,
        ),
      );
    }
  }

  Future<Pregunta> _procesarPregunta(
    PreguntasCompanion preguntaCompanion,
    Cuestionario cuestionario,
    Bloque bloque, {
    List<OpcionesDeRespuestaCompanion>? opcionesDeRespuesta,
    List<CriticidadesNumericasCompanion>? criticidades,
    List<EtiquetasDePreguntaCompanion> etiquetas = const [],
  }) async {
    final preguntaAInsertar = preguntaCompanion.copyWith(
      bloqueId: Value(bloque.id),
    );

    final pregunta = await into(preguntas).insertReturning(preguntaAInsertar);
    if (opcionesDeRespuesta != null) {
      await _insertOpcionesDeRespuesta(opcionesDeRespuesta, pregunta);
    } else if (criticidades != null) {
      await _insertCriticidades(criticidades, pregunta);
    } else {
      throw TaggedUnionError("debe enviar opcionesDeRespuesta o criticidades");
    }
    await _insertEtiquetasDePregunta(etiquetas, pregunta);

    return pregunta;
  }

  Future<void> _insertOpcionesDeRespuesta(
      List<OpcionesDeRespuestaCompanion> opcionesDeRespuestaForm,
      Pregunta pregunta) async {
    await (delete(opcionesDeRespuesta)
          ..where((rxor) => rxor.preguntaId.equals(pregunta.id)))
        .go();
    for (final opcion in opcionesDeRespuestaForm) {
      await into(opcionesDeRespuesta).insert(opcion.copyWith(
        preguntaId: Value(pregunta.id),
      ));
    }
  }

  Future<void> _insertCriticidades(
    List<CriticidadesNumericasCompanion> criticidadesForm,
    Pregunta pregunta,
  ) async {
    await (delete(criticidadesNumericas)
          ..where((rxor) => rxor.preguntaId.equals(pregunta.id)))
        .go();
    for (final criticidad in criticidadesForm) {
      await into(criticidadesNumericas).insert(criticidad.copyWith(
        preguntaId: Value(pregunta.id),
      ));
    }
  }

  Future<void> _insertEtiquetasDePregunta(
    List<EtiquetasDePreguntaCompanion> etiquetasForm,
    Pregunta pregunta,
  ) async {
    // borras las antiguas asociaciones
    await (delete(preguntasXEtiquetas)
          ..where((pxe) => pxe.preguntaId.equals(pregunta.id)))
        .go();

    for (final etiqueta in etiquetasForm) {
      final etiquetaDePregunta = await into(etiquetasDePregunta)
          .insertReturning(etiqueta, mode: InsertMode.insertOrIgnore);

      await into(preguntasXEtiquetas).insert(
        PreguntasXEtiquetasCompanion.insert(
          preguntaId: pregunta.id,
          etiquetaId: etiquetaDePregunta.id,
        ),
      );
    }
  }
}
