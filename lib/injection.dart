import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)

/// Inicia el getIt.
Future configureDependencies() async => $initGetIt(getIt);

// Registra en getIt [InspeccionesRemoteDataSource] para poder acceder a ella desde
//cualquier lugar del código
void registrarAPI(Usuario usuario) {
  if (getIt.isRegistered<InspeccionesRemoteDataSource>()) {
    getIt.unregister<InspeccionesRemoteDataSource>();
  }
  getIt.registerLazySingleton<InspeccionesRemoteDataSource>(
      () => DjangoJsonAPI(usuario));
}
