import 'package:drift/drift.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart'
    as dominio;
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';

part 'organizacion_dao.drift.dart';

@DriftAccessor(tables: [
  EtiquetasJerarquicasDeActivo,
  EtiquetasJerarquicasDePregunta,
  EtiquetasDeActivo,
  Activos,
  ActivosXEtiquetas,
])
class OrganizacionDao extends DatabaseAccessor<Database>
    with _$OrganizacionDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  OrganizacionDao(Database db) : super(db);

  Future<List<dominio.ActivoEnLista>> getActivos() async {
    final activosInsertados = await select(activos).get();
    return Future.wait(
      activosInsertados.map(
        (a) async => dominio.ActivoEnLista(
          a.id,
          await db.utilsDao.getEtiquetasDeActivo(activoId: a.id).then(
              (l) => l.map((e) => dominio.Etiqueta(e.clave, e.valor)).toList()),
        ),
      ),
    );
  }

  Future<void> setActivos(List<ActivoEnLista> activosEnLista) =>
      transaction(() async {
        await delete(activosXEtiquetas).go();
        //await delete(activos).go(); // dado que los activos son clave foranea de inspeccion no se pueden borrar
        // se tuvo que hacer un custom delete porque se necesita un alias para que
        // el select anidado use el id de la tabla externa
        await customUpdate(
          '''DELETE FROM etiquetas_de_activo AS e
            WHERE NOT EXISTS (
              SELECT * FROM cuestionarios_x_etiquetas WHERE etiqueta_id = e.id
            )''',
          updates: {etiquetasDeActivo},
          updateKind: UpdateKind.delete,
        );
        /*await (delete(etiquetasDeActivo)
              ..where(
                (e) => notExistsQuery(
                  select(cuestionariosXEtiquetas)
                    ..where((cxe) => cxe.etiquetaId.equalsExp(etiquetasDeActivo.id)),
                ),
              ))
            .go();*/
        for (final activo in activosEnLista) {
          final activoInsertado = await into(activos).insertReturning(
              ActivosCompanion.insert(id: activo.id),
              mode: InsertMode.insertOrReplace);
          for (final etiqueta in activo.etiquetas) {
            await _asignarEtiqueta(activoInsertado, etiqueta);
          }
        }
      });

  Future<void> _asignarEtiqueta(Activo activo, Etiqueta etiqueta) async {
    final query = select(etiquetasDeActivo)
      ..where((e) =>
          e.clave.equals(etiqueta.clave) & e.valor.equals(etiqueta.valor));
    var etiquetaInsertada = await query.getSingleOrNull();
    etiquetaInsertada ??= await into(etiquetasDeActivo).insertReturning(
        EtiquetasDeActivoCompanion.insert(
            clave: etiqueta.clave, valor: etiqueta.valor));

    await into(activosXEtiquetas).insert(ActivosXEtiquetasCompanion.insert(
        activoId: activo.id, etiquetaId: etiquetaInsertada.id));
  }

  Future<void> borrarActivo(ActivoEnLista activo) {
    return (delete(activos)..where((a) => a.id.equals(activo.id))).go();
  }

  Future<void> setEtiquetasJerarquicasDeActivos(
      List<dominio.Jerarquia> etiquetas) async {
    return transaction(() async {
      await (delete(etiquetasJerarquicasDeActivo)
            ..where((e) => e.esLocal.equals(false)))
          .go();
      for (final etiqueta in etiquetas) {
        await into(etiquetasJerarquicasDeActivo).insert(
          EtiquetasJerarquicasDeActivoCompanion.insert(
              nombre: etiqueta.niveles.first,
              json: etiqueta.toMap(),
              esLocal: false),
          mode: InsertMode.insertOrReplace, //TODO: preguntar si hay conflictos
        );
      }
    });
  }

  Future<void> setEtiquetasJerarquicasDePreguntas(
      List<dominio.Jerarquia> etiquetas) async {
    return transaction(() async {
      await (delete(etiquetasJerarquicasDePregunta)
            ..where((e) => e.esLocal.equals(false)))
          .go();
      for (final etiqueta in etiquetas) {
        await into(etiquetasJerarquicasDePregunta).insert(
          EtiquetasJerarquicasDePreguntaCompanion.insert(
              nombre: etiqueta.niveles.first,
              json: etiqueta.toMap(),
              esLocal: false),
          mode: InsertMode.insertOrReplace, //TODO: preguntar si hay conflictos
        );
      }
    });
  }

  Stream<List<dominio.Jerarquia>> watchEtiquetasDeActivos() => select(
        etiquetasJerarquicasDeActivo,
      ).map((e) => dominio.Jerarquia.fromMap(e.json, esLocal: e.esLocal)).watch();

  Stream<List<dominio.Jerarquia>> watchEtiquetasDePreguntas() => select(
        etiquetasJerarquicasDePregunta,
      ).map((e) => dominio.Jerarquia.fromMap(e.json, esLocal: e.esLocal)).watch();

  Future<void> eliminarEtiquetaDeActivo(dominio.Jerarquia etiqueta) =>
      (delete(etiquetasJerarquicasDeActivo)
            ..where((e) => e.nombre.equals(etiqueta.niveles.first)))
          .go();

  Future<void> eliminarEtiquetaDePregunta(dominio.Jerarquia etiqueta) =>
      (delete(etiquetasJerarquicasDePregunta)
            ..where((e) => e.nombre.equals(etiqueta.niveles.first)))
          .go();

  Future<void> agregarEtiquetaDeActivo(dominio.Jerarquia etiqueta) =>
      into(etiquetasJerarquicasDeActivo).insert(
          EtiquetasJerarquicasDeActivoCompanion.insert(
              nombre: etiqueta.niveles.first,
              json: etiqueta.toMap(),
              esLocal: true));

  Future<void> agregarEtiquetaDePregunta(dominio.Jerarquia etiqueta) =>
      into(etiquetasJerarquicasDePregunta).insert(
          EtiquetasJerarquicasDePreguntaCompanion.insert(
              nombre: etiqueta.niveles.first,
              json: etiqueta.toMap(),
              esLocal: true));

  Future<List<EtiquetaJerarquicaDeActivo>> getEtiquetasPendientesDeActivos() =>
      (select(etiquetasJerarquicasDeActivo)
            ..where((e) => e.esLocal.equals(true)))
          .get();

  Future<List<EtiquetaJerarquicaDePregunta>>
      getEtiquetasPendientesDePreguntas() =>
          (select(etiquetasJerarquicasDePregunta)
                ..where((e) => e.esLocal.equals(true)))
              .get();

  Future<void> desmarcarEtiquetasPendientesDeActivo() =>
      update(etiquetasJerarquicasDeActivo).write(
          const EtiquetasJerarquicasDeActivoCompanion(esLocal: Value(false)));

  Future<void> desmarcarEtiquetasPendientesDePregunta() =>
      update(etiquetasJerarquicasDePregunta).write(
          const EtiquetasJerarquicasDePreguntaCompanion(esLocal: Value(false)));
}
