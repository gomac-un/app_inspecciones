import 'package:dartz/dartz.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file/memory.dart';
import 'package:file_testing/file_testing.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:inspecciones/infrastructure/core/directorio_de_datos.dart';

void main() {
  late FotosRepository repository;
  late FileSystem fileSystem;
  late DirectorioDeDatos directorioDeDatos;

  setUp(() {
    fileSystem = MemoryFileSystem();

    directorioDeDatos = DirectorioDeDatos(p.join('/my', 'AppDocsDir'));

    repository = FotosRepository(fileSystem, directorioDeDatos);
  });

  test('organizarFotos debería recibir y devolver lista vacia', () async {
    //arrange
    const fotos = Nil<AppImage>();
    // act
    final copiedFotos = await repository
        .organizarFotos(fotos, Categoria.inspeccion, identificador: '1');
    // assert
    expect(copiedFotos, const Nil());
  });

  test('organizarFotos no debería alterar la foto remote', () async {
    // arrange
    fotosGen() =>
        IList.from([const AppImage.remote('http://gomac.com/foto.jpg')]);
    // act
    final copiedFotos = await repository
        .organizarFotos(fotosGen(), Categoria.inspeccion, identificador: '1');
    // assert
    expect(copiedFotos, fotosGen());
  });

  test('organizarFotos debería lanzar excepcion con fotos web', () async {
    // arrange
    final fotos = IList.from([const AppImage.web('file://myfoto.jpg')]);
    // act
    final copiedFotosOp = repository.organizarFotos(fotos, Categoria.inspeccion,
        identificador: '1');
    // assert
    expect(copiedFotosOp, throwsUnsupportedError);
  });

  test(
      'organizarFotos debería mover las fotos moviles del directorio temporal al directorio designado para el documento',
      () async {
    // arrange
    final generatedImagePath = p.join('/temp', '1.jpg');
    final generatedImage =
        await fileSystem.file(generatedImagePath).create(recursive: true);
    final fotos = IList.from([AppImage.mobile(generatedImage.path)]);
    // act
    final copiedFotos = await repository
        .organizarFotos(fotos, Categoria.inspeccion, identificador: '1');

    // assert
    final expectedNewPath =
        p.join(directorioDeDatos.path, 'inspecciones', '1', '1.jpg');
    expect(
        copiedFotos.any((a) => a.maybeMap(
            mobile: (m) => m.path == expectedNewPath, orElse: () => false)),
        isTrue);
    expect(fileSystem.file(expectedNewPath), exists);
  });

  test(
      'organizarFotos debería dejar los paths iguales si ya se encuentran en la carpeta designada',
      () async {
    // arrange
    final generatedImagePath =
        p.join(directorioDeDatos.path, 'inspecciones', '1', '1.jpg');
    final generatedImage =
        await fileSystem.file(generatedImagePath).create(recursive: true);
    final fotos = IList.from([AppImage.mobile(generatedImage.path)]);
    // act
    final copiedFotos = await repository
        .organizarFotos(fotos, Categoria.inspeccion, identificador: '1');

    // assert
    final expectedNewPath = generatedImagePath;
    expect(
        copiedFotos.any((a) => a.maybeMap(
            mobile: (m) => m.path == expectedNewPath, orElse: () => false)),
        isTrue);
    expect(fileSystem.file(expectedNewPath), exists);
  });

  test(
      'organizarFotos debería mover las fotos a la carpeta cuestionarios si esa es su categoria',
      () async {
    // arrange
    final generatedImagePath = p.join('/temp', '1.jpg');
    final generatedImage =
        await fileSystem.file(generatedImagePath).create(recursive: true);
    final fotos = IList.from([AppImage.mobile(generatedImage.path)]);
    // act
    final copiedFotos = await repository
        .organizarFotos(fotos, Categoria.cuestionario, identificador: '2');

    // assert
    final expectedNewPath =
        p.join(directorioDeDatos.path, 'cuestionarios', '2', '1.jpg');
    expect(
        copiedFotos.any((a) => a.maybeMap(
            mobile: (m) => m.path == expectedNewPath, orElse: () => false)),
        isTrue);
    expect(fileSystem.file(expectedNewPath), exists);
  });
  group('getFotosDeDocumento', () {
    setUp(() {
      /// tocó usar el [LocalFileSystem] ya que con [MemoryFileSystem] no se crea el directorio
      fileSystem = LocalFileSystem();

      directorioDeDatos = DirectorioDeDatos(
          p.join(fileSystem.systemTempDirectory.path, 'app_inspecciones'));

      repository = FotosRepository(fileSystem, directorioDeDatos);
    });

    test('getFotosDeDocumento debería devolver la lista de fotos guardadas',
        () async {
      // arrange
      final generatedImage1Path =
          p.join(directorioDeDatos.path, 'inspecciones', '1', '1.jpg');
      await fileSystem.file(generatedImage1Path).create(recursive: true);

      final generatedImage2Path =
          p.join(directorioDeDatos.path, 'inspecciones', '1', '50.jpg');
      await fileSystem.file(generatedImage2Path).create(recursive: true);

      // act
      final res = await repository.getFotosDeDocumento(
        Categoria.inspeccion,
        identificador: '1',
      );

      // assert
      expect(
          res.any((file) => p.equals(file.path, generatedImage1Path)), isTrue);
      expect(
          res.any((file) => p.equals(file.path, generatedImage2Path)), isTrue);
      expect(res.length, 2);
    });
    test(
        'getFotosDeDocumento debería devolver una lista vacía si la carpeta no existe',
        () async {
      // act
      final res = await repository.getFotosDeDocumento(
        Categoria.inspeccion,
        identificador: '1',
      );

      // assert
      expect(res.length, 0);
    });

    tearDown(() async {
      //! ojo con mandar el path correcto, no vaya a ser que borre el disco C
      final dir = fileSystem.directory(directorioDeDatos.path);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    });
  });
  group('convertirAUbicacionAbsolutaAppImage', () {
    test('Debería devolver la ubicacion absoluta de imagenes moviles', () {
      // arrange
      const foto = AppImage.mobile('1.jpg');
      // act
      final ubicacionAbsoluta = repository.convertirAUbicacionAbsolutaAppImage(
        foto,
        Categoria.inspeccion,
        identificador: '1',
      );
      // assert
      expect(ubicacionAbsoluta.maybeWhen(mobile: id, orElse: () => ''),
          p.join(directorioDeDatos.path, 'inspecciones', '1', '1.jpg'));
    });
    test('debería devolver la ubicacion las imagenes remotas sin cambio', () {
      // arrange
      const foto = AppImage.remote('http://example.com/1.jpg');
      // act
      final ubicacionAbsoluta = repository.convertirAUbicacionAbsolutaAppImage(
        foto,
        Categoria.inspeccion,
        identificador: '1',
      );
      // assert
      expect(
        ubicacionAbsoluta.maybeWhen(remote: id, orElse: () => ''),
        'http://example.com/1.jpg',
      );
    });
    test('debería lanzar excepcion con imagenes web', () {
      // arrange
      const foto = AppImage.web('file://myimage.jpg');
      // act
      ejecutarUbicacionAbsoluta() =>
          repository.convertirAUbicacionAbsolutaAppImage(
            foto,
            Categoria.inspeccion,
            identificador: '1',
          );
      // assert
      expect(ejecutarUbicacionAbsoluta, throwsUnsupportedError);
    });
  });
}
