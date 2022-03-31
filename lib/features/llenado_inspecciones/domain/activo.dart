import 'etiqueta.dart';

class Activo {
  final String pk;
  final String id;
  final List<Etiqueta> etiquetas;

  Activo({required this.pk, required this.id, required this.etiquetas});
}
