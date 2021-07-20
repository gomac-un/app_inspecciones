import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/auth/usuario.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

part 'auth_bloc.freezed.dart';

// Modulo @injectable para manejar el estado de la aplicación al momento del ingreso del usuario
//
// Se usa  BLoC (https://bloclibrary.dev/#/).
// El método [mapEventToState] escucha tres eventos definidos en auth_event.

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({@required this.userRepository})
      : assert(UserRepository != null),
        super(const AuthState.initial());

  // Información del ususario
  final UserRepository userRepository;

  // Stream que escucha los cambios en el login.
  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield* event.when(
      //TODO: pulir los errores
      // Cuando se inicia la app y el [usuario] esté guardado, se llama [registrarApi]
      //y, finalmente se actualiza el estado a autenticado
      startingApp: () async* {
        final usuario = userRepository.getLocalUser();

        yield usuario.fold(
          () => const AuthState.unauthenticated(),
          (usuario) {
            registrarAPI(usuario);
            return AuthState.authenticated(usuario: usuario);
          },
        );
      },

      /// Actualiza el estado del login a autenticado cuando [usuario] inicia sesión.
      /// si [appId] no existe, lanza error para que se conecte a internet.
      loggingIn: (usuario) async* {
        registrarAPI(usuario);

        /// código unico que identifica cada instalación de la app
        final appId = await getIt<UserRepository>().getAppId();
        if (appId == null) {
          throw Exception("No se puede ingresar sin internet por primera vez");
        }

        /// Guarda los datos del usuario, para que no tenga que iniciar sesión la próxima vez
        await userRepository.saveLocalUser(user: usuario);
        yield AuthState.authenticated(usuario: usuario);
      },

      /// Actualiza el estado del login a inautenticado cuando el usuario cierra sesión
      loggingOut: () async* {
        yield const AuthState.loading();
        registrarAPI(null);

        /// Se borra la info del usuario, lo que hace que deba iniciar sesión la próxima vez
        await userRepository.deleteLocalUser();
        yield const AuthState.unauthenticated();
      },
    );
  }

  // Registra en getIt [InspeccionesRemoteDataSource] para poder acceder a ella desde
  //cualquier lugar del código
  void registrarAPI(Usuario usuario) {
    if (getIt.isRegistered<InspeccionesRemoteDataSource>()) {
      getIt.unregister<InspeccionesRemoteDataSource>();
    }
    getIt.registerLazySingleton<InspeccionesRemoteDataSource>(
        () => DjangoJsonAPI(usuario));
  }
}
