import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/infrastructure/core/directorio_de_datos.dart';

import 'local_preferences_datasource.dart';
import 'remote_datasource.dart';

final inspeccionesRemoteDataSourceProvider =
    Provider<InspeccionesRemoteDataSource>((ref) => DjangoJsonAPI(UsuarioOnline(
        documento: "1",
        password: "1",
        token: "1",
        esAdmin: true))); //TODO: implementar

final authRemoteDataSourceProvider = Provider((ref) => AuthRemoteDatasource());

final localPreferencesDataSourceProvider = Provider<LocalPreferencesDataSource>(
    (ref) =>
        SharedPreferencesDataSourceImpl(ref.watch(sharedPreferencesProvider)));

final directorioDeDatosProvider = Provider<DirectorioDeDatos>(
    (ref) => throw Exception("no se ha inicializado el directorio de datos"));
