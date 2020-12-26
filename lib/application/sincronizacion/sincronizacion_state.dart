part of 'sincronizacion_bloc.dart';

@freezed
abstract class SincronizacionState with _$SincronizacionState {
  const factory SincronizacionState.cargando() = Cargando;
  const factory SincronizacionState.cargado(DateTime ultimaActualizacion) =
      Cargado;
  const factory SincronizacionState.descargandoServer(
      DateTime ultimaActualizacion, Task task) = DescargandoServer;
  const factory SincronizacionState.instalandoBD() = InstalandoBD;
}
