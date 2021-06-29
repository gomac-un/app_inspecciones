part of 'sincronizacion_cubit.dart';

@freezed
abstract class SincronizacionState with _$SincronizacionState {
  factory SincronizacionState({
    @Default(false) bool cargado,
    Task task,
    Map<int,String> info,
    int paso,
  }) = _SincronizacionState;
}
