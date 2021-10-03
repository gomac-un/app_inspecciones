import '../bloque.dart';

class Titulo extends Bloque {
  Titulo({
    required String titulo,
    required String descripcion,
    required int nOrden,
  }) : super(titulo: titulo, descripcion: descripcion, nOrden: nOrden);
}
