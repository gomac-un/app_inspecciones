import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/sincronizacion/sincronizacion_cubit.dart';
import 'package:inspecciones/injection.dart';

import 'package:inspecciones/presentation/widgets/drawer.dart';

class SincronizacionPage extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (ctx) =>
            getIt<SincronizacionCubit>()..cargarUltimaActualizacion(),
        child: this,
      );

  const SincronizacionPage();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SincronizacionCubit>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('sincronizacion'),
          actions: [
            OutlineButton.icon(
              /*color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,*/
              onPressed: bloc.descargarServer,
              icon: const Icon(Icons.play_arrow),
              label: const Text("iniciar descarga"),
            )
          ],
        ),
        drawer: UserDrawer(),
        body: BlocBuilder<SincronizacionCubit, SincronizacionState>(
          //TODO: diseñar una mejor interfaz de usuario
          //TODO: manejo de errores
          builder: (context, state) {
            final listOfWidgets = <Widget>[];
            ListTile ultimaActualizacionTile() => ListTile(
                title: Text(state.ultimaActualizacion == null
                    ? "No ha descargado ninguna inspección"
                    : "Ultima actualización: ${state.ultimaActualizacion}"));

            ListTile descargaTile() => ListTile(
                  title: const Text("Descarga de la base de datos"),
                  subtitle: Column(
                    children: [
                      LinearProgressIndicator(
                        value: state.task.progress / 100,
                      ),
                      Text(state.task.status.toText()),
                    ],
                  ),
                );

            ListTile instalandoTile() => const ListTile(
                  title: Text("instalando"),
                );

            switch (state.status) {
              case SincronizacionStatus.inicial:
              case SincronizacionStatus.cargando:
                return const Center(child: CircularProgressIndicator());

              case SincronizacionStatus.cargado:
                listOfWidgets.add(ultimaActualizacionTile());
                break;

              case SincronizacionStatus.descargandoServer:
                listOfWidgets
                    .addAll([ultimaActualizacionTile(), descargaTile()]);
                break;

              case SincronizacionStatus.instalandoDB:
                listOfWidgets.addAll([
                  ultimaActualizacionTile(),
                  descargaTile(),
                  instalandoTile()
                ]);
                break;
              case SincronizacionStatus.exito:
                listOfWidgets.addAll([
                  ultimaActualizacionTile(),
                  descargaTile(),
                  instalandoTile(),
                  ListTile(
                    title: const Text('instalacion exitosa'),
                    trailing: OutlineButton(
                      onPressed: () => ExtendedNavigator.of(context).pop(),
                      child: const Text('Salir'),
                    ),
                  ),
                ]);
                break;
            }
            return ListView(
              children: listOfWidgets,
            );
          },
        ));
  }
}
