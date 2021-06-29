// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:data_connection_checker/data_connection_checker.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i10;

import 'application/auth/auth_bloc.dart' as _i15;
import 'application/sincronizacion/sincronizacion_cubit.dart' as _i13;
import 'infrastructure/core/network_info.dart' as _i8;
import 'infrastructure/core/third_party_injections.dart' as _i17;
import 'infrastructure/database/mobile.dart' as _i18;
import 'infrastructure/datasources/injectable_module.dart' as _i19;
import 'infrastructure/datasources/local_preferences_datasource.dart' as _i11;
import 'infrastructure/datasources/remote_datasource.dart' as _i7;
import 'infrastructure/fotos_manager.dart' as _i6;
import 'infrastructure/moor_database.dart' as _i5;
import 'infrastructure/repositories/inspecciones_repository.dart' as _i12;
import 'infrastructure/repositories/planeacion_repository.dart' as _i9;
import 'infrastructure/repositories/user_repository.dart' as _i14;
import 'presentation/pages/login_screen.dart'
    as _i16; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyInjections = _$ThirdPartyInjections();
  final registerModule = _$RegisterModule();
  final directorioDeDatosInjection = _$DirectorioDeDatosInjection();
  final sharedPreferencesInjectableModule =
      _$SharedPreferencesInjectableModule();
  gh.factory<_i3.Client>(() => thirdPartyInjections.client);
  gh.factory<_i4.DataConnectionChecker>(
      () => thirdPartyInjections.dataConnectionChecker);
  gh.lazySingleton<_i5.Database>(() => registerModule.constructDb());
  await gh.factoryAsync<_i6.DirectorioDeDatos>(
      () => directorioDeDatosInjection.dirDatos,
      preResolve: true);
  gh.lazySingleton<_i7.InspeccionesRemoteDataSource>(
      () => _i7.DjangoJsonAPI.anon());
  gh.lazySingleton<_i8.NetworkInfo>(
      () => _i8.NetworkInfoImpl(get<_i4.DataConnectionChecker>()));
  gh.factory<_i9.PlaneacionRepository>(() => _i9.PlaneacionRepository(
      get<_i7.InspeccionesRemoteDataSource>(), get<_i5.Database>()));
  await gh.factoryAsync<_i10.SharedPreferences>(
      () => sharedPreferencesInjectableModule.prefs,
      preResolve: true);
  gh.lazySingleton<_i11.ILocalPreferencesDataSource>(
      () => _i11.SharedPreferencesDataSource(get<_i10.SharedPreferences>()));
  gh.factory<_i12.InspeccionesRepository>(() => _i12.InspeccionesRepository(
      get<_i7.InspeccionesRemoteDataSource>(),
      get<_i5.Database>(),
      get<_i11.ILocalPreferencesDataSource>()));
  gh.factory<_i13.SincronizacionCubit>(() => _i13.SincronizacionCubit(
      get<_i5.Database>(),
      get<_i12.InspeccionesRepository>(),
      get<_i11.ILocalPreferencesDataSource>()));
  gh.factory<_i14.UserRepository>(() => _i14.UserRepository(
      get<_i7.InspeccionesRemoteDataSource>(),
      get<_i11.ILocalPreferencesDataSource>()));
  gh.factory<_i15.AuthBloc>(
      () => _i15.AuthBloc(userRepository: get<_i14.UserRepository>()));
  gh.factory<_i16.LoginControl>(
      () => _i16.LoginControl(userRepository: get<_i14.UserRepository>()));
  return get;
}

class _$ThirdPartyInjections extends _i17.ThirdPartyInjections {}

class _$RegisterModule extends _i18.RegisterModule {}

class _$DirectorioDeDatosInjection extends _i6.DirectorioDeDatosInjection {}

class _$SharedPreferencesInjectableModule
    extends _i19.SharedPreferencesInjectableModule {}
