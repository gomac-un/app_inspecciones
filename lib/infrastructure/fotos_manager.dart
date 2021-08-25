import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:inspecciones/injection.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

/// Clase encargada de manejar las fotos de cuestionarios e inspecciones
/// TODO: hacer que esta clase deje de ser solo funciones estáticas
class FotosManager {
  /// mueve las fotos de su ubicacion temporal a la carpeta designada para el
  /// cuestionario o inspeccion
  static Future<Iterable<String>> organizarFotos(
    ListPathFotos fotos, {
    required String tipoDocumento,
    required String idDocumento,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    return Future.wait(fotos.toList().map((pathFoto) async {
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
      {required String idDocumento, required String tipoDocumento}) async {
    final appDir = await getApplicationDocumentsDirectory();
    final docDir =
        Directory(path.join(appDir.path, tipoDocumento, idDocumento));
    return docDir.existsSync() ? docDir.listSync().whereType<File>() : [];
  }

  static String convertirAUbicacionAbsoluta({
    required String tipoDeDocumento,
    required String idDocumento,
    required String basename,
  }) {
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
