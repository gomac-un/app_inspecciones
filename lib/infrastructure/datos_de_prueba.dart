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
  final ap.DjangoAPI tabla = ap.DjangoAPI();
  final activos = await tabla.getActivos();
  final contratistas = await tabla.getContratistas(); //TODO: conseguir usuario
  final sistemas = await tabla.getSistemas(); //TODO: conseguir usuario
  final subSistemas = await tabla.getSubSistemas();
  final cuestionarioDeModelo = await tabla.getCuestionarioDeModelo();
  final cuestionario = await tabla.getCuestionarios();
  final bloque = await tabla.getBloques();
  final preguntas = await tabla.getPreguntas();
  final opcionesDeRespuesta = await tabla.getOpcionesDeRespuesta();

  // Inserción datos tabla activos
  final List<Insertable<Activo>> listaActivos = activos
      .map((item) =>
          ActivosCompanion.insert(modelo: item.modelo, id: Value(item.id)))
      .toList();

  batch.insertAll(db.activos, listaActivos);

// Inserción datos tabla contratista
  final List<Insertable<Contratista>> listaContratistas = contratistas
      .map((item) =>
          ContratistasCompanion.insert(id: Value(item.id), nombre: item.nombre))
      .toList();

  batch.insertAll(db.contratistas, listaContratistas);

  //TODO: mover esto a una clase encargada de sincronizar con la api

  final List<Insertable<Sistema>> listaSistemas = sistemas
      .map((item) =>
          SistemasCompanion.insert(id: Value(item.id), nombre: item.nombre))
      .toList();

  batch.insertAll(db.sistemas, listaSistemas);

  final List<Insertable<SubSistema>> listaSubSistemas = subSistemas
      .map(
        (item) => SubSistemasCompanion.insert(
            id: Value(item.id), nombre: item.nombre, sistema: item.sistema),
      )
      .toList();
  batch.insertAll(db.subSistemas, listaSubSistemas);

//Inicio de una inspeccion de prueba
  //Datos de la inspeccion

  final List<Insertable<Cuestionario>> listaCuestionario = cuestionario
      .map(
        (item) => CuestionariosCompanion.insert(
            tipoDeInspeccion: item.tipoDeInspeccion),
      )
      .toList();
  batch.insertAll(db.cuestionarios, listaCuestionario);

  final List<Insertable<CuestionarioDeModelo>> listaCuestionarioDeModelo =
      cuestionarioDeModelo
          .map(
            (item) => CuestionarioDeModelosCompanion.insert(
                cuestionario_id: item.cuestionario_id,
                periodicidad: item.periodicidad,
                contratista_id: item.contratista_id,
                modelo: item.modelo),
          )
          .toList();
  batch.insertAll(db.cuestionarioDeModelos, listaCuestionarioDeModelo);

  final List<Insertable<Bloque>> listaBloques = bloque
      .map((item) => BloquesCompanion.insert(
          id: Value(item.id),
          nOrden: item.nOrden,
          cuestionario_id: item.cuestionario_id))
      .toList();

  batch.insertAll(db.bloques, listaBloques);

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

  final List<Insertable<Pregunta>> listaPreguntas = preguntas
      .map((item) => PreguntasCompanion.insert(
          id: Value(item.id),
          posicion: item.posicion,
          criticidad: item.criticidad,
          titulo: item.titulo,
          tipo: item.tipo,
          parteDeCuadricula: item.parteDeCuadricula,
          descripcion: item.descripcion,
          sistemaId: item.sistemaId,
          bloqueId:  item.bloqueId,
          subSistemaId: item.subSistemaId,
          ),
        )
      .toList();

  batch.insertAll(db.preguntas, listaPreguntas);

  final List<Insertable<OpcionDeRespuesta>>  listaOpcionesDeRespuesta = opcionesDeRespuesta
      .map((item) => OpcionesDeRespuestaCompanion.insert(
          id: Value(item.id),
          criticidad: item.criticidad,
          texto: item.texto
          ),
        )
      .toList();

  batch.insertAll(db.opcionesDeRespuesta, listaOpcionesDeRespuesta);
  

}