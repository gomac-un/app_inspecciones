import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'sincronizacion_state.dart';
part 'sincronizacion_cubit.freezed.dart';

@injectable
class SincronizacionCubit extends Cubit<SincronizacionState> {
  static const nombreJson = 'server.json';
  static const nombreZip = 'cuestionarios.zip';
  static const nombrePuerto = 'downloader_send_port';
  final _port = ReceivePort();
  Stream<dynamic> _portStream;
  final debug = true;
  final Database _db;
  final ILocalPreferencesDataSource _localPreferences;
  final InspeccionesRepository _inspeccionesRepository;

  SincronizacionCubit(
      this._db, this._inspeccionesRepository, this._localPreferences)
      : super(SincronizacionState()) {
    _portStream = _port.asBroadcastStream();
  }

  Future cargarUltimaActualizacion() async {
    final ultimaAct = _localPreferences.getUltimaActualizacion();
    emit(state.copyWith(
      cargado: true,
      info: 'Ultima sincronización: $ultimaAct',
    ));
  }

  //TODO: manejo de errores
  Future descargarServer() async {
    //inicializacion del downloader sacada del ejemplo flutter_downloader donde
    // se muestra como hacer descargas de una lista de links y agregar opcion de pausa
    // https://github.com/fluttercommunity/flutter_downloader/blob/master/example/lib/main.dart
    // En realidad esta descarga se puede hacer con un http.get sencillo desde
    // un repositorio pero el paquete flutter_downloader permite mostrar la barra de progreso
    // y como es en un isolate no bloquea la UI
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    emit(state.copyWith(info: '${state.info}\nDescargando cuestionarios'));

    final dir = await _localPath;
    await _inspeccionesRepository.descargarCuestionarios(dir, nombreJson);

    // Escucha de las actualizaciones que ofrece el downloader
    StreamSubscription<dynamic> streamSubs1;
    streamSubs1 = _portStream.listen((data) {
      final task = data as Task;
      emit(state.copyWith(task: task));
      /*
      if ([
        DownloadTaskStatus.undefined,
        DownloadTaskStatus.enqueued,
        DownloadTaskStatus.running,
      ].contains(task.status)) {}*/

      if (DownloadTaskStatus.complete == task.status) {
        emit(state.copyWith(info: '${state.info}\nDescarga exitosa'));
        instalarBD();
        streamSubs1.cancel();
      }

      if ([
        DownloadTaskStatus.failed,
        DownloadTaskStatus.canceled,
        DownloadTaskStatus.paused,
      ].contains(task.status)) {
        emit(state.copyWith(info: '${state.info}\nError de descarga'));
      }
    });
  }

  Future instalarBD() async {
    emit(state.copyWith(info: '${state.info}\nInstalando base de datos'));
    final dir = await _localPath;
    final archivoDescargado = File(path.join(dir, nombreJson));
    final jsonString = await archivoDescargado.readAsString();
    //parsear el json en un isolate para no volver la UI lenta
    // https://flutter.dev/docs/cookbook/networking/background-parsing
    final parsed =
        await compute(jsonDecode, jsonString) as Map<String, dynamic>;

    emit(state.copyWith(info: '${state.info}\nParsed Json'));

    await _db.instalarBD(parsed);

    emit(state.copyWith(info: '${state.info}\nInstalacion exitosa'));
    descargarFotos();
  }

  Future descargarFotos() async {
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    emit(state.copyWith(info: '${state.info}\nDescargando fotos'));
    final dir = await _localPath;
    await _inspeccionesRepository.descargarFotos(dir, nombreZip);
    // Escucha de las actualizaciones que ofrece el downloader
    StreamSubscription<dynamic> streamSubs2;
    streamSubs2 = _portStream.listen((data) {
      final task = data as Task;
      emit(state.copyWith(task: task));

      if (DownloadTaskStatus.complete == task.status) {
        emit(state.copyWith(info: '${state.info}\nDescarga exitosa'));
        descomprimirZip();
        streamSubs2.cancel();
      }

      if ([
        DownloadTaskStatus.failed,
        DownloadTaskStatus.canceled,
        DownloadTaskStatus.paused,
      ].contains(task.status)) {
        emit(state.copyWith(
            info: '${state.info}\nError de descarga de las fotos'));
      }
    });
  }

  Future descomprimirZip() async {
    final dir = await _localPath;
    final zipFile = File(path.join(dir, nombreZip));
    final destinationDir = Directory(path.join(dir, 'cuestionarios'));
    try {
      await ZipFile.extractToDirectory(
          zipFile: zipFile, destinationDir: destinationDir);
      emit(state.copyWith(info: '${state.info}\nFotos descomprimidas'));
      emit(state.copyWith(info: '${state.info}\nSincronización finalizada'));
    } catch (e) {
      emit(state.copyWith(info: '${state.info}\nError: $e'));
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
