import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';
import 'package:inspecciones/utils/future_either_x.dart';
import 'package:intl/intl.dart';

import '../domain/borrador.dart';
import '../domain/identificador_inspeccion.dart';
import '../domain/inspeccion.dart';
import '../infrastructure/inspecciones_repository.dart';
import 'inicio_inspeccion_form_widget.dart';
import 'llenado_de_inspeccion_screen.dart';

//TODO: Implementar que se puedan seleccionar varias inspecciones para eliminarlas.
/// Pantalla con lista de todas las inspecciones pendientes por subir.
class InspeccionesPage extends ConsumerWidget {
  const InspeccionesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inspecciones'),
        actions: [
          IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => context.goNamed("history")),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/logo-gomac.png",
            ),
          ),
        ],
      ),
      drawer: const UserDrawer(),
      body: StreamBuilder<List<Borrador>>(
        stream: ref.watch(inspeccionesRepositoryProvider).getBorradores(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("error: ${snapshot.error}");
          }
          final borradores = snapshot.data;
          if (borradores == null) {
            return const Center(
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
              final momentoGuardado =
                  borrador.inspeccion.momentoBorradorGuardado;
              final criticidad =
                  borrador.inspeccion.estado == EstadoDeInspeccion.finalizada
                      ? 'Criticidad total: '
                      : 'Criticidad parcial: ';

              return ListTile(
                onTap: () => context.goNamed(
                  'inspeccion',
                  params: {
                    "activoid": borrador.inspeccion.activo.id,
                    "cuestionarioid": borrador.cuestionario.id.toString(),
                  },
                ),
                //TODO: mejorar la manera de mostrar la informacion
                tileColor: Theme.of(context).cardColor,
                title: Text(
                    "${borrador.inspeccion.activo.id} - ${borrador.inspeccion.activo.etiquetas.join(", ")} (${borrador.cuestionario.tipoDeInspeccion})",
                    style: Theme.of(context).textTheme.subtitle1),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      "Estado: ${EnumToString.convertToString(borrador.inspeccion.estado, camelCase: true)}",
                    ),
                    Text(
                      "Avance: ${((borrador.avance / borrador.totalPreguntas) * 100).round()}%",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(momentoGuardado == null
                        ? ''
                        : "Fecha de guardado: ${DateFormat.yMd().add_jm().format(momentoGuardado)}"),
                    Text(
                      '$criticidad ${borrador.inspeccion.criticidadCalculada}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      'Criticidad con reparaciones: ${borrador.inspeccion.criticidadCalculadaConReparaciones}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),

                leading: IconButton(
                    icon: Icon(
                      Icons.cloud_upload,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () => _subirInspeccion(context, ref, borrador)),
                trailing:
                    borrador.inspeccion.estado == EstadoDeInspeccion.finalizada
                        ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _eliminarBorrador(
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

  Future<void> _subirInspeccion(
      BuildContext context, WidgetRef ref, Borrador borrador) async {
    final remoteRepo = ref.read(inspeccionesRemoteRepositoryProvider);
    final localRepo = ref.read(inspeccionesRepositoryProvider);
    await remoteRepo
        .subirInspeccion(IdentificadorDeInspeccion(
            activo: borrador.inspeccion.activo.id,
            cuestionarioId: borrador.cuestionario.id))
        .leftMap((f) => apiFailureToInspeccionesFailure(f))
        .flatMap((_) => localRepo.eliminarRespuestas(borrador))
        .leftMap((f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("$f"),
            )))
        .nestedEvaluatedMap((_) => showDialog(
              context: context,
              barrierColor: Theme.of(context).primaryColorLight,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentTextStyle: Theme.of(context).textTheme.headline5,
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
            ));
  }

  Future<void> _eliminarBorrador(
    Borrador borrador,
    BuildContext context,
    InspeccionesRepository repo,
  ) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Alerta"),
            content:
                const Text("¿Está seguro que desea eliminar este borrador?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  final res = await repo.eliminarBorrador(borrador);
                  res.fold(
                    (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Error eliminando borrador: $f"),
                      duration: const Duration(seconds: 3),
                    )),
                    (_) => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InspeccionPage(inspeccionId: res)));
        }
      },
      icon: const Icon(Icons.add),
      label: const Text("Inspección"),
    );
  }
}
