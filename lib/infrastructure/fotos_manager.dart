import 'dart:async';
import 'dart:io';

import 'package:kt_dart/kt.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FotosManager {
  static Future<Iterable<String>> organizarFotos(
    KtList<String> fotos, {
    String tipoDocumento,
    String idDocumento,
  }

      //fotosInspecciones
      ) async {
    final appDir = await getApplicationDocumentsDirectory();
    return Future.wait(fotos.iter.map((pathFoto) async {
      final dir = path.join(appDir.path, tipoDocumento, idDocumento);
      if (path.isWithin(dir, pathFoto)) {
        // la imagen ya esta en la carpeta de datos
        return pathFoto;
      } else {
        //mover la foto a la carpeta de datos
        final fileName = path.basename(pathFoto);
        final newPath = path.join(dir, fileName);
        await File(newPath).create(recursive: true);
        final savedImage = await File(pathFoto).copy(newPath);
        return savedImage.path;
      }
    }));
  }

  static Future<Iterable<File>> getFotosDeDocumento(
      {String idDocumento, String tipoDocumento}) async {
    final appDir = await getApplicationDocumentsDirectory();

    return Directory(path.join(appDir.path, tipoDocumento, idDocumento))
        .listSync()
        .whereType<File>();
  }
}
