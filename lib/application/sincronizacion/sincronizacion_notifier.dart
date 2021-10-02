import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

part 'sincronizacion_notifier.freezed.dart';
part 'sincronizacion_state.dart';

final sincronizacionProvider =
    StateNotifierProvider<SincronizacionNotifier, SincronizacionState>(
        (ref) => SincronizacionNotifier(
              ref.watch(userRepositoryProvider),
              ref.read,
            ));

/// Para la descarga de la bd de Gomac
///
/// La actualización de los estados se puede ver en la UI, en sincronizacion_screen.dart

class SincronizacionNotifier extends StateNotifier<SincronizacionState> {
  final nombreJson = 'server.json';

  /// Zip en el server con las fotos de los cuestionarios
  final nombreZip = 'cuestionarios.zip';

  /// Datos guardados localmente en la aplicacion
  final UserRepository _userRepository;

  final Reader read;

  /// Emite estado con fecha de la ultima descarga de datos realizada [ultimaAct]
  late final ValueNotifier<Option<DateTime>> ultimaActualizacion =
      ValueNotifier(_userRepository.getUltimaSincronizacion());

  late final DescargaCuestionariosNotifier descargaCuestionariosNotifier =
      DescargaCuestionariosNotifier(
          read(cuestionariosRepositoryProvider), nombreJson);

  late final InstalarDatabaseNotifier instalarDatabaseNotifier =
      InstalarDatabaseNotifier(nombreJson, read(moorDatabaseProvider));

  late final DescargaFotosNotifier descargaFotosNotifier =
      DescargaFotosNotifier(read(cuestionariosRepositoryProvider), nombreZip);

  late final List<SincronizacionStep> steps = [
    descargaCuestionariosNotifier,
    instalarDatabaseNotifier,
    descargaFotosNotifier
  ];

  late final List<StreamSubscription> subscriptions;

  SincronizacionNotifier(
    this._userRepository,
    this.read,
  ) : super(const SincronizacionState.initial(0)) {
    subscriptions = steps
        .mapIndexed((i, notifier) => notifier.stream.listen(
              /*(d) => print("listened data $d"),
        onError: (e) => print("listen error $e"),
        onDone: () => print("listen done"),*/

              progressOrFail(i, i < steps.length - 1 ? steps[i + 1] : null),
            ))
        .toList();
  }

  Future<void> _run() async {
    await steps.first.run();
  }

  @override
  Future<void> dispose() async {
    for (final sub in subscriptions) {
      await sub.cancel();
    }
    return super.dispose();
  }

  void selectPaso(int paso) {
    state = state.copyWith(paso: paso);
  }

  void Function(SincronizacionStepState) progressOrFail(
          int step, SincronizacionStep? next) =>
      (SincronizacionStepState state) {
        state.maybeMap(
          success: (state) {
            this.state = SincronizacionState.inProgress(step);
            if (next != null) {
              next.run();
            } else {
              /// En caso de éxito, guarda el momento actual como fecha de la ultima actualización
              _userRepository.saveUltimaSincronizacion().then((res) {
                if (res) {
                  ultimaActualizacion.value =
                      _userRepository.getUltimaSincronizacion();
                } //TODO: que pasa si falla?
              });
              this.state = SincronizacionState.success(step);
            }
          },
          failure: (state) {
            this.state = SincronizacionState.failure(step);
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

abstract class SincronizacionStep
    extends StateNotifier<SincronizacionStepState> {
  Future run();
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

class DescargaCuestionariosNotifier extends SincronizacionStep {
  @override
  String get titulo => 'Descarga de cuestionarios';

  final CuestionariosRepository _cuestionariosRepository;
  final String nombreArchivoDescargado;

  DescargaCuestionariosNotifier(
      this._cuestionariosRepository, this.nombreArchivoDescargado)
      : super(const SincronizacionStepState.initial());

  @override
  Future run() async {
    emitWithLog(
      const SincronizacionStepState.inProgress(0, 'Descargando cuestionarios'),
    );

    //inicializacion del downloader sacada del ejemplo flutter_downloader donde
    // se muestra como hacer descargas de una lista de links y agregar opcion de pausa
    // https://github.com/fluttercommunity/flutter_downloader/blob/master/example/lib/main.dart
    // En realidad esta descarga se puede hacer con un http.get sencillo desde
    // un repositorio pero el paquete flutter_downloader permite mostrar la barra de progreso
    // y como es en un isolate no bloquea la UI
    final ReceivePort port = ReceivePort();
    PortBinder.registrarPuerto(port);
    //se debe esperar a que termine de procesar todo lo que necesita este puerto
    //antes de registrar otro, si se registra otro antes, este no recibirá mas eventos.

    /// Escucha de las actualizaciones que ofrece el downloader
    late final StreamSubscription<dynamic> streamSubs;
    streamSubs = port.listen((data) {
      final task = data as Task;
      //TODO: verificar que la taskId si sea la que solicitamos
      emitWithLog(
        state.maybeMap(
          inProgress: (state) => state.copyWith(
              progress: task.progress, log: ""), //TODO: mostrar barra de carga
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
        streamSubs.cancel();
      }
    });
    final directorioDeDescarga = await directorioLocal();
    // Encola la descarga y el callback se encargará de cambiar el estado
    final taskId = await _cuestionariosRepository.descargarCuestionarios(
        directorioDeDescarga, nombreArchivoDescargado);
  }
}

class InstalarDatabaseNotifier extends SincronizacionStep {
  /// Usa el Json descargado para insertar los datos en la BD local
  @override
  String get titulo => 'Instalación base de datos';

  final String nombreArchivoDescargado;
  final MoorDatabase _db;

  InstalarDatabaseNotifier(this.nombreArchivoDescargado, this._db)
      : super(const SincronizacionStepState.initial());

  @override
  Future run() async {
    // pequeña espera para asegurarse que el archivo terminó de guardarse
    await Future.delayed(const Duration(seconds: 2));

    emitWithLog(
      const SincronizacionStepState.inProgress(0, 'Instalando base de datos'),
    );
    final directorioDeDescarga = await directorioLocal();
    final archivoDescargado =
        File(path.join(directorioDeDescarga, nombreArchivoDescargado));

    final String jsonString;
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
    final Map<String, dynamic> parsed;
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

class DescargaFotosNotifier extends SincronizacionStep {
  //TODO: evitar la duplicacion del codigo de descarga con [DescargaCuestionariosCubit]
  @override
  String get titulo => 'Descarga de fotos';

  final CuestionariosRepository _cuestionariosRepository;
  final String nombreZip;

  DescargaFotosNotifier(this._cuestionariosRepository, this.nombreZip)
      : super(const SincronizacionStepState.initial());

  @override
  Future run() async {
    final ReceivePort port = ReceivePort();
    PortBinder.registrarPuerto(port);

    emitWithLog(
      const SincronizacionStepState.inProgress(0, 'Descargando fotos'),
    );

    final directorioDeDescarga = await directorioLocal();
    await _cuestionariosRepository.descargarFotos(
        directorioDeDescarga, nombreZip);

    /// Escucha de las actualizaciones que ofrece el downloader
    late final StreamSubscription<dynamic> streamSubs;
    streamSubs = port.listen((data) {
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
  /*final directory = await getApplicationDocumentsDirectory();
  return directory.path;*/
  String externalStorageDirPath;
  if (Platform.isAndroid) {
    try {
      throw Exception("a");
      externalStorageDirPath = await AndroidPathProvider.downloadsPath;
    } catch (e) {
      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory!.path;
    }
  } else if (Platform.isIOS) {
    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;
  } else {
    throw Exception("plataforma no soportada");
  }
  return externalStorageDirPath;
}

class PortBinder {
  static void registrarPuerto(ReceivePort port) {
    final isSuccess =
        IsolateNameServer.registerPortWithName(port.sendPort, nombrePuerto);
    if (isSuccess) {
      FlutterDownloader.registerCallback(downloadCallback);
    } else {
      unbindBackgroundIsolate();
      registrarPuerto(port);
    }
  }

  static void unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(nombrePuerto);
  }

  static const nombrePuerto = "sincronizacion";

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName(nombrePuerto)!;
    send.send(Task(id: id, status: status, progress: progress));
  }
}
