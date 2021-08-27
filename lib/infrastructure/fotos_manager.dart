import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:inspecciones/injection.dart';
import 'package:kt_dart/kt.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Clase encargada de manejar las fotos de cuestionarios e inspecciones
class FotosManager {
  static Future<Iterable<String>> organizarFotos(
    KtList<String> fotos, {
    String tipoDocumento,
    String idDocumento,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    return Future.wait(fotos.iter.map((pathFoto) async {
      final dir = path.join(appDir.path, tipoDocumento, idDocumento);
      if (path.isWithin(dir, pathFoto)) {
        /// la imagen ya esta en la carpeta de datos
        return pathFoto;
      } else {
        ///mover la foto a la carpeta de datos
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
    final docDir =
        Directory(path.join(appDir.path, tipoDocumento, idDocumento));
    return docDir.existsSync() ? docDir.listSync().whereType<File>() : [];
  }

  static Future deleteFotosDeDocumento(
      {String idDocumento, String tipoDocumento}) async {
    final appDir = await getApplicationDocumentsDirectory();
    final docDir =
        Directory(path.join(appDir.path, tipoDocumento, idDocumento));
    if (docDir.existsSync()) {
      docDir.deleteSync(recursive: true);
    }
  }

  static String convertirAUbicacionAbsoluta(
      {String tipoDeDocumento, String idDocumento, String basename}) {
    return path.join(getIt<DirectorioDeDatos>().path, tipoDeDocumento,
        idDocumento, basename);
  }
}

class DirectorioDeDatos {
  final Directory dir;
  String get path => dir.path;
  DirectorioDeDatos(this.dir);
}

//TODO: usar esta injeccion en todos los lugares de la app para obtener el getApplicationDocumentsDirectory de manera sincrona
@module
abstract class DirectorioDeDatosInjection {
  @preResolve
  Future<DirectorioDeDatos> get dirDatos async =>
      DirectorioDeDatos(await getApplicationDocumentsDirectory());
}
