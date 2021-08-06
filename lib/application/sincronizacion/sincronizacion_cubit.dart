import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:inspecciones/injection.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';

part 'sincronizacion_state.dart';
part 'sincronizacion_cubit.freezed.dart';

abstract class SincronizacionStep extends Cubit<SincronizacionStepState> {
  Future run();
  String get titulo;

  SincronizacionStep(SincronizacionStepState state) : super(state);

  void emitWithLog(SincronizacionStepState newState) =>
      emit(newState.copyWith(log: '${state.log}\n${newState.log}'));
}

class DescargaCuestionariosCubit extends SincronizacionStep {
  @override
  String get titulo => 'Descarga de cuestionarios';

  final InspeccionesRepository _inspeccionesRepository;
  final String nombreArchivoDescargado;

  DescargaCuestionariosCubit(
      this._inspeccionesRepository, this.nombreArchivoDescargado)
      : super(const SincronizacionStepState.initial());

  @override
  Future run() async {
    //inicializacion del downloader sacada del ejemplo flutter_downloader donde
    // se muestra como hacer descargas de una lista de links y agregar opcion de pausa
    // https://github.com/fluttercommunity/flutter_downloader/blob/master/example/lib/main.dart
    // En realidad esta descarga se puede hacer con un http.get sencillo desde
    // un repositorio pero el paquete flutter_downloader permite mostrar la barra de progreso
    // y como es en un isolate no bloquea la UI
    final ReceivePort port = ReceivePort();
    final Stream<dynamic> portStream = port.asBroadcastStream();

    final registradorDePuerto = RegistradorDePuerto(
      port: port,
      nombrePuerto: "descarga_cuestionarios",
    ); //TODO: mirar si realmente es necesario usar el registerPortWithName

    FlutterDownloader.registerCallback(registradorDePuerto.downloadCallback);

    emitWithLog(
      const SincronizacionStepState.inProgress(0, 'Descargando cuestionarios'),
    );

    /// Descarga de los datos del servidor (Sin fotos)
    ///
    /// Hace la petición al servidor, en caso de exito instala la bd localmente, en caso de error lanza el
    /// mensaje 'Error de descarga'
    final directorioDeDescarga = await directorioLocal();
    await _inspeccionesRepository.descargarCuestionarios(
        directorioDeDescarga, nombreArchivoDescargado);

    /// Escucha de las actualizaciones que ofrece el downloader
    late final StreamSubscription<dynamic> streamSubs;
    streamSubs = portStream.listen((data) {
      final task = data as Task;

      emitWithLog(
        state.maybeMap(
          inProgress: (state) => state.copyWith(progress: task.progress),
          orElse: () =>
              const SincronizacionStepState.failure("Estado inesperado"),
        ),
      );

      if (task.status == DownloadTaskStatus.complete) {
        emitWithLog(
          const SincronizacionStepState.success('Descarga exitosa'),
        );

        streamSubs.cancel();
      }
      if ([
        DownloadTaskStatus.failed,
        DownloadTaskStatus.canceled,
        DownloadTaskStatus.paused,
      ].contains(task.status)) {
        emitWithLog(
          const SincronizacionStepState.failure('Error de descarga'),
        );
      }
    });
  }
}

class InstalarDatabaseCubit extends SincronizacionStep {
  /// Usa el Json descargado para insertar los datos en la BD local
  @override
  String get titulo => 'Instalación base de datos';

  final String nombreArchivoDescargado;
  final Database _db;

  InstalarDatabaseCubit(this.nombreArchivoDescargado, this._db)
      : super(const SincronizacionStepState.initial());

  @override
  Future run() async {
    await Future.delayed(const Duration(seconds: 2));
    emitWithLog(
      const SincronizacionStepState.inProgress(0, 'Instalando base de datos'),
    );
    final directorioDeDescarga = await directorioLocal();
    final archivoDescargado =
        File(path.join(directorioDeDescarga, nombreArchivoDescargado));

    late final String jsonString;
    try {
      jsonString = await archivoDescargado.readAsString();
    } catch (e) {
      emitWithLog(
        SincronizacionStepState.failure(
            'No se encontró el archivo descargado: ${e.toString()}'),
      );
      return;
    }

    //parsear el json en un isolate para no volver la UI lenta
    // https://flutter.dev/docs/cookbook/networking/background-parsing
    late final Map<String, dynamic> parsed;
    try {
      parsed = await compute(jsonDecode, jsonString) as Map<String, dynamic>;
      emitWithLog(
        const SincronizacionStepState.inProgress(50, 'Parsed Json'),
      );
    } catch (e) {
      emitWithLog(
        SincronizacionStepState.failure(
            'Error en el parsing del json: ${e.toString()}'),
      );
      return;
    }

    ///Realiza la inserción de datos
    try {
      await _db.instalarBD(parsed);
      emitWithLog(
        const SincronizacionStepState.success('Instalación exitosa'),
      );
    } catch (e) {
      emitWithLog(
        SincronizacionStepState.failure(
            'Error en la instalacion de la BD: ${e.toString()}'),
      );
    }
  }
}

class DescargaFotosCubit extends SincronizacionStep {
  //TODO: evitar la duplicacion de codigo con [DescargaCuestionariosCubit]
  @override
  String get titulo => 'Descarga de fotos';

  final InspeccionesRepository _inspeccionesRepository;
  final String nombreZip;

  DescargaFotosCubit(this._inspeccionesRepository, this.nombreZip)
      : super(const SincronizacionStepState.initial());

  @override
  Future run() async {
    final ReceivePort port = ReceivePort();
    final Stream<dynamic> portStream = port.asBroadcastStream();

    final registradorDePuerto = RegistradorDePuerto(
      port: port,
      nombrePuerto: "descarga_fotos",
    ); //TODO: mirar si realmente es necesario usar el registerPortWithName

    FlutterDownloader.registerCallback(registradorDePuerto.downloadCallback);

    emitWithLog(
      const SincronizacionStepState.inProgress(0, 'Descargando fotos'),
    );

    final directorioDeDescarga = await directorioLocal();
    await _inspeccionesRepository.descargarFotos(
        directorioDeDescarga, nombreZip);

    /// Escucha de las actualizaciones que ofrece el downloader
    late final StreamSubscription<dynamic> streamSubs;
    streamSubs = portStream.listen((data) {
      final task = data as Task;

      emitWithLog(
        state.maybeMap(
          inProgress: (state) => state.copyWith(progress: task.progress),
          orElse: () =>
              const SincronizacionStepState.failure("Estado inesperado"),
        ),
      );

      if (task.status == DownloadTaskStatus.complete) {
        emitWithLog(
          const SincronizacionStepState.success('Descarga exitosa'),
        );
        streamSubs.cancel();
        descomprimirZip();
      }
      if ([
        DownloadTaskStatus.failed,
        DownloadTaskStatus.canceled,
        DownloadTaskStatus.paused,
      ].contains(task.status)) {
        emitWithLog(
          const SincronizacionStepState.failure('Error de descarga'),
        );
        streamSubs.cancel();
      }
    });
  }

  Future descomprimirZip() async {
    final directorioDeDescarga = await directorioLocal();
    final zipFile = File(path.join(directorioDeDescarga, nombreZip));

    final destinationDir =
        Directory(path.join(directorioDeDescarga, 'cuestionarios'));
    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile, destinationDir: destinationDir);
      emitWithLog(
        const SincronizacionStepState.success('Fotos descomprimidas'),
      );
    } catch (e) {
      emitWithLog(
        const SincronizacionStepState.failure(
            'Error descomprimiendo las fotos'),
      );
      return;
    }
  }
}

/// Módulo injectable para la descarga de la bd de Gomac
///
/// La actualización de los estados se puede ver en la UI, en sincronizacion_screen.dart
@injectable
class SincronizacionCubit extends Cubit<SincronizacionState> {
  final nombreJson = 'server.json';

  /// Zip en el server con las fotos de los cuestionarios
  final nombreZip = 'cuestionarios.zip';

  /// Datos guardados localmente en la aplicacion
  final ILocalPreferencesDataSource _localPreferences;

  /// Emite estado con fecha de la ultima descarga de datos realizada [ultimaAct]
  late final ValueNotifier<DateTime> ultimaActualizacion =
      ValueNotifier(_localPreferences.getUltimaActualizacion());

  late final DescargaCuestionariosCubit descargaCuestionariosCubit =
      DescargaCuestionariosCubit(getIt<InspeccionesRepository>(), nombreJson);

  late final InstalarDatabaseCubit instalarDatabaseCubit =
      InstalarDatabaseCubit(nombreJson, getIt<Database>());

  late final DescargaFotosCubit descargaFotosCubit =
      DescargaFotosCubit(getIt<InspeccionesRepository>(), nombreZip);

  late final List<SincronizacionStep> steps = [
    descargaCuestionariosCubit,
    instalarDatabaseCubit,
    descargaFotosCubit
  ];

  late final List<StreamSubscription> subscriptions =
      steps.asMap().entries.map((entry) {
    final i = entry.key;
    final cubit = entry.value;
    return cubit.stream
        .listen(progressOrFail(i, steps[i + 1], isLast: i == steps.length - 1));
  }).toList();

  SincronizacionCubit(
    this._localPreferences,
  ) : super(const SincronizacionState.initial(0));

  Future<void> _run() async {
    await steps.first.run();
  }

  @override
  Future<void> close() {
    for (final sub in subscriptions) {
      sub.cancel();
    }
    return super.close();
  }

  @override
  void onChange(Change<SincronizacionState> change) {
    super.onChange(change);
    if (change.nextState is SincronizacionSuccess) {
      /// En caso de éxito, guarda el momento actual como fecha de la ultima actualización
      _localPreferences.saveUltimaActualizacion().then((res) {
        if (res) {
          ultimaActualizacion.value =
              _localPreferences.getUltimaActualizacion();
        } //TODO: que pasa si falla?
      });
    }
  }

  void selectPaso(int paso) {
    emit(state.copyWith(paso: paso));
  }

  void Function(SincronizacionStepState) progressOrFail(
          int step, SincronizacionStep next,
          {bool isLast = false}) =>
      (SincronizacionStepState state) {
        state.maybeMap(
          success: (state) {
            emit(SincronizacionState.inProgress(step));
            if (!isLast) next.run();
            if (isLast) emit(SincronizacionState.success(step));
          },
          failure: (state) {
            emit(SincronizacionState.failure(step));
          },
          orElse: () {},
        );
      };

  /// Intento de hacer manejo de errores a la hora de descargar los datos del server
  Future<Either<ApiFailure, Unit>> descargarServer() async {
    try {
      final hayInternet = await InternetConnectionChecker().hasConnection;
      if (!hayInternet) {
        throw InternetException();
      }
      await _run();
      return right(unit);
    } on TimeoutException {
      return const Left(ApiFailure.noHayConexionAlServidor());
    } on CredencialesException {
      return const Left(ApiFailure.credencialesException());
    } on ServerException catch (e) {
      return Left(ApiFailure.serverError(jsonEncode(e.respuesta)));
    } on InternetException {
      return const Left(ApiFailure.noHayInternet());
    } on PageNotFoundException {
      return const Left(ApiFailure.pageNotFound());
    } catch (e) {
      return Left(ApiFailure.serverError(e.toString()));
    }
  }
}

@freezed
class Task with _$Task {
  factory Task({
    required String id,
    required DownloadTaskStatus status,
    required int progress,
  }) = _Task;
}

/// Estados de las tareas (o pasos) de la sincronización
extension DownloadTaskStatusX on DownloadTaskStatus {
  String toText() {
    if (this == DownloadTaskStatus.undefined) return "undefined";
    if (this == DownloadTaskStatus.enqueued) return "enqueued";
    if (this == DownloadTaskStatus.running) return "running";
    if (this == DownloadTaskStatus.complete) return "complete";
    if (this == DownloadTaskStatus.failed) return "failed";
    if (this == DownloadTaskStatus.canceled) return "canceled";
    if (this == DownloadTaskStatus.paused) return "paused";
    throw Exception("estado del downloader inesperado");
  }
}

Future<String> directorioLocal() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

class RegistradorDePuerto {
  final String nombrePuerto;
  final ReceivePort port;

  RegistradorDePuerto({required this.port, required this.nombrePuerto}) {
    bindBackgroundIsolate();
  }

  void bindBackgroundIsolate() {
    final isSuccess =
        IsolateNameServer.registerPortWithName(port.sendPort, nombrePuerto);
    if (!isSuccess) {
      unbindBackgroundIsolate();
      bindBackgroundIsolate();
    }
  }

  void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(nombrePuerto);
  }

  void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName(nombrePuerto)!;
    send.send(Task(id: id, status: status, progress: progress));
  }
}
