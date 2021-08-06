part of 'sincronizacion_cubit.dart';

@freezed
class SincronizacionState with _$SincronizacionState {
  factory SincronizacionState({
    @Default(false) bool cargado,
    required Task task,

    /// lista que guarda las novedades en un String por cada paso de la sincronización.
    required List info,

    /// Etapa de la sincronización: 1-Descarga de cuestionarios, 2- Instalación de la Bd,
    ///  3- Descarga de fotos y 4- Sincronización finalizada.
    required int paso,
  }) = _SincronizacionState;
}
