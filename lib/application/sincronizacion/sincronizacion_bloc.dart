import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'sincronizacion_event.dart';
part 'sincronizacion_state.dart';
part 'sincronizacion_bloc.freezed.dart';

class SincronizacionBloc
    extends Bloc<SincronizacionEvent, SincronizacionState> {
  static const nombrePuerto = 'downloader_send_port';
  final _port = ReceivePort();
  final debug = true;

  SincronizacionBloc() : super(const Cargando());
  //TODO: manejo de errores
  @override
  Stream<SincronizacionState> mapEventToState(
    SincronizacionEvent event,
  ) async* {
    yield* event.when(inicializar: () async* {
      //TODO: get last update from localstorage
      yield Cargado(DateTime.now());
    }, descargarServer: () async* {
      //TODO: start downloading, that proces must emit _DescargandoServer states with updated progress

      await FlutterDownloader.initialize(debug: debug);

      _bindBackgroundIsolate();

      FlutterDownloader.registerCallback(downloadCallback);

      final appDir = await getApplicationDocumentsDirectory();

      FlutterDownloader.enqueue(
          url: "http://10.0.2.2:8000/inspecciones/api/v1/server/",
          savedDir: appDir.path,
          fileName: 'server.json',
          showNotification: true,
          openFileFromNotification: true);

      await for (final dynamic data in _port) {
        if (debug) {
          print('UI Isolate Callback: $data');
        }
        print((data as Task).progress);
        yield DescargandoServer(DateTime.now(), data as Task);
      }
    }, instalarBD: () {
      //TODO: parsear el json descargado y realizar el borrado e insercion de cada tabla, todo dentro de una transaccion
    });
  }

  void descargarBD() {
    add(const SincronizacionEvent.descargarServer());
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
}

@freezed
abstract class Task with _$Task {
  factory Task({
    String id,
    DownloadTaskStatus status,
    int progress,
  }) = _Task;
}
