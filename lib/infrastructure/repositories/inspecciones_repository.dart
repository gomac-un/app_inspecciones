import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/core/network_info.dart';

@LazySingleton() //@LazySingleton(as: IInspeccionesRepository)
class InspeccionesRepository {
  //implements IInspeccionesRepository {
  final InspeccionesRemoteDataSource remoteDataSource;
  final Database localDataBase;
  final NetworkInfo networkInfo;

  InspeccionesRepository(
      {@required this.remoteDataSource,
      @required this.localDataBase,
      @required this.networkInfo});

  //llenado de inspecciones
  //TODO
  Future downloadOfflineData() async {
    if (await networkInfo.isConnected) {
      //var data = await remoteDataSource.getOfflineData();
      /* 
      traer
      activos
      Contratistas
      Sistemas
      SubSistemas

      Cuestionarios
      CuestionarioDeModelos
      Bloques
      Preguntas
      */
    }
  }
}
