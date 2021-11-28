import 'package:inspecciones/core/entities/app_image.dart';

class MetaRespuesta {
  final String observaciones;
  final List<AppImage> fotosBase;
  final bool reparada;
  final String observacionesReparacion;
  final List<AppImage> fotosReparacion;
  final DateTime? momentoRespuesta;
  final int? criticidadDelInspector;

  final int criticidadCalculada;
  final int criticidadCalculadaConReparaciones;

  MetaRespuesta({
    this.observaciones = "",
    this.fotosBase = const [],
    this.reparada = false,
    this.observacionesReparacion = "",
    this.fotosReparacion = const [],
    this.momentoRespuesta,
    this.criticidadDelInspector,
    this.criticidadCalculada = 0,
    this.criticidadCalculadaConReparaciones = 0,
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
