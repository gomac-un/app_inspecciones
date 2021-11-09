import 'package:inspecciones/core/entities/app_image.dart';

import '../bloque.dart';
import '../etiqueta.dart';
import '../respuesta.dart';

export '../respuesta.dart';

class Pregunta<T extends Respuesta> extends Bloque {
  final String id;

  /// Es mutable para asignarla o reasignarla facilmente a la hora de guardar,
  /// aunque se debe pensar como hacer para que podamos ser inmutables, tal vez
  /// usando un copywith
  T? respuesta;
  final int criticidad;
  final List<Etiqueta> etiquetas;
  final bool calificable;

  Pregunta({
    required this.id,
    required String titulo,
    required String descripcion,
    required List<AppImage> fotosGuia,
    required this.criticidad,
    required this.etiquetas,
    required this.calificable,
    this.respuesta,
  }) : super(
          titulo: titulo,
          descripcion: descripcion,
          fotosGuia: fotosGuia,
        );
}
