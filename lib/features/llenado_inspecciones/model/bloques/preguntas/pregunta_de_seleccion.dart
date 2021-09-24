import 'opcion_de_respuesta.dart';
import '../pregunta.dart';

abstract class PreguntaDeSeleccion extends Pregunta {
  late final List<OpcionDeRespuesta> opcionesDeRespuesta;
}
