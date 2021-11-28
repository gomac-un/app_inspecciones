import 'package:inspecciones/core/entities/app_image.dart';

abstract class Bloque {
  final String titulo;
  final String descripcion;
  final List<AppImage> fotosGuia;
  Bloque({
    required this.titulo,
    required this.descripcion,
    required this.fotosGuia,
  });
}
