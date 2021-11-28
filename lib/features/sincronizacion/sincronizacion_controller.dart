import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/utils/future_either_x.dart';

import 'providers.dart';

part 'sincronizacion_controller.freezed.dart';
part 'sincronizacion_state.dart';

/// Para la descarga de la bd de Gomac
///
/// La actualización de los estados se puede ver en la UI, en sincronizacion_screen.dart
class SincronizacionController extends StateNotifier<SincronizacionState> {
  final Reader read;

  late final DescargaCuestionariosStep descargaCuestionariosStep =
      DescargaCuestionariosStep(read(cuestionariosRepositoryProvider));

  late final InstalarDatabaseStep instalarDatabaseStep =
      InstalarDatabaseStep(read(driftDatabaseProvider));

  late final DescargaFotosStep descargaFotosStep =
      DescargaFotosStep(read(cuestionariosRepositoryProvider));

  late final List<SincronizacionStep> steps = [
    descargaCuestionariosStep,
    instalarDatabaseStep,
    descargaFotosStep,
  ];

  SincronizacionController(
    this.read,
  ) : super(const SincronizacionState.initial(0));

  void selectPaso(int paso) {
    state = state.copyWith(paso: paso);
  }

  /// Intento de hacer manejo de errores a la hora de descargar los datos del server
  Future<void> iniciarProceso() async {
    int step = 0;
    state = SincronizacionState.inProgress(step);
    final token = read(appRepositoryProvider).getToken();
    if (token == null) throw Exception("El usuario no está autenticado");
    final res = await descargaCuestionariosStep.run(token).flatMap((f) {
      step++;
      return instalarDatabaseStep.run(f);
    }).flatMap((_) {
      step++;
      return descargaFotosStep.run(token);
    }).map((_) {
      /// En caso de éxito, guarda el momento actual como fecha de la ultima actualización
      read(momentoDeSincronizacionProvider.notifier).sincronizar();
      return const Right(unit);
    });
    res.fold((l) => state = SincronizacionState.failure(step),
        (r) => state = SincronizacionState.success(step));
  }
}

abstract class SincronizacionStep
    extends StateNotifier<SincronizacionStepState> {
  String get titulo;

  SincronizacionStep(SincronizacionStepState state) : super(state);

  void emitWithLog(SincronizacionStepState newState) {
    if (newState.log.isNotEmpty) {
      state = newState.copyWith(log: '${state.log}\n${newState.log}');
    } else {
      state = newState.copyWith(log: state.log);
    }
  }
}

class DescargaCuestionariosStep extends SincronizacionStep {
  @override
  String get titulo => 'Descarga de cuestionarios';

  final CuestionariosRepository _repo;

  DescargaCuestionariosStep(this._repo)
      : super(const SincronizacionStepState.initial());

  Future<Either<ApiFailure, File>> run(String token) async {
    emitWithLog(
      const SincronizacionStepState.inProgress(0, 'Descargando cuestionarios'),
    );
    final res = await _repo.descargarTodosLosCuestionarios(token);

    res.fold(
      (l) => emitWithLog(
        SincronizacionStepState.failure('Error de descarga: $l'),
      ),
      (r) => emitWithLog(
        SincronizacionStepState.success('Descarga exitosa: $r'),
      ),
    );
    return res;
  }
}

class InstalarDatabaseStep extends SincronizacionStep {
  /// Usa el Json descargado para insertar los datos en la BD local
  @override
  String get titulo => 'Instalación base de datos';

  final Database _db;

  InstalarDatabaseStep(this._db)
      : super(const SincronizacionStepState.initial());

  Future<Either<ApiFailure, Unit>> run(File cuestionarioFile) async {
    // pequeña espera para asegurarse que el archivo terminó de guardarse
    await Future.delayed(const Duration(seconds: 2));

    emitWithLog(
      const SincronizacionStepState.inProgress(0, 'Instalando base de datos'),
    );

    final String jsonString;
    try {
      jsonString = await cuestionarioFile.readAsString();
    } catch (e) {
      final error = 'No se encontró el archivo descargado: ${e.toString()}';
      emitWithLog(
        SincronizacionStepState.failure(error),
      );
      return Left(ApiFailure.errorDeProgramacion(
          error)); //TODO: puede que no sea error de programacion
    }

    //parsear el json en un isolate para no volver la UI lenta
    // https://flutter.dev/docs/cookbook/networking/background-parsing
    final Map<String, dynamic> parsed;
    try {
      parsed = await compute(jsonDecode, jsonString) as Map<String, dynamic>;
      emitWithLog(
        const SincronizacionStepState.inProgress(50, 'Parsed Json'),
      );
    } catch (e) {
      final error = 'Error en el parsing del json: ${e.toString()}';
      emitWithLog(
        SincronizacionStepState.failure(error),
      );
      return Left(ApiFailure.errorDeProgramacion(
          error)); //TODO: no es error de programacion, es error del dato de la api
    }

    ///Realiza la inserción de datos
    try {
      await _db.sincronizacionDao.instalarDB(parsed);
      emitWithLog(
        const SincronizacionStepState.success('Instalación exitosa'),
      );
    } catch (e) {
      final error = 'Error en la instalacion de la BD: ${e.toString()}';
      emitWithLog(
        SincronizacionStepState.failure(error),
      );
      return Left(ApiFailure.errorDeProgramacion(error));
    }
    return const Right(unit);
  }
}

class DescargaFotosStep extends SincronizacionStep {
  //TODO: evitar la duplicacion del codigo de descarga con [DescargaCuestionariosCubit]
  @override
  String get titulo => 'Descarga de fotos';

  final CuestionariosRepository _repo;

  DescargaFotosStep(this._repo)
      : super(const SincronizacionStepState.initial());

  Future<Either<ApiFailure, Unit>> run(String token) async =>
      _repo.descargarFotos(token);
}
