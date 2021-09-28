import 'package:inspecciones/core/entities/app_image.dart';

class MetaRespuesta {
  final int criticidadInspector;
  final String observaciones;
  final List<AppImage> fotosBase;
  final bool reparada;
  final String observacionesReparacion;
  final List<AppImage> fotosReparacion;

  MetaRespuesta({
    this.criticidadInspector = 1,
    this.observaciones = "",
    this.fotosBase = const [],
    this.reparada = false,
    this.observacionesReparacion = "",
    this.fotosReparacion = const [],
  });

  MetaRespuesta.vacia() : this();
}
