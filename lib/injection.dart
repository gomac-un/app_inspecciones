import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:http/http.dart' as http;
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class ThirdPartyInjections {
  http.Client get client => http.Client();

  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker();

  @Singleton(as: FileSystem)
  LocalFileSystem get fileSystem =>
      const LocalFileSystem(); //TODO: mirar si se puede usar un memoryFileSystem para web
}

// Registra en getIt [InspeccionesRemoteDataSource] para poder acceder a ella desde
//cualquier lugar del código
void registrarAPI(UsuarioOnline usuario) {
  if (getIt.isRegistered<InspeccionesRemoteDataSource>()) {
    getIt.unregister<InspeccionesRemoteDataSource>();
  }
  getIt.registerLazySingleton<InspeccionesRemoteDataSource>(
      () => DjangoJsonAPI(usuario));
}
