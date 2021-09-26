import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/entities/usuario.dart';
import 'package:inspecciones/infrastructure/core/directorio_de_datos.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)

/// Inicia el getIt.
Future<GetIt> configureDependencies() async => $initGetIt(getIt);

/// registro de dependencias externas del proyecto
@module
abstract class ThirdPartyInjections {
  http.Client get client => http.Client();

  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  Future<DirectorioDeDatos> get dirDatos async {
    final dir = await getApplicationDocumentsDirectory();
    return DirectorioDeDatos(dir.path);
  }

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
