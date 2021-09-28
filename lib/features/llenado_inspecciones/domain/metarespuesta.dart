import 'package:dartz/dartz.dart';
import 'package:inspecciones/core/entities/app_image.dart';

class MetaRespuesta {
  final int criticidadInspector;
  final String observaciones;
  final bool reparada;
  final String observacionesReparacion;
  final IList<AppImage> fotosBase;
  final IList<AppImage> fotosReparacion;

  MetaRespuesta({
    this.criticidadInspector = 0,
    this.observaciones = "",
    this.reparada = false,
    this.observacionesReparacion = "",
    this.fotosBase = const Nil(),
    this.fotosReparacion = const Nil(),
  });

  MetaRespuesta.vacia() : this();
}
