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

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({@required this.userRepository})
      : assert(UserRepository != null),
        super(const AuthState.initial());

  final UserRepository userRepository;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield* event.when(
      //TODO: pulir los errores
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
      loggingIn: (usuario) async* {
        registrarAPI(usuario);
        final appId = await getIt<UserRepository>()
            .getAppId(); 
        if (appId == null) {
          throw Exception("No se puede ingresar sin internet por primera vez");
        }
        await userRepository.saveLocalUser(user: usuario);
        yield AuthState.authenticated(usuario: usuario);
      },
      loggingOut: () async* {
        yield const AuthState.loading();
        registrarAPI(null);
        await userRepository.deleteLocalUser();
        yield const AuthState.unauthenticated();
      },
    );
  }

  void registrarAPI(Usuario usuario) {
    if (getIt.isRegistered<InspeccionesRemoteDataSource>()) {
      getIt.unregister<InspeccionesRemoteDataSource>();
    }
    getIt.registerLazySingleton<InspeccionesRemoteDataSource>(
        () => DjangoJsonAPI(usuario));
  }
}
