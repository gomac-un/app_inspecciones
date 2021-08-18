// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i9;
import 'package:shared_preferences/shared_preferences.dart' as _i13;

import 'application/auth/auth_bloc.dart' as _i16;
import 'application/auth/usuario.dart' as _i7;
import 'application/sincronizacion/sincronizacion_cubit.dart' as _i17;
import 'infrastructure/core/network_info.dart' as _i11;
import 'infrastructure/core/third_party_injections.dart' as _i18;
import 'infrastructure/database/mobile.dart' as _i19;
import 'infrastructure/datasources/injectable_module.dart' as _i20;
import 'infrastructure/datasources/local_preferences_datasource.dart' as _i14;
import 'infrastructure/datasources/remote_datasource.dart' as _i6;
import 'infrastructure/fotos_manager.dart' as _i5;
import 'infrastructure/moor_database.dart' as _i4;
import 'infrastructure/repositories/inspecciones_repository.dart' as _i8;
import 'infrastructure/repositories/planeacion_repository.dart' as _i12;
import 'infrastructure/repositories/user_repository.dart' as _i15;
import 'presentation/pages/login_page.dart'
    as _i10; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyInjections = _$ThirdPartyInjections();
  final registerModule = _$RegisterModule();
  final directorioDeDatosInjection = _$DirectorioDeDatosInjection();
  final sharedPreferencesInjectableModule =
      _$SharedPreferencesInjectableModule();
  gh.factory<_i3.Client>(() => thirdPartyInjections.client);
  gh.lazySingleton<_i4.Database>(() => registerModule.constructDb());
  await gh.factoryAsync<_i5.DirectorioDeDatos>(
      () => directorioDeDatosInjection.dirDatos,
      preResolve: true);
  gh.lazySingleton<_i6.InspeccionesRemoteDataSource>(
      () => _i6.DjangoJsonAPI(get<_i7.Usuario>()));
  gh.factory<_i8.InspeccionesRepository>(() => _i8.InspeccionesRepository(
      get<_i6.InspeccionesRemoteDataSource>(), get<_i4.Database>()));
  gh.factory<_i9.InternetConnectionChecker>(
      () => thirdPartyInjections.dataConnectionChecker);
  gh.factory<_i10.LoginControl>(() => _i10.LoginControl());
  gh.lazySingleton<_i11.NetworkInfo>(
      () => _i11.NetworkInfoImpl(get<_i9.InternetConnectionChecker>()));
  gh.factory<_i12.PlaneacionRepository>(() => _i12.PlaneacionRepository(
      get<_i6.InspeccionesRemoteDataSource>(), get<_i4.Database>()));
  await gh.factoryAsync<_i13.SharedPreferences>(
      () => sharedPreferencesInjectableModule.prefs,
      preResolve: true);
  gh.lazySingleton<_i14.LocalPreferencesDataSource>(() =>
      _i14.SharedPreferencesDataSourceImpl(get<_i13.SharedPreferences>()));
  gh.factory<_i15.UserRepository>(() => _i15.UserRepository(
      get<_i6.InspeccionesRemoteDataSource>(),
      get<_i14.LocalPreferencesDataSource>()));
  gh.factory<_i16.AuthBloc>(() => _i16.AuthBloc(get<_i15.UserRepository>()));
  gh.factory<_i17.SincronizacionCubit>(
      () => _i17.SincronizacionCubit(get<_i15.UserRepository>()));
  return get;
}

class _$ThirdPartyInjections extends _i18.ThirdPartyInjections {}

class _$RegisterModule extends _i19.RegisterModule {}

class _$DirectorioDeDatosInjection extends _i5.DirectorioDeDatosInjection {}

class _$SharedPreferencesInjectableModule
    extends _i20.SharedPreferencesInjectableModule {}
