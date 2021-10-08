import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'errors.dart';
import 'task_state.dart';

Future<File> flutterDownloaderAsFuture(Uri uri, String filename,
    {Map<String, String> headers = const {}}) async {
  final dir = await directorioDeDescarga();
  //borrado del archivo antiguo si ya existe
  final file = File(path.join(dir, filename));
  if (await file.exists()) {
    await file.delete();
  }

  //inicializacion del downloader sacada del ejemplo flutter_downloader donde
  // se muestra como hacer descargas de una lista de links y agregar opcion de pausa
  // https://github.com/fluttercommunity/flutter_downloader/blob/master/example/lib/main.dart
  // En realidad esta descarga se puede hacer con un http.get sencillo desde
  // un repositorio pero el paquete flutter_downloader permite mostrar la barra de progreso
  // y como es en un isolate no bloquea la UI
  //TODO exponer una api tipo stream que reporte el porcentaje de avance
  final ReceivePort port = ReceivePort();
  PortBinder.registrarPuerto(port);
  //se debe esperar a que termine de procesar todo lo que necesita este puerto
  //antes de registrar otro, si se registra otro antes, este no recibirá mas eventos.
  final completer = Completer<File>();

  /// Escucha de las actualizaciones que ofrece el downloader
  late final StreamSubscription<dynamic> streamSubs;
  late final String? taskId;
  streamSubs = port.listen((data) {
    final task = data as TaskState;
    if (task.id != taskId) {
      developer.log(
          "TaskId no esperada, verifique que no se realicen llamadas concurrentes a FlutterDownloader");
      return;
    }

    if (task.status == DownloadTaskStatus.complete) {
      completer.complete(file);
      streamSubs.cancel();
    }
    if ([
      DownloadTaskStatus.failed,
      DownloadTaskStatus.canceled,
      DownloadTaskStatus.paused,
    ].contains(task.status)) {
      completer.completeError(ErrorDeDescargaFlutterDownloader(task));
      streamSubs.cancel();
    }
  });
  // Encola la descarga y el callback se encargará de cambiar el estado
  taskId = await FlutterDownloader.enqueue(
    url: uri.toString(),
    headers: headers,
    savedDir: dir,
    fileName: filename,
    showNotification: false,
  );
  return completer.future;
}

class PortBinder {
  static const nombrePuerto = "sincronizacion";
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

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName(nombrePuerto)!;
    send.send(TaskState(id: id, status: status, progress: progress));
  }
}

Future<String> directorioDeDescarga() async {
  /*final directory = await getApplicationDocumentsDirectory();
  return directory.path;*/
  String externalStorageDirPath;
  if (Platform.isAndroid) {
    try {
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
