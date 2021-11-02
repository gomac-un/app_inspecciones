import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/datasources/cuestionarios_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/flutter_downloader/errors.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:inspecciones/infrastructure/utils/transformador_excepciones_api.dart';
import 'package:inspecciones/utils/future_either_x.dart';

class CuestionariosRepository {
  final Reader _read;
  CuestionariosRemoteDataSource get _api =>
      _read(cuestionariosRemoteDataSourceProvider);
  FotosRemoteDataSource get _apiFotos => _read(fotosRemoteDataSourceProvider);
  Database get _db => _read(driftDatabaseProvider);
  FotosRepository get _fotosRepository => _read(fotosRepositoryProvider);

  CuestionariosRepository(this._read);

  Future<Either<ApiFailure, Unit>> subirCuestionariosPendientes() async {
    //TODO: subir cada uno, o todos a la vez para mas eficiencia
    throw UnimplementedError();
  }

  Future<void> insertarDatosDePrueba() async {
    await _db.into(_db.activos).insert(
        ActivosCompanion.insert(id: const Value(1), modelo: "kenworth"));
    await _db
        .into(_db.activos)
        .insert(ActivosCompanion.insert(id: const Value(2), modelo: "moto"));
    final sis1Id = await _db
        .into(_db.sistemas)
        .insert(SistemasCompanion.insert(nombre: "motor"));
    final sis2Id = await _db
        .into(_db.sistemas)
        .insert(SistemasCompanion.insert(nombre: "chasis"));
    await _db.into(_db.subSistemas).insert(
        SubSistemasCompanion.insert(nombre: "inyeccion", sistemaId: sis1Id));
    await _db.into(_db.subSistemas).insert(
        SubSistemasCompanion.insert(nombre: "pintura", sistemaId: sis2Id));
    await _db
        .into(_db.contratistas)
        .insert(ContratistasCompanion.insert(nombre: "gomac"));
    return guardarCuestionario(
        CuestionariosCompanion.insert(
            tipoDeInspeccion: const Value("preoperacional"),
            estado: EstadoDeCuestionario.finalizada,
            esLocal: true),
        [
          CuestionarioDeModelosCompanion.insert(
              modelo: "kenworth", periodicidad: 1, cuestionarioId: 1)
        ],
        [
          TitulosCompanion.insert(
              titulo: "titulo", descripcion: "descripcion", bloqueId: 1),
          PreguntaConOpcionesDeRespuestaCompanion(
              PreguntasCompanion.insert(
                titulo: "titulo",
                descripcion: "descripcion",
                criticidad: 1,
                bloqueId: 1,
                tipo: TipoDePregunta.unicaRespuesta,
              ),
              [
                OpcionesDeRespuestaCompanion.insert(
                    texto: "texto", criticidad: 1)
              ]),
          PreguntaNumericaCompanion(
            PreguntasCompanion.insert(
                titulo: "titulo",
                descripcion: "descripcion",
                criticidad: 1,
                bloqueId: 1,
                tipo: TipoDePregunta.numerica),
            [
              CriticidadesNumericasCompanion.insert(
                valorMinimo: -10,
                valorMaximo: 0,
                criticidad: 1,
                preguntaId: 1,
              ),
              CriticidadesNumericasCompanion.insert(
                valorMinimo: 0,
                valorMaximo: 10,
                criticidad: 1,
                preguntaId: 1,
              ),
            ],
          ),
          CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
            CuadriculasDePreguntasCompanion.insert(
                titulo: "titulo", descripcion: "descripcion", bloqueId: 1),
            [
              PreguntaConOpcionesDeRespuestaCompanion(
                  PreguntasCompanion.insert(
                    titulo: "titulo1",
                    descripcion: "descripcion1",
                    criticidad: 1,
                    bloqueId: 1,
                    tipo: TipoDePregunta.parteDeCuadriculaUnica,
                  ),
                  const []),
              PreguntaConOpcionesDeRespuestaCompanion(
                  PreguntasCompanion.insert(
                    titulo: "titulo2",
                    descripcion: "descripcion2",
                    criticidad: 1,
                    bloqueId: 1,
                    tipo: TipoDePregunta.parteDeCuadriculaUnica,
                  ),
                  const []),
            ],
            [
              OpcionesDeRespuestaCompanion.insert(
                  texto: "texto1", criticidad: 1),
              OpcionesDeRespuestaCompanion.insert(
                  texto: "texto2", criticidad: 1)
            ],
          ),
          TitulosCompanion.insert(
              titulo: "titulo2", descripcion: "descripcion2", bloqueId: 1),
          CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
            CuadriculasDePreguntasCompanion.insert(
                titulo: "titulo", descripcion: "descripcion", bloqueId: 1),
            [
              PreguntaConOpcionesDeRespuestaCompanion(
                  PreguntasCompanion.insert(
                    titulo: "titulo1",
                    descripcion: "descripcion1",
                    criticidad: 1,
                    bloqueId: 1,
                    tipo: TipoDePregunta.parteDeCuadriculaMultiple,
                  ),
                  const []),
              PreguntaConOpcionesDeRespuestaCompanion(
                  PreguntasCompanion.insert(
                    titulo: "titulo2",
                    descripcion: "descripcion2",
                    criticidad: 1,
                    bloqueId: 1,
                    tipo: TipoDePregunta.parteDeCuadriculaMultiple,
                  ),
                  const []),
            ],
            [
              OpcionesDeRespuestaCompanion.insert(
                  texto: "texto1", criticidad: 1),
              OpcionesDeRespuestaCompanion.insert(
                  texto: "texto2", criticidad: 1)
            ],
          ),
        ]);
  }

  /// Envia [cuestionario] al server.
  Future<Either<ApiFailure, Unit>> subirCuestionario(
      Cuestionario cuestionario) async {
    /// Json con info de [cuestionario] y sus respectivos bloques.
    final cuestionarioMap =
        await _db.getCuestionarioCompletoAsJson(cuestionario);

    Future<void> subirFotos() async {
      /// Usado para el nombre de la carpeta de las fotos
      final idDocumento = cuestionarioMap['id'].toString();

      final fotos = await _fotosRepository.getFotosDeDocumento(
        Categoria.cuestionario,
        identificador: idDocumento,
      );
      await _apiFotos.subirFotos(fotos, idDocumento, Categoria.cuestionario);
    }

    return apiExceptionToApiFailure(
            () => _api.crearCuestionario(cuestionarioMap))
        .nestedEvaluatedMap(
          /// Como los cuestionarios quedan en el celular, se marca como subidos
          /// para que no se envíe al server un cuestionario que ya existe.
          /// cambia [cuestionario.esLocal] = false.
          (_) => _db.marcarCuestionarioSubido(cuestionario),
        )
        .flatMap(
          (_) => apiExceptionToApiFailure(
            () => subirFotos().then((_) => unit),
          ),
        );
    //TODO: mirar como procesar los json de las respuestas intermedias
  }

  /// Descarga los cuestionarios y todo lo necesario para tratarlos:
  /// activos, sistemas, contratistas y subsistemas
  /// En caso de que ya exista el archivo, lo borra y lo descarga de nuevo

  Future<Either<ApiFailure, File>> descargarTodosLosCuestionarios(
      String token) async {
    try {
      return Right(await _api.descargarTodosLosCuestionarios(token));
    } on ErrorDeDescargaFlutterDownloader {
      return const Left(ApiFailure.errorDeComunicacionConLaApi(
          "FlutterDownloader no pudo descargar los cuestionarios"));
    } catch (e) {
      return Left(ApiFailure.errorDeProgramacion(e.toString()));
    }
  }

  /// Descarga todas las fotos de todos los cuestionarios
  Future<Either<ApiFailure, Unit>> descargarFotos(String token) async {
    try {
      await _api.descargarTodasLasFotos(token);
      return const Right(unit);
    } on ErrorDeDescargaFlutterDownloader {
      return const Left(ApiFailure.errorDeComunicacionConLaApi(
          "FlutterDownloader no pudo descargar las fotos"));
    } catch (e) {
      return Left(ApiFailure.errorDeProgramacion(e.toString()));
    }
  }

  Stream<List<Cuestionario>> getCuestionariosLocales() =>
      _db.cargaDeCuestionarioDao.watchCuestionarios();

  Future eliminarCuestionario(Cuestionario cuestionario) =>
      _db.cargaDeCuestionarioDao.eliminarCuestionario(cuestionario);

  Future<CuestionarioConContratistaYModelos> getModelosYContratista(
          int cuestionarioId) =>
      _db.cargaDeCuestionarioDao.getModelosYContratista(cuestionarioId);

  Future<List<IBloqueOrdenable>> cargarCuestionario(int cuestionarioId) =>
      _db.cargaDeCuestionarioDao.cargarCuestionario(cuestionarioId);

  Future<List<Cuestionario>> getCuestionarios(
          String tipoDeInspeccion, List<String> modelos) =>
      _db.cargaDeCuestionarioDao.getCuestionarios(tipoDeInspeccion, modelos);

  Future<List<String>> getTiposDeInspecciones() =>
      _db.cargaDeCuestionarioDao.getTiposDeInspecciones();

  Future<List<String>> getModelos() => _db.cargaDeCuestionarioDao.getModelos();

  Future<List<Contratista>> getContratistas() =>
      _db.cargaDeCuestionarioDao.getContratistas();

  Future<List<Sistema>> getSistemas() =>
      _db.cargaDeCuestionarioDao.getSistemas();
  Future<Sistema> getSistemaPorId(int sistemaId) =>
      _db.cargaDeCuestionarioDao.getSistemaPorId(sistemaId);
  Future<SubSistema> getSubSistemaPorId(int subSistemaId) =>
      _db.cargaDeCuestionarioDao.getSubSistemaPorId(subSistemaId);
  Future<List<SubSistema>> getSubSistemas(Sistema sistema) =>
      _db.cargaDeCuestionarioDao.getSubSistemas(sistema);

  Future<void> guardarCuestionario(
    CuestionariosCompanion cuestionario,
    List<CuestionarioDeModelosCompanion> cuestionariosDeModelos,
    List<Object> bloquesForm,
  ) =>
      _db.guardadoDeCuestionarioDao.guardarCuestionario(
        cuestionario,
        cuestionariosDeModelos,
        bloquesForm,
      );
}
