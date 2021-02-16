// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:http/http.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application/auth/auth_bloc.dart';
import 'infrastructure/moor_database.dart';
import 'infrastructure/fotos_manager.dart';
import 'infrastructure/datasources/local_preferences_datasource.dart';
import 'infrastructure/datasources/remote_datasource.dart';
import 'infrastructure/repositories/inspecciones_repository.dart';
import 'presentation/pages/login_screen.dart';
import 'infrastructure/core/network_info.dart';
import 'infrastructure/database/mobile.dart';
import 'infrastructure/datasources/injectable_module.dart';
import 'application/sincronizacion/sincronizacion_cubit.dart';
import 'infrastructure/core/third_party_injections.dart';
import 'infrastructure/repositories/user_repository.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

Future<GetIt> $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) async {
  final gh = GetItHelper(get, environment, environmentFilter);
  final thirdPartyInjections = _$ThirdPartyInjections();
  final registerModule = _$RegisterModule();
  final directorioDeDatosInjection = _$DirectorioDeDatosInjection();
  final sharedPreferencesInjectableModule =
      _$SharedPreferencesInjectableModule();
  gh.factory<Client>(() => thirdPartyInjections.client);
  gh.factory<DataConnectionChecker>(
      () => thirdPartyInjections.dataConnectionChecker);
  gh.lazySingleton<Database>(() => registerModule.constructDb());
  final resolvedDirectorioDeDatos = await directorioDeDatosInjection.dirDatos;
  gh.factory<DirectorioDeDatos>(() => resolvedDirectorioDeDatos);
  gh.lazySingleton<InspeccionesRemoteDataSource>(() => DjangoJsonAPI.anon());
  gh.factory<InspeccionesRepository>(() => InspeccionesRepository(
      get<InspeccionesRemoteDataSource>(), get<Database>()));
  gh.lazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(get<DataConnectionChecker>()));
  final resolvedSharedPreferences =
      await sharedPreferencesInjectableModule.prefs;
  gh.factory<SharedPreferences>(() => resolvedSharedPreferences);
  gh.lazySingleton<ILocalPreferencesDataSource>(
      () => SharedPreferencesDataSource(get<SharedPreferences>()));
  gh.factory<SincronizacionCubit>(() => SincronizacionCubit(
        get<Database>(),
        get<InspeccionesRepository>(),
        get<ILocalPreferencesDataSource>(),
      ));
  gh.factory<UserRepository>(() => UserRepository(
      get<InspeccionesRemoteDataSource>(), get<ILocalPreferencesDataSource>()));
  gh.factory<AuthBloc>(() => AuthBloc(userRepository: get<UserRepository>()));
  gh.factory<LoginControl>(
      () => LoginControl(userRepository: get<UserRepository>()));
  return get;
}

class _$ThirdPartyInjections extends ThirdPartyInjections {}

class _$RegisterModule extends RegisterModule {}

class _$DirectorioDeDatosInjection extends DirectorioDeDatosInjection {}

class _$SharedPreferencesInjectableModule
    extends SharedPreferencesInjectableModule {}
