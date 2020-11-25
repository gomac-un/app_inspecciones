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
  batch.insertAll(db.activos, [
    ActivosCompanion.insert(modelo: 'moto1t', identificador: '1'),
    ActivosCompanion.insert(modelo: 'automovil1', identificador: '2'),
    ActivosCompanion.insert(modelo: 'moto1t', identificador: '3'),
  ]);
  batch.insertAll(db.cuestionarios, [
    CuestionariosCompanion.insert(id: Value(1)),
    CuestionariosCompanion.insert(id: Value(2)),
    CuestionariosCompanion.insert(id: Value(3)),
  ]);

  batch.insertAll(db.contratistas, [
    ContratistasCompanion.insert(id: Value(1), nombre: "El mejor contratista"),
    ContratistasCompanion.insert(id: Value(2), nombre: "El otro contratista"),
  ]);

  batch.insertAll(db.sistemas, [
    SistemasCompanion.insert(id: Value(1), nombre: "carroceria"),
    SistemasCompanion.insert(id: Value(2), nombre: "motor"),
  ]);

  batch.insertAll(db.subSistemas, [
    SubSistemasCompanion.insert(nombre: "parachoques", sistemaId: 1),
    SubSistemasCompanion.insert(nombre: "pistones", sistemaId: 2),
  ]);

  batch.insertAll(db.cuestionarioDeModelos, [
    CuestionarioDeModelosCompanion.insert(
        modelo: 'moto1t',
        tipoDeInspeccion: "preoperacional",
        cuestionarioId: 1,
        periodicidad: 2,
        contratistaId: 1),
    CuestionarioDeModelosCompanion.insert(
        modelo: 'automovil1',
        tipoDeInspeccion: "preoperacional",
        cuestionarioId: 2,
        periodicidad: 4,
        contratistaId: 1),
    CuestionarioDeModelosCompanion.insert(
        modelo: 'automovil1',
        tipoDeInspeccion: "motor",
        cuestionarioId: 3,
        periodicidad: 5,
        contratistaId: 2)
  ]);

  batch.insertAll(db.inspecciones, [
    InspeccionesCompanion.insert(
        cuestionarioId: 1,
        estado: EstadoDeInspeccion.enBorrador,
        identificadorActivo: "1"),
    InspeccionesCompanion.insert(
        cuestionarioId: 2,
        estado: EstadoDeInspeccion.enBorrador,
        identificadorActivo: "2"),
  ]);

  batch.insertAll(db.bloques, [
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 1,
        titulo: "Inicio del cuestionario",
        descripcion: "prueba"),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 3,
        titulo: "estado del motor",
        descripcion: "en que estado se encuentra el motor"),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 2,
        titulo: "temperatura del motor",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 1,
        nOrden: 4,
        titulo: "estado de las ruedas",
        descripcion: ""),
    BloquesCompanion.insert(
        cuestionarioId: 2,
        nOrden: 1,
        titulo: "prueba del segundo",
        descripcion: "prueba"),
    BloquesCompanion.insert(
        cuestionarioId: 3,
        nOrden: 1,
        titulo: "cuestionario iniciado",
        descripcion: "prueba"),
  ]);

  batch.insertAll(db.preguntas, [
    PreguntasCompanion.insert(
      bloqueId: 2,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 1,
      opcionesDeRespuesta: Value(
        ["bueno", "malo"].map((e) => OpcionDeRespuesta(e, 0)).toList(),
      ),
      sistemaId: 1,
      subSistemaId: 1,
      posicion: "no aplica",
    ),
    PreguntasCompanion.insert(
      bloqueId: 3,
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 1,
      opcionesDeRespuesta: Value([
        OpcionDeRespuesta("alta", 4),
        OpcionDeRespuesta("baja", 0),
      ]),
      sistemaId: 2,
      subSistemaId: 2,
      posicion: "no aplica",
    ),
    PreguntasCompanion.insert(
      bloqueId: 4,
      tipo: TipoDePregunta.multipleRespuesta,
      criticidad: 1,
      opcionesDeRespuesta: Value(
        ["gastadas", "chuzadas", "desintegradas"]
            .map((e) => OpcionDeRespuesta(e, 0))
            .toList(),
      ),
      sistemaId: 2,
      subSistemaId: 2,
      posicion: "no aplica",
    ),
  ]);

  batch.insertAll(db.respuestas, [
    RespuestasCompanion.insert(
      inspeccionId: 1,
      preguntaId: 1,
      respuestas: Value([OpcionDeRespuesta("malo", 0)]),
      observacion: Value("ok"),
    ),
    RespuestasCompanion.insert(
      inspeccionId: 1,
      preguntaId: 2,
      respuestas: Value([OpcionDeRespuesta("alta", 4)]),
      observacion: Value("mal"),
      reparado: Value(true),
      observacionReparacion: Value("se cuadro"),
    ),
    RespuestasCompanion.insert(
      inspeccionId: 1,
      preguntaId: 3,
      respuestas: Value([OpcionDeRespuesta("gastadas", 0)]),
      observacion: Value("observacioncita"),
    ),
  ]);
}
