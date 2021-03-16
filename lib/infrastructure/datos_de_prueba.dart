part of 'moor_database.dart';
/* otra posible forma del closure
Function initialize(db) {
  return (batch) => (Batch batch, db) {
        batch.insertAll(db.activos, [
          ...*/

dynamic Function(Batch) initialize(Database db) {
  return (Batch batch) => _initialize(batch, db);
}

Future<void> _initialize(Batch batch, Database db) async {
  batch.insertAll(db.activos, [
    ActivosCompanion.insert(modelo: 'DT-Kenworth', id: const Value(1)),
    ActivosCompanion.insert(modelo: 'sencillo-Kenworth', id: const Value(2)),
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

/*
  final ap.DjangoAPI tabla = ap.DjangoAPI();
  //final List<Insertable<Sistema>> listaSistemas = [];

  batch.insertAll(db.contratistas, listaContratistas);

  final List<Insertable<Sistema>> listaSistemas = sistemas
      .map((item) =>
          SistemasCompanion.insert(id: Value(item.id), nombre: item.nombre))
      .toList();

  batch.insertAll(db.sistemas, listaSistemas);
*/
  batch.insertAll(db.subSistemas, [
    SubSistemasCompanion.insert(
        id: const Value(1), nombre: "n/s", sistemaId: 1),
    SubSistemasCompanion.insert(
        id: const Value(2), nombre: "n/s", sistemaId: 2),
    SubSistemasCompanion.insert(
        id: const Value(3), nombre: "n/s", sistemaId: 3),
    SubSistemasCompanion.insert(
        id: const Value(4), nombre: "n/s", sistemaId: 4),
    SubSistemasCompanion.insert(
        id: const Value(5), nombre: "n/s", sistemaId: 5),
    SubSistemasCompanion.insert(
        id: const Value(6), nombre: "n/s", sistemaId: 6),
    SubSistemasCompanion.insert(
        id: const Value(7), nombre: "n/s", sistemaId: 7),
  ]);
  //Inicio de una inspeccion de prueba
  //Datos de la inspeccion
  batch.insertAll(db.cuestionarios, [
    CuestionariosCompanion.insert(
      id: const Value(1),
      tipoDeInspeccion: "preoperacional",
    ),
  ]);
  batch.insertAll(db.cuestionarioDeModelos, [
    CuestionarioDeModelosCompanion.insert(
        modelo: 'DT-Kenworth',
        periodicidad: 100,
        cuestionarioId: 1,
        contratistaId: const Value(1))
  ]);
  batch.insertAll(db.bloques, [
    BloquesCompanion.insert(id: const Value(1), cuestionarioId: 1, nOrden: 0),
    BloquesCompanion.insert(id: const Value(2), cuestionarioId: 1, nOrden: 1),
    BloquesCompanion.insert(id: const Value(3), cuestionarioId: 1, nOrden: 2),
    BloquesCompanion.insert(id: const Value(4), cuestionarioId: 1, nOrden: 3),
  ]);
  //Un bloque de cada tipo
  //Un titulo
  batch.insertAll(db.titulos, [
    TitulosCompanion.insert(
        id: const Value(1),
        bloqueId: 1,
        titulo: "Motor y dirección DT Kenworth",
        descripcion:
            "Inspeccionar el estado de cada parte en mención y evaluar su funcionamiento."),
  ]);
  //Una pregunta de seleccion unica
  batch.insert(
      db.preguntas,
      PreguntasCompanion.insert(
        id: const Value(1),
        bloqueId: 2,
        titulo: "Estado del restrictor del aire",
        descripcion: "",
        sistemaId: const Value(6),
        subSistemaId: const Value(6),
        posicion: const Value("no aplica"),
        tipo: TipoDePregunta.unicaRespuesta,
        criticidad: 3,
      ));
  batch.insertAll(db.opcionesDeRespuesta, [
    OpcionesDeRespuestaCompanion.insert(
        id: const Value(1),
        preguntaId: const Value(1),
        texto: "Indica cambio de filtro",
        criticidad: 2),
    OpcionesDeRespuestaCompanion.insert(
        id: const Value(2),
        preguntaId: const Value(1),
        texto: "No lo posee",
        criticidad: 0),
    OpcionesDeRespuestaCompanion.insert(
        id: const Value(3),
        preguntaId: const Value(1),
        texto: "Mal estado",
        criticidad: 4),
    OpcionesDeRespuestaCompanion.insert(
        id: const Value(4),
        preguntaId: const Value(1),
        texto: "Sin novedad",
        criticidad: 0),
  ]);
  //Una pregunta de seleccion multiple
  batch.insert(
      db.preguntas,
      PreguntasCompanion.insert(
        id: const Value(2),
        bloqueId: 3,
        titulo: "Estado aceite lubricante",
        descripcion: "",
        sistemaId: const Value(6),
        subSistemaId: const Value(6),
        posicion: const Value("no aplica"),
        tipo: TipoDePregunta.multipleRespuesta,
        criticidad: 3,
      ));
  batch.insertAll(db.opcionesDeRespuesta, [
    OpcionesDeRespuestaCompanion.insert(
        id: const Value(5),
        preguntaId: const Value(2),
        texto: "Condicion normal",
        criticidad: 0),
    OpcionesDeRespuestaCompanion.insert(
        id: const Value(6),
        preguntaId: const Value(2),
        texto: "Posible dilucion por combustible",
        criticidad: 3),
    OpcionesDeRespuestaCompanion.insert(
        id: const Value(7),
        preguntaId: const Value(2),
        texto: "Color lechoso",
        criticidad: 3),
    OpcionesDeRespuestaCompanion.insert(
        id: const Value(8),
        preguntaId: const Value(2),
        texto: "Presencia de particulas extrañas",
        criticidad: 3),
  ]);
  //Una cuadricula de preguntas
  batch.insert(
      db.cuadriculasDePreguntas,
      CuadriculasDePreguntasCompanion.insert(
        id: const Value(1),
        bloqueId: 4,
        titulo: "Fugas en el motor",
        descripcion: "",
      ));
  //Las preguntas de la cuadricula
  batch.insertAll(db.preguntas, [
    PreguntasCompanion.insert(
      id: const Value(3),
      bloqueId: 4,
      titulo: "Fugas/estado en mangueras",
      descripcion: "",
      sistemaId: const Value(6),
      subSistemaId: const Value(6),
      posicion: const Value("n/a"),
      tipo: TipoDePregunta.parteDeCuadriculaUnica,
      criticidad: 3,
    ),
    PreguntasCompanion.insert(
      id: const Value(4),
      bloqueId: 4,
      titulo: "Fugas en base del filtro de aceite",
      descripcion: "",
      sistemaId: const Value(6),
      subSistemaId: const Value(6),
      posicion: const Value("n/a"),
      tipo: TipoDePregunta.parteDeCuadriculaUnica,
      criticidad: 3,
    ),
  ]);
  //Las respuestas de la cuadricula
  batch.insertAll(db.opcionesDeRespuesta, [
    OpcionesDeRespuestaCompanion.insert(
        id: const Value(9),
        texto: "requiere intervencion",
        criticidad: 4,
        cuadriculaId: const Value(1)),
    OpcionesDeRespuestaCompanion.insert(
        id: const Value(10),
        texto: "sin novedad",
        criticidad: 0,
        cuadriculaId: const Value(1)),
  ]);
}
