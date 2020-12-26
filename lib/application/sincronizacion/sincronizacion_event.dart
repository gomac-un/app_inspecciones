part of 'sincronizacion_bloc.dart';

@freezed
abstract class SincronizacionEvent with _$SincronizacionEvent {
  const factory SincronizacionEvent.inicializar() = _Inicializar;
  const factory SincronizacionEvent.descargarServer() = _DescargarServer;
  const factory SincronizacionEvent.instalarBD() = _InstalarBD;
}
