import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/error/exceptions.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'sincronizacion_state.dart';
part 'sincronizacion_cubit.freezed.dart';

/// Módulo injectable para la descarga de la bd de Gomac
///
/// La actualización de los estados se puede ver en la UI, en sincronizacion_screen.dart
@injectable
class SincronizacionCubit extends Cubit<SincronizacionState> {
  static const nombreJson = 'server.json';

  /// Zip en el server con las fotos de los cuestionarios
  static const nombreZip = 'cuestionarios.zip';
  static const nombrePuerto = 'downloader_send_port';
  final _port = ReceivePort();
  Stream<dynamic> _portStream;
  final debug = true;
  final Database _db;

  /// Datos guardados localmente en la aplicacion
  final ILocalPreferencesDataSource _localPreferences;

  /// Consume la Api para inspecciones y cuestionarios
  final InspeccionesRepository _inspeccionesRepository;

  SincronizacionCubit(
      this._db, this._inspeccionesRepository, this._localPreferences)
      : super(SincronizacionState()) {
    _portStream = _port.asBroadcastStream();
  }

  /// Emite estado con fecha de la ultima descarga de datos realizada [ultimaAct]
  Future cargarUltimaActualizacion() async {
    final ultimaAct = _localPreferences.getUltimaActualizacion();
    emit(state.copyWith(
      cargado: true,
      paso: 0,
      info: {
        0: 'Ultima sincronización: ${ultimaAct ?? 'ninguna'}',
        1: '',
        2: '',
        3: '',
      },
    ));
  }

  /// Intento de hacer manejo de errores a la hora de descargar los datos del server
  Future<Either<ApiFailure, Unit>> descargarServer() async {
    try {
      await descargarServerConErrores();
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

  //TODO: manejo de errores
  Future descargarServerConErrores() async {
    //inicializacion del downloader sacada del ejemplo flutter_downloader donde
    // se muestra como hacer descargas de una lista de links y agregar opcion de pausa
    // https://github.com/fluttercommunity/flutter_downloader/blob/master/example/lib/main.dart
    // En realidad esta descarga se puede hacer con un http.get sencillo desde
    // un repositorio pero el paquete flutter_downloader permite mostrar la barra de progreso
    // y como es en un isolate no bloquea la UI
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
    emit(
      state.copyWith(
        paso: 1,
        info: {0: state.info[0], 1: 'Descargando cuestionarios', 2: '', 3: ''},
      ),
    );

    final dir = await _localPath;
    Future<bool> _hayInternet() async => DataConnectionChecker().hasConnection;

    final hayInternet = await _hayInternet();

    if (!hayInternet) {
      throw InternetException();
    }

    /// Descarga de los datos del servidor (Sin fotos)
    ///
    /// Hace la petición al servidor, en caso de exito instala la bd localmente, en caso de error lanza el
    /// mensaje 'Error de descarga'
    await _inspeccionesRepository.descargarCuestionarios(dir, nombreJson);

    /// Escucha de las actualizaciones que ofrece el downloader
    StreamSubscription<dynamic> streamSubs1;
    streamSubs1 = _portStream.listen((data) {
      final task = data as Task;
      emit(state.copyWith(task: task));
      if (DownloadTaskStatus.complete == task.status) {
        emit(state.copyWith(
          info: {
            0: state.info[0],
            1: '${state.info[1]}\nDescarga exitosa',
            2: '',
            3: ''
          },
        ));
        instalarBD();
        streamSubs1.cancel();
      }
      if ([
        DownloadTaskStatus.failed,
        DownloadTaskStatus.canceled,
        DownloadTaskStatus.paused,
      ].contains(task.status)) {
        emit(state.copyWith(info: {
          0: state.info[0],
          1: '${state.info[1]}\nError de descarga',
          2: '',
          3: ''
        }));
      }
    });
  }

  /// Usa el Json descargado para insertar los datos en la BD local
  Future instalarBD() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(paso: 2, info: {
      0: state.info[0],
      1: state.info[1],
      2: 'Instalando base de datos',
      3: ''
    }));
    final dir = await _localPath;
    final archivoDescargado = File(path.join(dir, nombreJson));
    final jsonString = await archivoDescargado.readAsString();
    //parsear el json en un isolate para no volver la UI lenta
    // https://flutter.dev/docs/cookbook/networking/background-parsing
    final parsed =
        await compute(jsonDecode, jsonString) as Map<String, dynamic>;

    emit(state.copyWith(info: {
      0: state.info[0],
      1: state.info[1],
      2: '${state.info[2]}\nParsed Json',
      3: ''
    }));

    ///Realiza la inserción de datos
    await _db.instalarBD(parsed);

    emit(state.copyWith(info: {
      0: state.info[0],
      1: state.info[1],
      2: '${state.info[2]}\nInstalación exitosa',
      3: ''
    }));
    descargarFotos();
  }

  /// Descarga de [nombreZip] y lo descomprime
  Future descargarFotos() async {
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(paso: 3, info: {
      0: state.info[0],
      1: state.info[1],
      2: state.info[2],
      3: 'Descargando fotos'
    }));
    final dir = await _localPath;
    await _inspeccionesRepository.descargarFotos(dir, nombreZip);
    // Escucha de las actualizaciones que ofrece el downloader
    StreamSubscription<dynamic> streamSubs2;
    streamSubs2 = _portStream.listen((data) {
      final task = data as Task;
      emit(state.copyWith(task: task));

      if (DownloadTaskStatus.complete == task.status) {
        emit(state.copyWith(info: {
          0: state.info[0],
          1: state.info[1],
          2: state.info[2],
          3: '${state.info[3]}\nDescarga exitosa'
        }));
        descomprimirZip();
        streamSubs2.cancel();
      }

      if ([
        DownloadTaskStatus.failed,
        DownloadTaskStatus.canceled,
        DownloadTaskStatus.paused,
      ].contains(task.status)) {
        emit(state.copyWith(info: {
          0: state.info[0],
          1: state.info[1],
          2: state.info[2],
          3: '${state.info[3]}\nError de descarga de las fotos'
        }));
      }
    });
  }

  /// Descomprime el zip

  Future descomprimirZip() async {
    final dir = await _localPath;
    final zipFile = File(path.join(dir, nombreZip));
    final destinationDir = Directory(path.join(dir, 'cuestionarios'));
    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile, destinationDir: destinationDir);
      emit(state.copyWith(info: {
        0: state.info[0],
        1: state.info[1],
        2: state.info[2],
        3: '${state.info[3]}\nFotos descomprimidas'
      }));
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(paso: 4, info: {
        0: state.info[0],
        1: state.info[1],
        2: state.info[2],
        3: state.info[3],
        4: 'Sincronización finalizada'
      }));

      /// En caso de éxito, guarda el momento actual como fecha de la ultima actualización
      await _localPreferences.saveUltimaActualizacion();
    } catch (e) {
      emit(state.copyWith(info: {
        0: 'Última sincronización ${_localPreferences.getUltimaActualizacion().toString()}',
        1: state.info[1],
        2: state.info[2],
        3: '${state.info}\nError: $e'
      }));
    }
  }

  void _bindBackgroundIsolate() {
    final isSuccess =
        IsolateNameServer.registerPortWithName(_port.sendPort, nombrePuerto);
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(nombrePuerto);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName(nombrePuerto);
    send.send(Task(id: id, status: status, progress: progress));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
}

@freezed
abstract class Task with _$Task {
  factory Task({
    String id,
    DownloadTaskStatus status,
    int progress,
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
    return null;
  }
}
