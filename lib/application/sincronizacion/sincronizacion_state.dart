part of 'sincronizacion_cubit.dart';

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
