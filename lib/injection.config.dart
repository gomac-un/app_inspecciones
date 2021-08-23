// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i3;
import 'package:injectable/injectable.dart' as _i2;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i8;
import 'package:shared_preferences/shared_preferences.dart' as _i11;

import 'application/auth/auth_bloc.dart' as _i14;
import 'application/auth/usuario.dart' as _i7;
import 'application/creacion/creacion_form_controller_cubit.dart' as _i4;
import 'application/sincronizacion/sincronizacion_cubit.dart' as _i18;
import 'infrastructure/core/network_info.dart' as _i10;
import 'infrastructure/core/third_party_injections.dart' as _i22;
import 'infrastructure/database/mobile.dart' as _i24;
import 'infrastructure/datasources/injectable_module.dart' as _i23;
import 'infrastructure/datasources/local_preferences_datasource.dart' as _i12;
import 'infrastructure/datasources/remote_datasource.dart' as _i6;
import 'infrastructure/fotos_manager.dart' as _i5;
import 'infrastructure/moor_database.dart' as _i15;
import 'infrastructure/repositories/cuestionarios_repository.dart' as _i19;
import 'infrastructure/repositories/inspecciones_repository.dart' as _i16;
import 'infrastructure/repositories/planeacion_repository.dart' as _i17;
import 'infrastructure/repositories/user_repository.dart' as _i13;
import 'mvvc/creacion_form_controller.dart' as _i20;
import 'presentation/pages/login_page.dart' as _i9;
import 'viewmodel/cuestionario_list_view_model.dart'
    as _i21; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyInjections = _$ThirdPartyInjections();
  final directorioDeDatosInjection = _$DirectorioDeDatosInjection();
  final sharedPreferencesInjectableModule =
      _$SharedPreferencesInjectableModule();
  final databaseRegistrator = _$DatabaseRegistrator();
  gh.factory<_i3.Client>(() => thirdPartyInjections.client);
  gh.factoryParam<_i4.CreacionFormControllerCubit, int?, dynamic>(
      (cuestionarioId, _) => _i4.CreacionFormControllerCubit(cuestionarioId));
  await gh.factoryAsync<_i5.DirectorioDeDatos>(
      () => directorioDeDatosInjection.dirDatos,
      preResolve: true);
  gh.lazySingleton<_i6.InspeccionesRemoteDataSource>(
      () => _i6.DjangoJsonAPI(get<_i7.UsuarioOnline>()));
  gh.factory<_i8.InternetConnectionChecker>(
      () => thirdPartyInjections.internetConnectionChecker);
  gh.factory<_i9.LoginControl>(() => _i9.LoginControl());
  gh.lazySingleton<_i10.NetworkInfo>(
      () => _i10.NetworkInfoImpl(get<_i8.InternetConnectionChecker>()));
  await gh.factoryAsync<_i11.SharedPreferences>(
      () => sharedPreferencesInjectableModule.prefs,
      preResolve: true);
  gh.lazySingletonAsync<_i12.LocalPreferencesDataSource>(() async =>
      _i12.SharedPreferencesDataSourceImpl(
          await get.getAsync<_i11.SharedPreferences>()));
  gh.factoryAsync<_i13.UserRepository>(() async => _i13.UserRepository(
      get<_i6.InspeccionesRemoteDataSource>(),
      await get.getAsync<_i12.LocalPreferencesDataSource>()));
  gh.factoryAsync<_i14.AuthBloc>(
      () async => _i14.AuthBloc(await get.getAsync<_i13.UserRepository>()));
  gh.lazySingletonAsync<_i15.Database>(() async => databaseRegistrator
      .constructDb(await get.getAsync<_i12.LocalPreferencesDataSource>()));
  gh.factoryAsync<_i16.InspeccionesRepository>(() async =>
      _i16.InspeccionesRepository(get<_i6.InspeccionesRemoteDataSource>(),
          await get.getAsync<_i15.Database>()));
  gh.factoryAsync<_i17.PlaneacionRepository>(() async =>
      _i17.PlaneacionRepository(get<_i6.InspeccionesRemoteDataSource>(),
          await get.getAsync<_i15.Database>()));
  gh.factoryAsync<_i18.SincronizacionCubit>(() async =>
      _i18.SincronizacionCubit(await get.getAsync<_i13.UserRepository>()));
  gh.factoryAsync<_i19.CuestionariosRepository>(() async =>
      _i19.CuestionariosRepository(await get.getAsync<_i15.Database>(),
          get<_i6.InspeccionesRemoteDataSource>()));
  gh.factoryParamAsync<_i20.CreacionFormController, int?, dynamic>(
      (cuestionarioId, _) async => _i20.CreacionFormController.create(
          await get.getAsync<_i19.CuestionariosRepository>(), cuestionarioId));
  gh.factoryAsync<_i21.CuestionarioListViewModel>(() async =>
      _i21.CuestionarioListViewModel(
          await get.getAsync<_i19.CuestionariosRepository>()));
  return get;
}

class _$ThirdPartyInjections extends _i22.ThirdPartyInjections {}

class _$DirectorioDeDatosInjection extends _i5.DirectorioDeDatosInjection {}

class _$SharedPreferencesInjectableModule
    extends _i23.SharedPreferencesInjectableModule {}

class _$DatabaseRegistrator extends _i24.DatabaseRegistrator {}
