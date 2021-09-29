import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/llenado_inspecciones/control/controlador_llenado_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/borrador.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/identificador_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/infrastructure/inspecciones_repository.dart';
import 'package:inspecciones/features/llenado_inspecciones/ui/llenado_de_inspeccion_screen.dart';
import 'package:inspecciones/presentation/pages/inicio_inspeccion_form_widget.dart';

//TODO: A futuro, Implementar que se puedan seleccionar varias inspecciones para eliminarlas.
/// Pantalla con lista de todas las inspecciones pendientes por subir.
class BorradoresPage extends ConsumerWidget {
  const BorradoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspecciones'),
        actions: [
          IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                //context.router.push(const HistoryRoute());
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/logo-gomac.png",
            ),
          ),
        ],
      ),
      //drawer: const UserDrawer(),
      body: StreamBuilder<List<Borrador>>(
        stream: ref.watch(inspeccionesRepositoryProvider).getBorradores(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //throw snapshot.error;
            return Text("error: ${snapshot.error}");
          }
          final borradores = snapshot.data;
          if (borradores == null) {
            return const Align(
              child: CircularProgressIndicator(),
            );
          }

          if (borradores.isEmpty) {
            return Center(
                child: Text(
              "No tiene borradores sin terminar",
              style: Theme.of(context).textTheme.headline5,
            ));
          }

          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: borradores.length,
            itemBuilder: (context, index) {
              final borrador = borradores[index];
              final f = borrador.inspeccion.momentoBorradorGuardado;
              final criticidad =
                  borrador.inspeccion.estado == EstadoDeInspeccion.finalizada
                      ? 'Criticidad total inicial: '
                      : 'Criticidad parcial inicial: ';

              return ListTile(
                //TODO: arreglar el llenado de inspecciones
                onTap: () {
                  ref.read(inspeccionIdProvider).state =
                      IdentificadorDeInspeccion(
                    activo: borrador.inspeccion.activo.id,
                    cuestionarioId: borrador.cuestionario.id,
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const InspeccionPage()));
                },

                tileColor: Theme.of(context).cardColor,
                title: Text(
                    "${borrador.inspeccion.activo.id} - ${borrador.inspeccion.activo.modelo} (${borrador.cuestionario.tipoDeInspeccion})",
                    style: Theme.of(context).textTheme.subtitle1),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      "Estado: ${EnumToString.convertToString(borrador.inspeccion.estado, camelCase: true)}",
                    ),
                    Text(
                      "Avance del cuestionario: ${((borrador.avance / borrador.total) * 100).round()}%",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(f == null
                        ? ''
                        : "Fecha de guardado: ${f.day}/${f.month}/${f.year} ${f.hour}:${f.minute}"),
                    Text(
                      '$criticidad ${borrador.inspeccion.criticidadTotal}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      'Criticidad reparaciones pendientes: ${borrador.inspeccion.criticidadReparacion}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),

                /// Solo se puede subir al server si está finalizado o enReparacion
                leading: [
                  EstadoDeInspeccion.finalizada,
                  EstadoDeInspeccion.enReparacion
                ].contains(borrador.inspeccion.estado)
                    ? IconButton(
                        icon: Icon(
                          Icons.cloud_upload,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () async {
                          //TODO: eliminar esta duplicacion de codigo
                          final repo = ref.read(inspeccionesRepositoryProvider);
                          final res =
                              await repo.subirInspeccion(borrador.inspeccion);
                          final restxt = res.fold((f) => f.msg, (u) => "exito");
                          restxt == 'exito'
                              ? showDialog(
                                  context: context,
                                  barrierColor:
                                      Theme.of(context).primaryColorLight,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentTextStyle:
                                          Theme.of(context).textTheme.headline5,
                                      title: const Icon(Icons.done_sharp,
                                          size: 100, color: Colors.green),
                                      actions: [
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Aceptar'),
                                          ),
                                        )
                                      ],
                                      content: const Text(
                                        'Inspección enviada correctamente',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                )
                              : ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  content: Text(restxt),
                                ));
                        })
                    : const SizedBox(),
                trailing: borrador.inspeccion.esNueva
                    ? IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => eliminarBorrador(
                          borrador,
                          context,
                          ref.read(inspeccionesRepositoryProvider),
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            },
          );
        },
      ),
      floatingActionButton: const FloatingActionButtonInicioInspeccion(),
    );
  }

  ///Elimia [borrador].
  void eliminarBorrador(
      Borrador borrador, BuildContext context, InspeccionesRepository repo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Alerta"),
          content: const Text("¿Está seguro que desea eliminar este borrador?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"), // OJO con el context
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                final res = await repo.eliminarBorrador(borrador);
                res.fold(
                  (f) =>
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Error eliminando borrador"),
                    duration: Duration(seconds: 3),
                  )),
                  (_) =>
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Borrador eliminado"),
                    duration: Duration(seconds: 3),
                  )),
                );
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }
}

/// Botón de creación de inspecciones
class FloatingActionButtonInicioInspeccion extends ConsumerWidget {
  const FloatingActionButtonInicioInspeccion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final res = await showDialog<IdentificadorDeInspeccion>(
          context: context,
          builder: (BuildContext context) => const Dialog(
            child: InicioInspeccionForm(),
          ),
        );
        if (res != null) {
          ref.read(inspeccionIdProvider).state = res;
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const InspeccionPage()));
        }
      },
      icon: const Icon(Icons.add),
      label: const Text("Inspección"),
    );
  }
}
