import 'package:auto_route/auto_route.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/pages/inicio_inspeccion_form_widget.dart';
import 'package:inspecciones/presentation/widgets/drawer.dart';
import 'package:inspecciones/router.gr.dart';

//TODO: A futuro, Implementar que se puedan seleccionar varias inspecciones para eliminarlas.
/// Pantalla con lista de todas las inspecciones pendientes por subir.
class BorradoresPage extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (ctx) => getIt<InspeccionesRepository>()),
        StreamProvider(
          create: (ctx) => getIt<InspeccionesRepository>().getBorradores(),
          initialData: const <Borrador>[],
        )
      ],
      child: this,
    );
  }

  const BorradoresPage(Key? key) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repo = context.read<InspeccionesRepository>();
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
      drawer: const UserDrawer(),
      body: StreamBuilder<List<Borrador>>(
        // Toco usar un proviedr porque estaba creando el stream en cada rebuild
        stream: context.watch<Stream<List<Borrador>>>(),
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
                /*onTap: () => context.router.push(LlenadoFormRoute(
                    activoId: borrador.activo.id,
                    cuestionarioId: borrador.inspeccion.cuestionarioId)),*/

                tileColor: Theme.of(context).cardColor,
                title: Text(
                    "${borrador.activo.id} - ${borrador.activo.modelo} (${borrador.cuestionario.tipoDeInspeccion})",
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
                          final res =
                              await repo.subirInspeccion(borrador.inspeccion);
                          final restxt = res.fold(
                              (fail) => fail.when(
                                  pageNotFound: () =>
                                      'No se pudo encontrar la página, informe al encargado',
                                  noHayConexionAlServidor: () =>
                                      "No hay conexión al servidor",
                                  noHayInternet: () =>
                                      "No tiene conexión a internet",
                                  serverError: (msg) => "Error interno: $msg",
                                  credencialesException: () =>
                                      'Error inesperado: intente inciar sesión nuevamente'),
                              (u) {
                            repo.eliminarRespuestas(borrador);

                            return "exito";
                          });
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
                        onPressed: () =>
                            eliminarBorrador(borrador, context, repo),
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
                try {
                  await repo.eliminarBorrador(borrador);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Borrador eliminado"),
                    duration: Duration(seconds: 3),
                  ));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Error eliminando borrador"),
                    duration: Duration(seconds: 3),
                  ));
                }
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
        ;
      },
    );
  }
}

/// Botón de creación de inspecciones
class FloatingActionButtonInicioInspeccion extends StatelessWidget {
  const FloatingActionButtonInicioInspeccion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final form = FormGroup(
      {'mostrar': FormControl<bool>(value: false)},
    );
    return FloatingActionButton.extended(
      onPressed: () async {
        final res = await showDialog<ArgumentosLlenado>(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Inicio de inspección'),
            content: InicioInspeccionForm(),
          ),
        );

        if (res != null) {
          // llenar inspeccion
          //TODO: arreglar el llenado de inspecciones
          /*context.router.push(LlenadoFormRoute(
                    activoId: res.activo,
                    cuestionarioId: res.cuestionarioId));*/

          /*final mensajeLlenado = await ExtendedNavigator.of(context)
              .push(Routes.llenadoFormPage, arguments: res);
          // mostar el mensaje que viene desde la pantalla de llenado
          if (mensajeLlenado != null) {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("$mensajeLlenado")));
          }*/
        }
      },
      icon: const Icon(Icons.add),
      label: const Text("Inspección"),
    );
  }
}
