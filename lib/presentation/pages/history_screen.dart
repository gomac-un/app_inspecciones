import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/borrador.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';

import '../widgets/user_drawer.dart';

final borradoresDaoProvider =
    Provider((ref) => ref.watch(driftDatabaseProvider).borradoresDao);

/// Vista con el historial de las inspecciones enviadas satisfactoriamente al servidor
class HistoryInspeccionesPage extends ConsumerWidget {
  const HistoryInspeccionesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      drawer: const UserDrawer(),
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          Builder(
            builder: (context) => TextButton(
              onPressed: () => _clearHistory(context),
              child: const Text(
                'Limpiar Historial',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder<List<Borrador>>(
          stream: ref.watch(borradoresDaoProvider).borradores(enviadas: true),
          builder: (context, snapshot) {
            final textTheme = Theme.of(context).textTheme;

            if (snapshot.hasError) {
              return Text("error: ${snapshot.error}");
            }
            final borradoresHistorial = snapshot.data;
            if (borradoresHistorial == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (borradoresHistorial.isEmpty) {
              return Center(
                  child: Text(
                "No tiene inspecciones enviadas",
                style: Theme.of(context).textTheme.headline5,
              ));
            }
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: borradoresHistorial.length,
              itemBuilder: (context, index) {
                final borrador = borradoresHistorial[index];

                final _dateSend = borrador.inspeccion.momentoEnvio;
                return ListTile(
                  tileColor: Theme.of(context).cardColor,
                  title: Text(
                    "${borrador.inspeccion.activo.id} - ${borrador.inspeccion.activo.modelo} (${borrador.cuestionario.tipoDeInspeccion})",
                    style: textTheme.headline6,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        _dateSend == null
                            ? "Fecha de envío: "
                            : "Fecha de envío: ${_dateSend.day}/${_dateSend.month}/${_dateSend.year} ${_dateSend.hour}:${_dateSend.minute}",
                        style: textTheme.subtitle1,
                      ),
                      Text(
                        'Codigo de inspección: ${borrador.inspeccion.id}',
                        style: textTheme.subtitle1,
                      )
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteBorrador(context, borrador),
                  ),
                );
              },
            );
          }),
    );
  }

  ///Usado para eliminar el item del historial seleccionado
  ///[borrador] item del historial seleccionado
  /// [_noButton]: Privado Cancela la trasaccion de eliminar el item seleccionado
  /// [_yesButton]: Privado Elimina la seleccion
  void _deleteBorrador(BuildContext context, Borrador borrador) => showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
              title: const Text("Eliminar inspeccion"),
              content: const Text(
                  "¿Esta seguro de eliminar ésta inspección del historial?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("No")),
                Consumer(builder: (context, ref, _) {
                  return TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await ref
                            .read(borradoresDaoProvider)
                            .eliminarBorrador(borrador);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Borrador eliminado"),
                          duration: Duration(seconds: 3),
                        ));
                      },
                      child: const Text("Si"));
                }),
              ]));

  void _clearHistory(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
              title: const Text("Vaciar historial"),
              content: const Text(
                  "Está a punto de vaciar el historial ¿Está seguro?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("No")),
                Consumer(builder: (context, ref, _) {
                  return TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        ref
                            .read(borradoresDaoProvider)
                            .eliminarHistorialEnviados();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Finalizado"),
                          duration: Duration(seconds: 3),
                        ));
                      },
                      child: const Text("Si"));
                }),
              ]));
}
