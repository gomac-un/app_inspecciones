import '../pregunta.dart';

class PreguntaNumerica extends Pregunta<RespuestaNumerica> {
  final List<RangoDeCriticidad> rangosDeCriticidad;
  final String unidades;
  PreguntaNumerica(
    this.rangosDeCriticidad, {
    required String titulo,
    required String descripcion,
    required int criticidad,
    required String posicion,
    required bool calificable,
    RespuestaNumerica? respuesta,
    required this.unidades,
  }) : super(
          respuesta: respuesta,
          titulo: titulo,
          descripcion: descripcion,
          criticidad: criticidad,
          posicion: posicion,
          calificable: calificable,
        );
}

class RangoDeCriticidad {
  final int inicio;
  final int fin;
  final int criticidad;

  RangoDeCriticidad(this.inicio, this.fin, this.criticidad);
}
