class OpcionDeRespuesta {
  final String id;
  final String titulo;
  final String descripcion;
  final int criticidad;
  final bool requiereCriticidadDelInspector;

  OpcionDeRespuesta({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.criticidad,
    required this.requiereCriticidadDelInspector,
  });
}
