import 'package:freezed_annotation/freezed_annotation.dart';

part 'inspecciones_failure.freezed.dart';

@freezed
class InspeccionesFailure with _$InspeccionesFailure {
  const factory InspeccionesFailure.noHayInternet() = _NoHayInternet;
  const factory InspeccionesFailure.noHayConexionAlServidor() =
      _NoHayConexionAlServidor;
  const factory InspeccionesFailure.noTienePermisos(Object exception) =
      _NoTienePermisos;
  const factory InspeccionesFailure.activoInvalido() = _ActivoInvalido;
  const factory InspeccionesFailure.unexpectedError(Object exception) =
      _UnexpectedError;
  const factory InspeccionesFailure.errorDatabase(Object exception) =
      _ErrorDatabase;
}
