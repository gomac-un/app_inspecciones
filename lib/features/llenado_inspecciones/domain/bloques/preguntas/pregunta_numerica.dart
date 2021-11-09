import 'package:inspecciones/core/entities/app_image.dart';

import '../../etiqueta.dart';
import '../pregunta.dart';

class PreguntaNumerica extends Pregunta<RespuestaNumerica> {
  final List<RangoDeCriticidad> rangosDeCriticidad;
  final String unidades;
  PreguntaNumerica(
    this.rangosDeCriticidad,
    this.unidades, {
    required String id,
    required String titulo,
    required String descripcion,
    required List<AppImage> fotosGuia,
    required int criticidad,
    required List<Etiqueta> etiquetas,
    required bool calificable,
    RespuestaNumerica? respuesta,
  }) : super(
          id: id,
          respuesta: respuesta,
          titulo: titulo,
          descripcion: descripcion,
          fotosGuia: fotosGuia,
          criticidad: criticidad,
          etiquetas: etiquetas,
          calificable: calificable,
        );
}

class RangoDeCriticidad {
  final double inicio;
  final double fin;
  final int criticidad;

  RangoDeCriticidad(this.inicio, this.fin, this.criticidad);
}
