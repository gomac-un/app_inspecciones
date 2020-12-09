part of 'moor_database.dart';

/* otra posible forma del closure
Function initialize(db) {
  return (batch) => (Batch batch, db) {
        batch.insertAll(db.activos, [
          ...*/

Function initialize(db) {
  return (batch) {
    return _initialize0(batch, db);
  };
}

void _initialize0(Batch batch, db) {
  /*
  batch.insertAll(db.activos, [
    ActivosCompanion.insert(modelo: 'DT-Kenworth', identificador: '1'),
    ActivosCompanion.insert(modelo: 'sencillo-Kenworth', identificador: '2'),
  ]);
  batch.insertAll(db.cuestionarios, [
    CuestionariosCompanion.insert(id: Value(1)),
    CuestionariosCompanion.insert(id: Value(2)),
  ]);

  batch.insertAll(db.contratistas, [
    ContratistasCompanion.insert(id: Value(1), nombre: "El mejor contratista"),
    ContratistasCompanion.insert(id: Value(2), nombre: "El otro contratista"),
  ]);

  batch.insertAll(db.sistemas, [
    SistemasCompanion.insert(id: Value(1), nombre: "Estructura"),
    SistemasCompanion.insert(id: Value(2), nombre: "Transmisión"),
    SistemasCompanion.insert(id: Value(3), nombre: "Eléctrico"),
    SistemasCompanion.insert(id: Value(4), nombre: "Frenos"),
    SistemasCompanion.insert(id: Value(5), nombre: "Hidráulico"),
    SistemasCompanion.insert(id: Value(6), nombre: "No aplica"),
  ]);

  batch.insertAll(db.subSistemas, [
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 1),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 2),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 3),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 4),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 5),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 6),
  ]);

  batch.insertAll(db.cuestionarioDeModelos, [
    CuestionarioDeModelosCompanion.insert(
        modelo: 'DT-Kenworth',
        tipoDeInspeccion: "preoperacional",
        cuestionarioId: 1,
        periodicidad: 100,
        contratistaId: 1),
    CuestionarioDeModelosCompanion.insert(
        modelo: 'sencillo-Kenworth',
        tipoDeInspeccion: "preoperacional",
        cuestionarioId: 2,
        periodicidad: 100,
        contratistaId: 2),
  ]);

  batch.insertAll(db.bloques, [
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 1,
        titulo: "Parte delantera del vehículo DT Kenworth",
        descripcion:
            "Inspeccionar el estado de cada parte en mención y evaluar su funcionamiento."),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 2,
        titulo: "Silla del conductor",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 3,
        titulo: "Silla del tripulante",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 4,
        titulo: "Palanca de cambios",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 5,
        titulo: "Mando de la transmisión (Pera fuller)",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 6,
        titulo:
            "Eléctrico: Accionamiento/Estado limpia parabrisas (todas las velocidades)",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 7,
        titulo: "Estructura: Vidrios",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 8,
        titulo: "Estructura: Eleva vidrios",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 9,
        titulo: "Estructura: Retrovisores",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 10,
        titulo: "Eléctrico: Luces estacionarias",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1, nOrden: 11, titulo: "SOAT", descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 12,
        titulo: "Tecnico mecánica",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1, nOrden: 13, titulo: "Matrícula", descripcion: ""),
  ]);

  batch.insertAll(db.preguntas, [
    PreguntasCompanion.insert(
      bloqueId: 2,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 1,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Sin novedad", 0),
          OpcionDeRespuesta("Requiere intervención", 4),
        ],
      ),
      sistemaId: 1,
      subSistemaId: 1,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 3,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 1,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Sin novedad", 0),
          OpcionDeRespuesta("Requiere intervención", 4),
        ],
      ),
      sistemaId: 1,
      subSistemaId: 1,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 4,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 3,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Sin novedad", 0),
          OpcionDeRespuesta("Requiere intervención", 4),
        ],
      ),
      sistemaId: 2,
      subSistemaId: 2,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 5,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 3,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Sin novedad", 0),
          OpcionDeRespuesta("Requiere intervención", 4),
        ],
      ),
      sistemaId: 2,
      subSistemaId: 2,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 6,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 3,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Sin novedad", 0),
          OpcionDeRespuesta("Requiere intervención", 4),
        ],
      ),
      sistemaId: 3,
      subSistemaId: 3,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 7,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 3,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Sin novedad", 0),
          OpcionDeRespuesta("Requiere intervención", 4),
        ],
      ),
      sistemaId: 1,
      subSistemaId: 1,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 8,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 3,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Sin novedad", 0),
          OpcionDeRespuesta("Requiere intervención", 4),
        ],
      ),
      sistemaId: 1,
      subSistemaId: 1,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 9,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 3,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Sin novedad", 0),
          OpcionDeRespuesta("Requiere intervención", 4),
        ],
      ),
      sistemaId: 1,
      subSistemaId: 1,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 10,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 3,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Sin novedad", 0),
          OpcionDeRespuesta("Requiere intervención", 4),
        ],
      ),
      sistemaId: 3,
      subSistemaId: 3,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 11,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 4,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Vigente", 0),
          OpcionDeRespuesta("No está", 4),
        ],
      ),
      sistemaId: 5,
      subSistemaId: 5,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 12,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 4,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Vigente", 0),
          OpcionDeRespuesta("No está", 4),
        ],
      ),
      sistemaId: 5,
      subSistemaId: 5,
      posicion: "Parte delantera",
    ),
    PreguntasCompanion.insert(
      bloqueId: 13,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 4,
      opcionesDeRespuesta: Value(
        [
          OpcionDeRespuesta("Vigente", 0),
          OpcionDeRespuesta("No está", 4),
        ],
      ),
      sistemaId: 5,
      subSistemaId: 5,
      posicion: "Parte delantera",
    ),
  ]);*/
}
