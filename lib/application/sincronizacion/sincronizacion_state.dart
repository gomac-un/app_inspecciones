part of 'sincronizacion_cubit.dart';

@freezed
abstract class SincronizacionState with _$SincronizacionState {
  factory SincronizacionState({
    @Default(false) bool cargado,
    Task task,
    String info,
  }) = _SincronizacionState;
}
