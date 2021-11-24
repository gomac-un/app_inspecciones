import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';

import 'drift_database.dart';

/// Serializer usado al invocar [.toJson()] o [fromJson()] que maneja los enum de tipoPregunta y estado de inspeccion y cuestionario.
/// También maneja las fechas y las fotos.
class CustomSerializer extends ValueSerializer {
  const CustomSerializer();
  static const tipoPreguntaConverter =
      EnumIndexConverter<TipoDePregunta>(TipoDePregunta.values);
  static const estadoDeInspeccionConverter =
      EnumIndexConverter<EstadoDeInspeccion>(EstadoDeInspeccion.values);
  static const estadoDeCuestionarioConverter =
      EnumIndexConverter<EstadoDeCuestionario>(EstadoDeCuestionario.values);

  @override
  T fromJson<T>(dynamic json) {
    if (json == null) {
      return null as T;
    }

    /// TODO: revisar si aca pueden llegar imagenes de web
    if (T == ListImages) {
      return IList.from(json as List).map((path) =>
          (path as String).startsWith('http')
              ? AppImage.remote(path)
              : AppImage.mobile(path)) as T;
    } /*
    if (json is List) {
      // https://stackoverflow.com/questions/50188729/checking-what-type-is-passed-into-a-generic-method
      // machetazo que convierte todas las listas a IListString dado que no
      // se puede preguntar por T == IListString, puede que se pueda arreglar
      // cuando los de dart implementen los alias de tipos https://github.com/dart-lang/language/issues/65
      return IList.from(json.cast<String>()) as T;
    }*/

    if (T == TipoDePregunta) {
      return tipoPreguntaConverter.mapToDart(json as int) as T;
    }

    if (T == EstadoDeInspeccion) {
      return estadoDeInspeccionConverter.mapToDart(json as int) as T;
    }

    if (T == EstadoDeCuestionario) {
      return estadoDeCuestionarioConverter.mapToDart(json as int) as T;
    }

    if (T == DateTime) {
      return DateTime.parse(json as String) as T;
    }

    if (T == double && json is int) {
      return json.toDouble() as T;
    }

    // blobs are encoded as a regular json array, so we manually convert that to
    // a Uint8List
    if (T == Uint8List && json is! Uint8List) {
      final asList = (json as List).cast<int>();
      return Uint8List.fromList(asList) as T;
    }

    return json as T;
  }

  @override
  dynamic toJson<T>(T value) {
    if (value is DateTime) {
      return value.toIso8601String();
    }

    if (value is TipoDePregunta) {
      return tipoPreguntaConverter.mapToSql(value);
    }

    if (value is EstadoDeInspeccion) {
      return estadoDeInspeccionConverter.mapToSql(value);
    }

    if (value is EstadoDeCuestionario) {
      return estadoDeCuestionarioConverter.mapToSql(value);
    }

    if (value is ListImages) {
      return value.map((a) => a.when(remote: id, mobile: id, web: id)).toList();
    }

    if (value is IList) {
      return value.toList();
    }

    return value;
  }
}
