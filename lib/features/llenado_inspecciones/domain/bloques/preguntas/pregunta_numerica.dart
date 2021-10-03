import '../pregunta.dart';

class PreguntaNumerica extends Pregunta<RespuestaNumerica> {
  final List<RangoDeCriticidad> rangosDeCriticidad;
  final String unidades;
  PreguntaNumerica(
    this.rangosDeCriticidad, {
    required int id,
    required String titulo,
    required String descripcion,
    required int nOrden,
    required int criticidad,
    required String posicion,
    required bool calificable,
    RespuestaNumerica? respuesta,
    required this.unidades,
  }) : super(
            id: id,
            respuesta: respuesta,
            titulo: titulo,
            descripcion: descripcion,
            criticidad: criticidad,
            posicion: posicion,
            calificable: calificable,
            nOrden: nOrden);
}

class RangoDeCriticidad {
  final double inicio;
  final double fin;
  final int criticidad;

  RangoDeCriticidad(this.inicio, this.fin, this.criticidad);
}
