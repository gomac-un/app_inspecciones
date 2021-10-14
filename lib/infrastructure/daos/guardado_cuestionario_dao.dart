import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:inspecciones/core/error/errors.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';

part 'guardado_cuestionario_dao.drift.dart';

@DriftAccessor(tables: [
  Bloques,
  Titulos,
  CuadriculasDePreguntas,
  Preguntas,
  Cuestionarios,
  CuestionarioDeModelos,
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

    /// Información sobre los modelos a los que aplica [cuestionario], periodicidad y contratista
    List<CuestionarioDeModelosCompanion> cuestionariosDeModelosForm,
    List<Object> bloquesForm,
  ) async {
    /// Como es una transaccion si algo falla, ningun cambio queda en la DB
    return transaction(
      () async {
        final Cuestionario cuestionario =
            await _upsertCuestionario(cuestionarioForm);
        await _upsertModelos(cuestionariosDeModelosForm, cuestionario);

        // La estrategia es borrar todo y volverlo a crear para que sea mas simple
        await (delete(bloques)
              ..where(
                  (bloque) => bloque.cuestionarioId.equals(cuestionario.id)))
            .go();

        /// Procesamiento de cada object del formulario de acuerdo a si es
        /// titulo, pregunta de selección o numerica y cuadricula.
        /// En los condicionales, se mira de que tipo especifico es el [element],
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
          } else if (element is PreguntaConOpcionesDeRespuestaCompanion) {
            await _procesarPregunta(element.pregunta, cuestionario, bloque,
                opcionesDeRespuesta: element.opcionesDeRespuesta);
          } else if (element
              is CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion) {
            final cuadricula = await into(cuadriculasDePreguntas)
                .insertReturning(element.cuadricula.copyWith(
              bloqueId: Value(bloque.id),
            ));

            final preguntasInsertadas = await Future.wait(element.preguntas.map(
                (e) => _procesarPregunta(e.pregunta, cuestionario, bloque,
                    opcionesDeRespuesta: [])));

            await (delete(preguntas)
                  ..where((rxor) =>
                      rxor.id.isNotIn(preguntasInsertadas.map((e) => e.id)) &
                      rxor.bloqueId.equals(bloque.id)))
                .go();
            await _insertOpcionesDeRespuesta(
              element.opcionesDeRespuesta,
              cuadricula: cuadricula,
            );
          } else if (element is PreguntaNumericaCompanion) {
            await _procesarPregunta(
              element.pregunta,
              cuestionario,
              bloque,
              criticidades: element.criticidades,
            );
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
  Future<void> _upsertModelos(
    List<CuestionarioDeModelosCompanion> cuestionariosDeModelosForm,
    Cuestionario cuestionario,
  ) async {
    /// Lista de los ids de cuestionarioDeModelos que se insertarán en la actualización

    final ids = await Future.wait<int>(
        cuestionariosDeModelosForm.map((cuestionarioDeModelosForm) async {
      /// Se le asigna [cuestionario] como cuestionario asociado
      cuestionarioDeModelosForm = cuestionarioDeModelosForm.copyWith(
          cuestionarioId: Value(cuestionario.id));
      if (cuestionarioDeModelosForm.id.present) {
        await into(cuestionarioDeModelos)
            .insertOnConflictUpdate(cuestionarioDeModelosForm);
        return cuestionarioDeModelosForm.id.value;
      } else {
        return into(cuestionarioDeModelos).insert(cuestionarioDeModelosForm);
      }
    }));

    /// En caso de que se haya deseleccionado un modelo para [cuestionario], se elimina de la bd
    await (delete(cuestionarioDeModelos)
          ..where((rxor) =>
              rxor.id.isNotIn(ids) &
              rxor.cuestionarioId.equals(cuestionario.id)))
        .go();
  }

  Future<Pregunta> _procesarPregunta(
    PreguntasCompanion preguntaCompanion,
    Cuestionario cuestionario,
    Bloque bloque, {
    List<OpcionesDeRespuestaCompanion>? opcionesDeRespuesta,
    List<CriticidadesNumericasCompanion>? criticidades,
  }) async {
    final fotosManager =
        db.fotosRepository; //TODO: eliminar la dependencia a fotosRepository
    final fotosGuiaProcesadas = await fotosManager.organizarFotos(
      preguntaCompanion.fotosGuia.valueOrDefault(const Nil()),
      Categoria.cuestionario,
      identificador: cuestionario.id.toString(),
    );

    final preguntaAInsertar = preguntaCompanion.copyWith(
      bloqueId: Value(bloque.id),
      fotosGuia: Value(fotosGuiaProcesadas),
    );

    final pregunta = await into(preguntas).insertReturning(preguntaAInsertar);
    if (opcionesDeRespuesta != null) {
      await _insertOpcionesDeRespuesta(opcionesDeRespuesta, pregunta: pregunta);
    } else if (criticidades != null) {
      await _insertCriticidades(criticidades, pregunta);
    } else {
      throw TaggedUnionError("debe enviar opcionesDeRespuesta o criticidades");
    }

    return pregunta;
  }

  Future<void> _insertOpcionesDeRespuesta(
    List<OpcionesDeRespuestaCompanion> opcionesDeRespuestaForm, {
    Pregunta? pregunta,
    CuadriculaDePreguntas? cuadricula,
  }) async {
    if (pregunta == null && cuadricula == null) {
      throw TaggedUnionError(
          "debe enviar ya sea una pregunta o una cuadricula");
    }
    final opcionesId =
        await Future.wait<int>(opcionesDeRespuestaForm.map((opcionForm) async {
      /// Asociación de cada opción con [preguntaId o cuadriculaId]
      if (pregunta != null) {
        opcionForm = opcionForm.copyWith(preguntaId: Value(pregunta.id));
      } else if (cuadricula != null) {
        opcionForm = opcionForm.copyWith(cuadriculaId: Value(cuadricula.id));
      }

      return into(opcionesDeRespuesta).insert(opcionForm);
    }));

    final Expression<bool> Function(dynamic rxor) asociada;
    if (pregunta != null) {
      asociada = (rxor) => rxor.preguntaId.equals(pregunta.id);
    } else if (cuadricula != null) {
      asociada = (rxor) => rxor.cuadriculaId.equals(cuadricula.id);
    } else {
      throw TaggedUnionError(
          "debe enviar ya sea una pregunta o una cuadricula");
    }

    /// Se eliminan de la bd las opciones de respuesta que fueron eliminadas desde el form
    await (delete(opcionesDeRespuesta)
          ..where((rxor) => rxor.id.isNotIn(opcionesId) & asociada(rxor)))
        .go();
  }

  Future<void> _insertCriticidades(
    List<CriticidadesNumericasCompanion> criticidadesForm,
    Pregunta pregunta,
  ) async {
    /// Inserción de la opciones de respuesta de la pregunta
    final criticidadesId =
        await Future.wait<int>(criticidadesForm.map((criticidadForm) async {
      criticidadForm = criticidadForm.copyWith(preguntaId: Value(pregunta.id));
      return into(criticidadesNumericas).insert(criticidadForm);
    }));

    /// Se eliminan de la bd las opciones de respuesta que fueron eliminadas desde el form
    await (delete(criticidadesNumericas)
          ..where((rxor) =>
              rxor.id.isNotIn(criticidadesId) &
              rxor.preguntaId.equals(pregunta.id)))
        .go();
  }
}
