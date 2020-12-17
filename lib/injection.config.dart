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
import 'infrastructure/datasources/local_preferences_datasource.dart';
import 'infrastructure/datasources/remote_datasource.dart';
import 'infrastructure/repositories/inspecciones_repository.dart';
import 'presentation/pages/login_screen.dart';
import 'infrastructure/core/network_info.dart';
import 'infrastructure/database/mobile.dart';
import 'infrastructure/datasources/injectable_module.dart';
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
  final sharedPreferencesInjectableModule =
      _$SharedPreferencesInjectableModule();
  gh.factory<Client>(() => thirdPartyInjections.client);
  gh.factory<DataConnectionChecker>(
      () => thirdPartyInjections.dataConnectionChecker);
  gh.lazySingleton<Database>(() => registerModule.constructDb());
  gh.lazySingleton<InspeccionesRemoteDataSource>(() => DjangoAPI());
  gh.lazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(get<DataConnectionChecker>()));
  final sharedPreferences = await sharedPreferencesInjectableModule.prefs;
  gh.factory<SharedPreferences>(() => sharedPreferences);
  gh.lazySingleton<ILocalPreferencesDataSource>(
      () => SharedPreferencesDataSource(get<SharedPreferences>()));
  gh.lazySingleton<InspeccionesRepository>(() => InspeccionesRepository(
        remoteDataSource: get<InspeccionesRemoteDataSource>(),
        localDataBase: get<Database>(),
        networkInfo: get<NetworkInfo>(),
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

class _$SharedPreferencesInjectableModule
    extends SharedPreferencesInjectableModule {}
