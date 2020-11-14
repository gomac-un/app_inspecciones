// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:http/http.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'presentation/pages/borradores_screen.dart';
import 'infrastructure/moor_database_llenado.dart';
import 'infrastructure/local_datasource.dart';
import 'infrastructure/remote_datasource.dart';
import 'application/crear_cuestionario_form/llenar_cuestionario_form_bloc.dart';
import 'infrastructure/core/network_info.dart';
import 'infrastructure/database/mobile.dart';
import 'application/crear_cuestionario_form/seleccion_activo_inspeccion_bloc.dart';
import 'infrastructure/core/third_party_injections.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final thirdPartyInjections = _$ThirdPartyInjections();
  final registerModule = _$RegisterModule();
  gh.factory<Client>(() => thirdPartyInjections.client);
  gh.factory<DataConnectionChecker>(
      () => thirdPartyInjections.dataConnectionChecker);
  gh.lazySingleton<Database>(() => registerModule.constructDb());
  gh.lazySingleton<InspeccionesLocalDataSource>(
      () => InspeccionesLocalDataSourceImplSqlite());
  gh.lazySingleton<InspeccionesRemoteDataSource>(
      () => InspeccionesRemoteDataSourceImpl(client: get<Client>()));
  gh.factory<LlenarCuestionarioFormBloc>(
      () => LlenarCuestionarioFormBloc.sinborrador(get<Database>()));
  gh.lazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(get<DataConnectionChecker>()));
  gh.factory<SeleccionActivoInspeccionBloc>(
      () => SeleccionActivoInspeccionBloc(get<Database>()));
  gh.factory<BorradoresPage>(() => BorradoresPage(get<Database>()));
  return get;
}

class _$ThirdPartyInjections extends ThirdPartyInjections {}

class _$RegisterModule extends RegisterModule {}
