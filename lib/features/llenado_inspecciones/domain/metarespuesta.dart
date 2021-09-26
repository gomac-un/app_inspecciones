class MetaRespuesta {
  final int criticidadInspector;
  final String observaciones;
  final bool reparada;
  final String observacionesReparacion;

  MetaRespuesta({
    this.criticidadInspector = 0,
    this.observaciones = "",
    this.reparada = false,
    this.observacionesReparacion = "",
  });

  MetaRespuesta.vacia() : this();
}
