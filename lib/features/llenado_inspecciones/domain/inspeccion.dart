import 'cuestionario.dart';
import 'modelos.dart';

class Inspeccion {
  final int id;
  final EstadoDeInspeccion estado;
  final Activo activo;
  final DateTime? momentoBorradorGuardado;

  final int criticidadTotal;
  final int criticidadReparacion;
  final bool esNueva;
  //inspector //TODO: agregarle el dato del inspector que la esta haciendo

  late final CuestionarioInspeccionado cuestionario;

  Inspeccion({
    required this.id,
    required this.estado,
    required this.activo,
    this.momentoBorradorGuardado,
    required this.criticidadTotal,
    required this.criticidadReparacion,
    required this.esNueva,
  });
}

enum EstadoDeInspeccion {
  borrador,
  enReparacion,
  finalizada,
}
