import 'package:inspecciones/core/entities/app_image.dart';

import '../bloque.dart';

class Titulo extends Bloque {
  Titulo({
    required String titulo,
    required String descripcion,
    required List<AppImage> fotosGuia,
  }) : super(
          titulo: titulo,
          descripcion: descripcion,
          fotosGuia: fotosGuia,
        );
}
