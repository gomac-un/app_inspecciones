import 'dart:async';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/infrastructure/core/typedefs.dart';
import 'package:inspecciones/infrastructure/datasources/fotos_remote_datasource.dart';
import 'package:inspecciones/infrastructure/datasources/organizacion_remote_datasource.dart';
import 'package:inspecciones/infrastructure/repositories/fotos_repository.dart';
import 'package:path/path.dart' as path;

import 'auth_remote_datasource.dart';
import 'cuestionarios_remote_datasource.dart';
import 'django_json_api_client.dart';
import 'flutter_downloader/flutter_downloader_as_future.dart';
import 'inspecciones_remote_datasource.dart';

class DjangoJsonApi
    implements
        AuthRemoteDataSource,
        CuestionariosRemoteDataSource,
        FotosRemoteDataSource,
        InspeccionesRemoteDataSource,
        OrganizacionRemoteDataSource {
  final Reader _read;
  DjangoJsonApiClient get _client => _read(djangoJsonApiClientProvider);
  final Uri _apiUri;

  /// Repositorio que se comunica con la api de inspecciones en la uri [_apiUri].
  ///  La dependencia [_client] es la encargada de autenticar las peticiones,
  /// ver [DjangoJsonApiClient]
  /// Las excepciones lanzadas por todos los métodos de esta clase deberían ser
  /// unicamente los definidos en [core/errors.dart], aunque podrían pasar algunos
  /// otros inesperadamente.
  DjangoJsonApi(this._read, this._apiUri);

  /// Devuelve el token del usuario
  ///
  /// Con las credenciales ingresadas al momento de iniciar sesión, se hace
  /// la petición a la Api para que devuelva el token de autenticación
  /// (https://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication)
  /// Este es el unico método de este repositorio que no require un [_client] autenticado
  @override
  Future<JsonMap> getToken(JsonMap credenciales) =>
      _client.request('POST', _apiUri.appendSegment('api-token-auth'),
          body: credenciales);

  @override
  Future<JsonMap> getPerfil(int? id) => _client.request(
      'GET',
      _apiUri
          .appendSegment('users', addTrailingSlash: false)
          .appendSegment(id?.toString() ?? 'mi_perfil'));

  @override
  Future<JsonMap> getOrganizacion(int? id) => _client.request(
      'GET',
      _apiUri
          .appendSegment('organizaciones', addTrailingSlash: false)
          .appendSegment(id?.toString() ?? 'mi_organizacion'));

/*
  /// Le informa al servidor que debe registrar un nuevo cliente y el servidor
  /// retorna una id, esta id es unica y será usada para generar
  /// las ids de los objetos generados localmente de tal manera que al subirlos,
  /// no hayan choques de ids
  @override
  Future<JsonMap> registrarApp() =>
      _client.request('POST', _apiUri.appendSegment('dispositivos'), body: {});*/

  @override
  Future<JsonMap> registrarUsuario(JsonMap form) =>
      _client.request('POST', _apiUri.appendSegment('users'),
          body: form, format: 'multipart');

  @override
  Future<JsonMap> crearOrganizacion(JsonMap formulario) =>
      _client.request('POST', _apiUri.appendSegment('organizaciones'),
          body: formulario, format: 'multipart');

  @override
  Future<JsonMap> actualizarOrganizacion(int id, JsonMap formulario) =>
      _client.request(
          'PUT',
          _apiUri
              .appendSegment('organizaciones', addTrailingSlash: false)
              .appendSegment(id.toString()),
          body: formulario,
          format: 'multipart');

  @override
  Future<JsonList> getListaDeUsuarios() =>
      _client.request('GET', _apiUri.appendSegment('users'));

  @override
  Future<JsonList> getListaDeActivos() =>
      _client.request('GET', _apiUri.appendSegment('activos'));

  @override
  Future<JsonMap> guardarActivo(String identificador, JsonMap activo) =>
      _client.request(
          'PUT',
          _apiUri
              .appendSegment('activos', addTrailingSlash: false)
              .appendSegment(identificador),
          body: activo);

  @override
  Future<void> borrarActivo(String activoId) => _client.request(
      'DELETE',
      _apiUri
          .appendSegment('activos', addTrailingSlash: false)
          .appendSegment(activoId));

  /*@override
  Future<JsonMap> guardarActivo(JsonMap activo) =>
      _client.request('POST', _apiUri.appendSegment('activos'), body: activo);*/

  @override
  Future<JsonMap> getInspeccion(int id) => _client.request(
      'GET',
      _apiUri
          .appendSegment("inspecciones", addTrailingSlash: false)
          .appendSegment("$id"));

  @override
  Future<JsonMap> crearInspeccion(JsonMap inspeccion) => _client
      .request('POST', _apiUri.appendSegment("inspecciones"), body: inspeccion);

  @override
  Future<JsonMap> actualizarInspeccion(int inspeccionId, JsonMap inspeccion) =>
      _client.request(
          'PUT',
          _apiUri
              .appendSegment("inspecciones", addTrailingSlash: false)
              .appendSegment("$inspeccionId"),
          body: inspeccion);

  @override
  Future<JsonMap> subirFotos(Iterable<AppImage> fotos, String idDocumento,
      Categoria tipoDocumento) async {
    final body = {
      'iddocumento': idDocumento,
      'tipodocumento': EnumToString.convertToString(tipoDocumento),
      'fotos': fotos,
    };

    return _client.request('POST', _apiUri.appendSegment('subir-fotos'),
        body: body, format: 'multipart');
  }

  @override
  Future<JsonMap> subirCuestionario(JsonMap cuestionario) =>
      _client.request('POST', _apiUri.appendSegment("cuestionarios-completos"),
          body: cuestionario);

  /// TODO: mirar como hacer para no tener el token como parámetro
  @override
  Future<File> descargarTodosLosCuestionarios(String token) async {
    final uri = _apiUri.appendSegment('server');
    return flutterDownloaderAsFuture(
      uri,
      'server.json',
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
  }

  /// TODO: mirar como hacer para no tener el token como parámetro
  /// Descarga todas las fotos de todos los cuestionarios
  @override
  Future<void> descargarTodasLasFotos(String token) async {
    final uri = _apiUri
        .appendSegment('media', addTrailingSlash: false)
        .appendSegment('fotos-app-inspecciones', addTrailingSlash: false)
        .appendSegment('cuestionarios.zip', addTrailingSlash: false);
    final zipFotos = await flutterDownloaderAsFuture(
      uri,
      'cuestionarios.zip',
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    //descompresion
    final destinationDir =
        Directory(path.join(await directorioDeDescarga(), 'cuestionarios'));

    await ZipFile.extractToDirectory(
        zipFile: zipFotos, destinationDir: destinationDir);
  }

  @override
  Future<JsonMap> descargarCuestionario(String cuestionarioId) =>
      _client.request(
          'GET',
          _apiUri
              .appendSegment('cuestionarios-completos', addTrailingSlash: false)
              .appendSegment(cuestionarioId));

  @override
  Future<JsonList> getCuestionarios() =>
      _client.request('GET', _apiUri.appendSegment('cuestionarios'));

  @override
  Future<JsonMap> subirFotosCuestionario(JsonList fotos) => _client.request(
      'POST',
      _apiUri
          .appendSegment('cuestionarios-completos', addTrailingSlash: false)
          .appendSegment("subir_fotos"),
      body: {"fotos": fotos},
      format: 'multipart');

  @override
  Future<JsonMap> subirFotosInspeccion(JsonList fotos) => _client.request(
      'POST',
      _apiUri
          .appendSegment('inspecciones-completas', addTrailingSlash: false)
          .appendSegment("subir_fotos"),
      body: {"fotos": fotos},
      format: 'multipart');

  @override
  Future<JsonMap> subirInspeccion(JsonMap inspeccion) =>
      _client.request('POST', _apiUri.appendSegment("inspecciones-completas"),
          body: inspeccion);

  @override
  Future<JsonList> getListaDeEtiquetasDeActivos() =>
      _client.request('GET', _apiUri.appendSegment('etiquetas-activos'));

  ///TODO: mirar como hacer para subirlas todas en una sola request
  @override
  Future<void> subirListaDeEtiquetasDeActivos(JsonList lista) async {
    for (final etiqueta in lista) {
      await _client.request('POST', _apiUri.appendSegment('etiquetas-activos'),
          body: etiqueta);
    }
  }

  @override
  Future<JsonList> getListaDeEtiquetasDePreguntas() =>
      _client.request('GET', _apiUri.appendSegment('etiquetas-preguntas'));

  ///TODO: mirar como hacer para subirlas todas en una sola request
  @override
  Future<void> subirListaDeEtiquetasDePreguntas(JsonList lista) async {
    for (final etiqueta in lista) {
      await _client.request(
          'POST', _apiUri.appendSegment('etiquetas-preguntas'),
          body: etiqueta);
    }
  }

  @override
  Future<void> eliminarEtiquetaDeActivo(String etiquetaId) => _client.request(
      'DELETE',
      _apiUri
          .appendSegment('etiquetas-activos', addTrailingSlash: false)
          .appendSegment(etiquetaId));

  @override
  Future<void> eliminarEtiquetaDePregunta(String etiquetaId) => _client.request(
      'DELETE',
      _apiUri
          .appendSegment('etiquetas-preguntas', addTrailingSlash: false)
          .appendSegment(etiquetaId));
}

extension ManipulacionesUri on Uri {
  Uri appendSegment(String segment, {bool addTrailingSlash = true}) => replace(
      pathSegments: [...pathSegments, segment, if (addTrailingSlash) '']);
}
