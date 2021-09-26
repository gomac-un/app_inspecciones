import 'bloques/preguntas/opcion_de_respuesta.dart';
import 'metarespuesta.dart';

abstract class Respuesta {
  final MetaRespuesta metaRespuesta;

  Respuesta(this.metaRespuesta);
}

class RespuestaDeSeleccionUnica extends Respuesta {
  final OpcionDeRespuesta? opcionSeleccionada;

  RespuestaDeSeleccionUnica(
      MetaRespuesta metaRespuesta, this.opcionSeleccionada)
      : super(metaRespuesta);
}

class RespuestaNumerica extends Respuesta {
  final double? respuestaNumerica;

  RespuestaNumerica(MetaRespuesta metaRespuesta, {this.respuestaNumerica})
      : super(metaRespuesta);
}

class RespuestaDeSeleccionMultiple extends Respuesta {
  // no es List<OpcionDeRespuesta> debido a que se requiere guardar MetaRespuesta por cada opción seleccionada
  // Solo se agregan al guardar un cuestionario, al cargarlo no se necesitan aqui
  final List<SubRespuestaDeSeleccionMultiple> opciones;

  RespuestaDeSeleccionMultiple(MetaRespuesta metaRespuesta,
      [this.opciones = const []])
      : super(metaRespuesta);
}

class SubRespuestaDeSeleccionMultiple extends Respuesta {
  final bool estaSeleccionada;

  SubRespuestaDeSeleccionMultiple(MetaRespuesta metaRespuesta,
      {required this.estaSeleccionada})
      : super(metaRespuesta);
}

class RespuestaDeCuadricula<T extends Respuesta> extends Respuesta {
  // Solo se agregan al guardar un cuestionario, al cargarlo no se necesitan aqui
  final List<T> respuestas;

  RespuestaDeCuadricula(MetaRespuesta metaRespuesta,
      [this.respuestas = const []])
      : super(metaRespuesta);
}

typedef RespuestaDeCuadriculaDeSeleccionUnica
    = RespuestaDeCuadricula<RespuestaDeSeleccionUnica>;

typedef RespuestaDeCuadriculaDeSeleccionMultiple
    = RespuestaDeCuadricula<RespuestaDeSeleccionMultiple>;
