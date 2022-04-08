import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/core/typedefs.dart';

import 'auth_remote_datasource.dart';
import 'cuestionarios_remote_datasource.dart';
import 'django_json_api_client.dart';
import 'inspecciones_remote_datasource.dart';
import 'organizacion_remote_datasource.dart';

class DjangoJsonApi
    implements
        AuthRemoteDataSource,
        CuestionariosRemoteDataSource,
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

  @override
  Future<JsonMap> subirCuestionario(JsonMap cuestionario) =>
      _client.request('POST', _apiUri.appendSegment("cuestionarios-completos"),
          body: cuestionario);

  @override
  Future<JsonMap> actualizarCuestionario(
    String cuestionarioId,
    JsonMap cuestionario,
  ) =>
      _client.request(
          'PUT',
          _apiUri
              .appendSegment("cuestionarios-completos", addTrailingSlash: false)
              .appendSegment(cuestionarioId),
          body: cuestionario);

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
  Future<JsonMap> descargarInspeccion(String id) => _client.request(
      'GET',
      _apiUri
          .appendSegment("inspecciones-completas", addTrailingSlash: false)
          .appendSegment(id));

  @override
  Future<JsonMap> actualizarInspeccion(
          String inspeccionId, JsonMap inspeccion) =>
      _client.request(
          'PUT',
          _apiUri
              .appendSegment("inspecciones-completas", addTrailingSlash: false)
              .appendSegment(inspeccionId),
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
