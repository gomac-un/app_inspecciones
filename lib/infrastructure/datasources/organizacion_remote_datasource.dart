import 'dart:async';

import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class OrganizacionRemoteDataSource {
  Future<JsonList> getListaDeUsuarios();
  Future<JsonMap> getOrganizacion(int? id);

  Future<JsonList> getListaDeActivos();
  Future<JsonMap> guardarActivo(String identificador, JsonMap activo);
  Future<void> borrarActivo(String activoId);

  Future<JsonMap> crearOrganizacion(JsonMap formulario);
  Future<JsonMap> actualizarOrganizacion(int id, JsonMap formulario);

  Future<JsonList> getListaDeEtiquetasDeActivos();
  Future<void> subirListaDeEtiquetasDeActivos(JsonList lista);

  Future<JsonList> getListaDeEtiquetasDePreguntas();
  Future<void> subirListaDeEtiquetasDePreguntas(JsonList lista);

  Future<void> eliminarEtiquetaDeActivo(String etiquetaId);
  Future<void> eliminarEtiquetaDePregunta(String etiquetaId);
}
