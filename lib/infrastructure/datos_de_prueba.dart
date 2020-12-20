part of 'moor_database.dart';

/* otra posible forma del closure
Function initialize(db) {
  return (batch) => (Batch batch, db) {
        batch.insertAll(db.activos, [
          ...*/

dynamic Function(Batch) initialize(Database db) {
  return (Batch batch) => _initialize(batch, db);
}

dynamic _initialize(Batch batch, Database db) {
  batch.insertAll(db.activos, [
    ActivosCompanion.insert(modelo: 'DT-Kenworth', identificador: '1'),
    ActivosCompanion.insert(modelo: 'sencillo-Kenworth', identificador: '2'),
  ]);

  batch.insertAll(db.contratistas, [
    ContratistasCompanion.insert(
        id: const Value(1), nombre: "El mejor contratista"),
    ContratistasCompanion.insert(
        id: const Value(2), nombre: "El otro contratista"),
  ]);

  batch.insertAll(db.sistemas, [
    SistemasCompanion.insert(id: const Value(1), nombre: "Estructura"),
    SistemasCompanion.insert(id: const Value(2), nombre: "Transmisión"),
    SistemasCompanion.insert(id: const Value(3), nombre: "Eléctrico"),
    SistemasCompanion.insert(id: const Value(4), nombre: "Frenos"),
    SistemasCompanion.insert(id: const Value(5), nombre: "Hidráulico"),
    SistemasCompanion.insert(id: const Value(6), nombre: "Motor"),
    SistemasCompanion.insert(id: const Value(7), nombre: "No aplica"),
  ]);

  batch.insertAll(db.subSistemas, [
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 1),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 2),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 3),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 4),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 5),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 6),
    SubSistemasCompanion.insert(nombre: "n/s", sistemaId: 7),
  ]);
  //Inicio de una inspeccion de prueba
  //Datos de la inspeccion
  batch.insertAll(db.cuestionarios, [
    CuestionariosCompanion.insert(),
  ]);
  batch.insertAll(db.cuestionarioDeModelos, [
    CuestionarioDeModelosCompanion.insert(
        modelo: 'DT-Kenworth',
        tipoDeInspeccion: "preoperacional",
        periodicidad: 100,
        cuestionarioId: 1,
        contratistaId: 1)
  ]);
  batch.insertAll(db.bloques, [
    BloquesCompanion.insert(cuestionarioId: 1, nOrden: 0),
    BloquesCompanion.insert(cuestionarioId: 1, nOrden: 1),
    BloquesCompanion.insert(cuestionarioId: 1, nOrden: 2),
    BloquesCompanion.insert(cuestionarioId: 1, nOrden: 3),
  ]);
  //Un bloque de cada tipo
  //Un titulo
  batch.insertAll(db.titulos, [
    TitulosCompanion.insert(
        bloqueId: 1,
        titulo: "Motor y dirección DT Kenworth",
        descripcion:
            "Inspeccionar el estado de cada parte en mención y evaluar su funcionamiento."),
  ]);
  //Una pregunta de seleccion unica
  batch.insert(
      db.preguntas,
      PreguntasCompanion.insert(
        bloqueId: 2,
        titulo: "Estado del restrictor del aire",
        descripcion: "",
        sistemaId: 6,
        subSistemaId: 6,
        posicion: "no aplica",
        tipo: TipoDePregunta.unicaRespuesta,
        criticidad: 3,
        parteDeCuadricula: false,
      ));
  batch.insertAll(db.opcionesDeRespuesta, [
    OpcionesDeRespuestaCompanion.insert(
        preguntaId: const Value(1),
        texto: "Indica cambio de filtro",
        criticidad: 2),
    OpcionesDeRespuestaCompanion.insert(
        preguntaId: const Value(1), texto: "No lo posee", criticidad: 0),
    OpcionesDeRespuestaCompanion.insert(
        preguntaId: const Value(1), texto: "Mal estado", criticidad: 4),
    OpcionesDeRespuestaCompanion.insert(
        preguntaId: const Value(1), texto: "Sin novedad", criticidad: 0),
  ]);
  //Una pregunta de seleccion multiple
  batch.insert(
      db.preguntas,
      PreguntasCompanion.insert(
        bloqueId: 3,
        titulo: "Estado aceite lubricante",
        descripcion: "",
        sistemaId: 6,
        subSistemaId: 6,
        posicion: "no aplica",
        tipo: TipoDePregunta.multipleRespuesta,
        criticidad: 3,
        parteDeCuadricula: false,
      ));
  batch.insertAll(db.opcionesDeRespuesta, [
    OpcionesDeRespuestaCompanion.insert(
        preguntaId: const Value(2), texto: "Condicion normal", criticidad: 0),
    OpcionesDeRespuestaCompanion.insert(
        preguntaId: const Value(2),
        texto: "Posible dilucion por combustible",
        criticidad: 3),
    OpcionesDeRespuestaCompanion.insert(
        preguntaId: const Value(2), texto: "Color lechoso", criticidad: 3),
    OpcionesDeRespuestaCompanion.insert(
        preguntaId: const Value(2),
        texto: "Presencia de particulas extrañas",
        criticidad: 3),
  ]);
  //Una cuadricula de preguntas
  batch.insert(
      db.cuadriculasDePreguntas,
      CuadriculasDePreguntasCompanion.insert(
        bloqueId: 4,
        titulo: "Fugas en el motor",
        descripcion: "",
      ));
  //Las preguntas de la cuadricula
  batch.insertAll(db.preguntas, [
    PreguntasCompanion.insert(
      bloqueId: 4,
      titulo: "Fugas/estado en mangueras",
      descripcion: "",
      sistemaId: 6,
      subSistemaId: 6,
      posicion: "n/a",
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 3,
      parteDeCuadricula: true,
    ),
    PreguntasCompanion.insert(
      bloqueId: 4,
      titulo: "Fugas en base del filtro de aceite",
      descripcion: "",
      sistemaId: 6,
      subSistemaId: 6,
      posicion: "n/a",
      tipo: TipoDePregunta.unicaRespuesta,
      criticidad: 3,
      parteDeCuadricula: true,
    ),
  ]);
  //Las respuestas de la cuadricula
  batch.insertAll(db.opcionesDeRespuesta, [
    OpcionesDeRespuestaCompanion.insert(
        texto: "requiere intervencion",
        criticidad: 4,
        cuadriculaId: const Value(1)),
    OpcionesDeRespuestaCompanion.insert(
        texto: "sin novedad", criticidad: 0, cuadriculaId: const Value(1)),
  ]);
}