import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:file/file.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/infrastructure/core/directorio_de_datos.dart';
import 'package:path/path.dart' as path;

final fotosRepositoryProvider = Provider(
  (ref) => FotosRepository(
    ref.watch(fileSystemProvider),
    ref.watch(directorioDeDatosProvider),
  ),
);

final fileSystemProvider = Provider<FileSystem>(
    (ref) => throw Exception("no se ha definido el FileSystem"));

enum Categoria { cuestionario, inspeccion }

class FotosRepository {
  final FileSystem _fileSystem;
  final DirectorioDeDatos _directorio;

  FotosRepository(
    this._fileSystem,
    this._directorio,
  );

  /// mueve las fotos de su ubicacion temporal a la carpeta designada para el
  /// cuestionario o inspeccion
  Future<IList<AppImage>> organizarFotos(
    IList<AppImage> fotos,
    Categoria categoria, {
    required String identificador,
  }) async =>
      IList.from(
        await Future.wait(
          fotos
              .map((foto) => foto.map(
                    remote: (e) => Future.value(e),
                    mobile: (im) => _procesarFoto(
                      im.path,
                      categoria,
                      identificador: identificador,
                    ),
                    web: (im) => throw UnsupportedError(
                        "Las imagenes web no se pueden procesar en el sistema de archivos"),
                  ))
              .toIterable(),
        ),
      );

  Future<MobileImage> _procesarFoto(
    String filePath,
    Categoria categoria, {
    required String identificador,
  }) async {
    final subcarpeta = _categoriaToSubcarpeta(categoria);

    final dir = path.join(_directorio.path, subcarpeta, identificador);
    if (path.isWithin(dir, filePath)) {
      // optimizacion
      /// la imagen ya esta en la carpeta de designada
      return MobileImage(filePath);
    }

    ///mover la foto a la carpeta designada
    final fileName = path.basename(filePath);
    final newPath = path.join(dir, fileName);
    await _fileSystem.file(newPath).create(recursive: true);
    final savedImage = await _fileSystem.file(filePath).copy(newPath);
    return MobileImage(savedImage.path);
  }

  /// Lee la carpeta designada para [identificador] y [categoria] y devuelve
  /// la lista de todos las fotos que hay.
  /// TODO: implementar con imagenes web
  Future<List<MobileImage>> getFotosDeDocumento(
    Categoria categoria, {
    required String identificador,
  }) async {
    final subcarpeta = _categoriaToSubcarpeta(categoria);
    final docDir = _fileSystem
        .directory(path.join(_directorio.path, subcarpeta, identificador));
    final existe = await docDir.exists();
    if (!existe) return [];
    return docDir
        .list()
        .where((e) => e is File)
        .cast<File>()
        .map((f) => MobileImage(f.path))
        .toList();
  }

  String _convertirAUbicacionAbsoluta(
    Categoria categoria, {
    required String identificador,
    required String basename,
  }) {
    return path.join(_directorio.path, _categoriaToSubcarpeta(categoria),
        identificador, basename);
  }

  AppImage convertirAUbicacionAbsolutaAppImage(
    AppImage foto,
    Categoria categoria, {
    required String identificador,
  }) {
    return foto.map(
      remote: id,
      mobile: (e) => e.copyWith(
        path: _convertirAUbicacionAbsoluta(
          categoria,
          identificador: identificador,
          basename: e.path,
        ),
      ),
      web: (e) => throw UnsupportedError(
          "Las imagenes web no se pueden procesar en el sistema de archivos"),
    );
  }

  String _categoriaToSubcarpeta(Categoria categoria) {
    switch (categoria) {
      case Categoria.cuestionario:
        return "cuestionarios";
      case Categoria.inspeccion:
        return "inspecciones";
    }
  }
}
