import 'cuestionario.dart';

class Inspeccion {
  final int id;
  final EstadoDeInspeccion estado;
  final String activo;
  //inspector //TODO: agregarle el dato del inspector que la esta haciendo

  late final CuestionarioInspeccionado cuestionario;

  Inspeccion({
    required this.id,
    required this.estado,
    required this.activo,
  });
}

enum EstadoDeInspeccion {
  borrador,
  enReparacion,
  finalizada,
}
