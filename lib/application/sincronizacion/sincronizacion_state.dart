part of 'sincronizacion_cubit.dart';

@freezed
abstract class SincronizacionState with _$SincronizacionState {
  factory SincronizacionState({
    @Default(false) bool cargado,
    Task task,

    /// Diccionario que guarda las novedades en un String por cada paso de la sincronización.
    Map<int, String> info,

    /// Etapa de la sincronización: 1-Descarga de cuestionarios, 2- Instalación de la Bd,
    ///  3- Descarga de fotos y 4- Sincronización finalizada.
    int paso,
  }) = _SincronizacionState;
}
