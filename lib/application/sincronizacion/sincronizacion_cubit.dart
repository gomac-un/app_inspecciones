import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/infrastructure/datasources/local_preferences_datasource.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'sincronizacion_state.dart';
part 'sincronizacion_cubit.freezed.dart';

@injectable
class SincronizacionCubit extends Cubit<SincronizacionState> {
  static const nombreArchivo = 'server.json';
  static const nombrePuerto = 'downloader_send_port';
  final _port = ReceivePort();
  final debug = true;
  final Database _db;
  final ILocalPreferencesDataSource _localPreferences;

  SincronizacionCubit(this._db, this._localPreferences)
      : super(SincronizacionState());
  Future cargarUltimaActualizacion() async {
    final ultimaAct = _localPreferences.getUltimaActualizacion();
    emit(state.copyWith(
      status: SincronizacionStatus.cargado,
      ultimaActualizacion: ultimaAct,
    ));
  }

  //TODO: manejo de errores
  Future descargarServer() async {
    //inicializacion del downloader sacada del ejemplo flutter_downloader donde
    // se muestra como hacer descargas de una lista de links
    // https://github.com/fluttercommunity/flutter_downloader/blob/master/example/lib/main.dart

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    final dir = await _localPath;
    //TODO: url y credenciales dinamicas
    FlutterDownloader.enqueue(
        url: "http://10.0.2.2:8000/inspecciones/api/v1/server/",
        savedDir: dir,
        fileName: nombreArchivo,
        showNotification: false);
    // Escucha de las actualizaciones que ofrece el downloader
    await for (final dynamic data in _port) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      final task = data as Task;

      emit(state.copyWith(
          status: SincronizacionStatus.descargandoServer, task: task));
      if ([
        DownloadTaskStatus.undefined,
        DownloadTaskStatus.enqueued,
        DownloadTaskStatus.running,
      ].contains(task.status)) {}

      if (DownloadTaskStatus.complete == task.status) {
        instalarBD();
      }

      if ([
        DownloadTaskStatus.failed,
        DownloadTaskStatus.canceled,
        DownloadTaskStatus.paused,
      ].contains(task.status)) {
        throw Exception("error de descarga");
      }
    }
  }

  Future instalarBD() async {
    emit(state.copyWith(status: SincronizacionStatus.instalandoDB));
    final dir = await _localPath;
    final archivoDescargado = File(path.join(dir, nombreArchivo));
    final jsonString = await archivoDescargado.readAsString();
    final parsed =
        await compute(jsonDecode, jsonString) as Map<String, dynamic>;
    //final parsed = jsonDecode(jsonString).cast<Map<String, dynamic>>();
    print("parsed json");
    await _db.instalarBD(parsed);
    await _localPreferences.saveUltimaActualizacion();
    emit(state.copyWith(status: SincronizacionStatus.exito));
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
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');

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
