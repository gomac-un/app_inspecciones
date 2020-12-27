part of 'sincronizacion_cubit.dart';
/*
@freezed
abstract class SincronizacionState with _$SincronizacionState {
  const factory SincronizacionState.cargando() = Cargando;
  const factory SincronizacionState.cargado(DateTime ultimaActualizacion) =
      Cargado;
  const factory SincronizacionState.descargandoServer(
      DateTime ultimaActualizacion, Task task) = DescargandoServer;
  const factory SincronizacionState.instalandoBD() = InstalandoBD;
}*/

enum SincronizacionStatus {
  inicial,
  cargando,
  cargado,
  descargandoServer,
  instalandoDB,
  exito,
}

@freezed
abstract class SincronizacionState with _$SincronizacionState {
  factory SincronizacionState({
    @Default(SincronizacionStatus.cargando) SincronizacionStatus status,
    DateTime ultimaActualizacion,
    Task task,
  }) = _SincronizacionState;
}
