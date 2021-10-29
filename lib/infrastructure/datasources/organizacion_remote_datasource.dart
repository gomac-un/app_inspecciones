import 'dart:async';

import 'package:inspecciones/infrastructure/core/typedefs.dart';

abstract class OrganizacionRemoteDataSource {
  Future<JsonList> getListaDeUsuarios();
  Future<JsonMap> getOrganizacion(int? id);
  Future<JsonList> getListaDeActivos();
  Future<JsonMap> guardarActivo(JsonMap activo);
  Future<JsonMap> crearOrganizacion(JsonMap formulario);
  Future<JsonMap> actualizarOrganizacion(int id, JsonMap formulario);
}
