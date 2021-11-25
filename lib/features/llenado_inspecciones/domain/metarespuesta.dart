import 'package:inspecciones/core/entities/app_image.dart';

class MetaRespuesta {
  final String observaciones;
  final List<AppImage> fotosBase;
  final bool reparada;
  final String observacionesReparacion;
  final List<AppImage> fotosReparacion;
  final DateTime? momentoRespuesta;
  final int? criticidadDelInspector;

  MetaRespuesta({
    this.observaciones = "",
    this.fotosBase = const [],
    this.reparada = false,
    this.observacionesReparacion = "",
    this.fotosReparacion = const [],
    this.momentoRespuesta,
    this.criticidadDelInspector,
  });

  MetaRespuesta.vacia() : this();

  MetaRespuesta copyWith({
    String? observaciones,
    List<AppImage>? fotosBase,
    bool? reparada,
    String? observacionesReparacion,
    List<AppImage>? fotosReparacion,
    DateTime? momentoRespuesta,
    int? criticidadDelInspector,
  }) {
    return MetaRespuesta(
      observaciones: observaciones ?? this.observaciones,
      fotosBase: fotosBase ?? this.fotosBase,
      reparada: reparada ?? this.reparada,
      observacionesReparacion:
          observacionesReparacion ?? this.observacionesReparacion,
      fotosReparacion: fotosReparacion ?? this.fotosReparacion,
      momentoRespuesta: momentoRespuesta ?? this.momentoRespuesta,
      criticidadDelInspector:
          criticidadDelInspector ?? this.criticidadDelInspector,
    );
  }
}
