import 'cuestionario.dart';
import 'inspeccion.dart';

/// Inspecciones empezadas a llenar localmente
class Borrador {
  final Inspeccion inspeccion;
  final Cuestionario cuestionario;

  /// [avance] y [totalPreguntas] son usados para mostrar el porcentaje de avance de la inspeccion en la UI
  /// Total de Preguntas respondidas (así estén incompletas, por ejemplo, que no tengan fotos o no estén reparadas)
  final int avance;

  /// Total de preguntas del cuestionario
  final int totalPreguntas;

  Borrador(
    this.inspeccion,
    this.cuestionario, {
    required this.avance,
    required this.totalPreguntas,
  });
}
