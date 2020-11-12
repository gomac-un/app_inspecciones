import 'package:injectable/injectable.dart';
import 'package:inspecciones/infrastructure/local_datasource.dart';
import 'package:inspecciones/infrastructure/remote_datasource.dart';
import 'package:meta/meta.dart';

import 'package:inspecciones/core/error/failures.dart';
import 'package:inspecciones/domain/core/i_inspecciones_repository.dart';
import 'package:inspecciones/infrastructure/core/network_info.dart';

//@LazySingleton(as: IInspeccionesRepository)
/*class InspeccionesRepository implements IInspeccionesRepository {
  final InspeccionesRemoteDataSource remoteDataSource;
  final InspeccionesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  InspeccionesRepository(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});
  //creacion de cuestionarios
  getTiposDeInspecciones(String filtro) async {
    return await Future.delayed(
      const Duration(seconds: 0),
      () => [
        if (filtro == '123') 'Preoperacional',
        if (filtro == '456') 'Fugas lixiviado',
        'Prueba velocímetro',
        if (filtro == 'creacion') 'otra',
      ].asMap().entries.map((e) => IdYNombre(e.key, e.value)).toList(),
    );
  }

  getModelos() async {
    return await Future.delayed(
      const Duration(seconds: 0),
      () => [
        'doble troque',
        'moto',
        'van',
      ].asMap().entries.map((e) => IdYNombre(e.key, e.value)).toList(),
    );
  }

  getContratistas() async {
    return await Future.delayed(
      const Duration(seconds: 0),
      () => [
        'el mejor contratista',
        'el super contratista',
        'el otro contratista',
      ].asMap().entries.map((e) => IdYNombre(e.key, e.value)).toList(),
    );
  }

  getSistemas() async {
    return await Future.delayed(
      const Duration(seconds: 0),
      () => ['carroceria', 'direccion', 'motor']
          .asMap()
          .entries
          .map((e) => IdYNombre(e.key, e.value))
          .toList(),
    );
  }

  getSubSistemas(IdYNombre sistema) async {
    return await Future.delayed(
      const Duration(seconds: 0),
      () => ['sub1', 'sub2', 'sub3']
          .asMap()
          .entries
          .map((e) => IdYNombre(e.key, sistema.nombre + e.value))
          .toList(),
    );
  }

  //llenado de inspecciones
  //TODO
  downloadOfflineData() async {
    if (await networkInfo.isConnected) {
      //var data = await remoteDataSource.getOfflineData();

    }
  }

  getModeloDeVehiculo(String vehiculo) async {
    //TODO
  }

  getBloquesDeCuestionario(String vehiculo, IdYNombre tipoDeInspeccion) async {
    return await Future.delayed(
      const Duration(seconds: 0),
      () => [
        Bloque(titulo: "Frente", descripcion: "parte frontal"),
        Pregunta(
            titulo: "Tipo de daño",
            descripcion: "Explicación de la pregunta",
            tipo: TipoDePregunta.unicaRespuesta,
            opcionesDeRespuesta: [
              'Rotura',
              'Quebradura',
              'Desaparicion',
              'Otra'
            ].map((e) => Respuesta(texto: e)).toList())
      ],
    );
  }
}
*/
