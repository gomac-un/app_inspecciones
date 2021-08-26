import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/injection.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:cross_file/cross_file.dart';

/// Clase encargada de manejar las fotos de cuestionarios e inspecciones

@injectable
class FotosRepository {
  const FotosRepository();

  /// mueve las fotos de su ubicacion temporal a la carpeta designada para el
  /// cuestionario o inspeccion
  Future<IList<AppImage>> organizarFotos(
    IList<AppImage> fotos, {
    required String tipoDocumento,
    required String idDocumento,
  }) async {
    return IList.from(await Future.wait(fotos
        .map((foto) => foto.map(
              remote: (e) => Future.value(e),
              mobile: (im) => _procesarFoto(
                im.path,
                tipoDocumento: tipoDocumento,
                idDocumento: idDocumento,
              ),
              web: (im) => throw UnsupportedError(
                  "Las imagenes web no se pueden procesar en el sistema de archivos"),
            ))
        .toIterable()));
  }

  Future<MobileImage> _procesarFoto(
    String filePath, {
    required String tipoDocumento,
    required String idDocumento,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = path.join(appDir.path, tipoDocumento, idDocumento);
    if (path.isWithin(dir, filePath)) {
      /// la imagen ya esta en la carpeta de datos
      return MobileImage(filePath);
    } else {
      ///mover la foto a la carpeta de datos
      final fileName = path.basename(filePath);
      final newPath = path.join(dir, fileName);
      await File(newPath).create(recursive: true);
      final savedImage = await File(filePath).copy(newPath);
      return MobileImage(savedImage.path);
    }
  }

  Future<Iterable<File>> getFotosDeDocumento(
      {required String idDocumento, required String tipoDocumento}) async {
    final appDir = await getApplicationDocumentsDirectory();
    final docDir =
        Directory(path.join(appDir.path, tipoDocumento, idDocumento));
    return docDir.existsSync() ? docDir.listSync().whereType<File>() : [];
  }

  String convertirAUbicacionAbsoluta({
    required String tipoDeDocumento,
    required String idDocumento,
    required String basename,
  }) {
    return path.join(getIt<DirectorioDeDatos>().path, tipoDeDocumento,
        idDocumento, basename);
  }

  AppImage convertirAUbicacionAbsolutaAppImage({
    required String tipoDeDocumento,
    required String idDocumento,
    required AppImage foto,
  }) {
    return foto.map(
      remote: id,
      mobile: (e) => e.copyWith(
          path: convertirAUbicacionAbsoluta(
        tipoDeDocumento: tipoDeDocumento,
        idDocumento: idDocumento,
        basename: e.path,
      )),
      web: (e) => throw UnsupportedError(
          "Las imagenes web no se pueden procesar en el sistema de archivos"),
    );
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
