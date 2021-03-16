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
          title: const Text('Sincronizacion'),
          actions: [
            OutlineButton.icon(
              /*color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,*/
              onPressed: bloc.descargarServer,
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: const Text("Iniciar descarga",
                  style: TextStyle(color: Colors.white)),
            )
          ],
        ),
        drawer: UserDrawer(),
        body: BlocBuilder<SincronizacionCubit, SincronizacionState>(
          //TODO: diseñar una mejor interfaz de usuario
          //TODO: manejo de errores
          builder: (context, state) {
            if (!state.cargado) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  color: Theme.of(context).primaryColorLight,
                  child: ListTile(
                    leading: const Icon(Icons.auto_delete, color: Colors.red),
                    /* title: Text(
                      'Al sincronizar con GOMAC, perderá todos los borradores.',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ), */
                    subtitle: Text(
                      'Al sincronizar con GOMAC, perderá todos los borradores. Envíe los borradores pendientes antes de iniciar la descarga',
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text("Progreso de la descarga"),
                  subtitle: Column(
                    children: [
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value:
                            state.task != null ? state.task.progress / 100 : 0,
                      ),
                      Text(state.task?.status?.toText() ?? ''),
                    ],
                  ),
                ),
                Expanded(child: Text(state.info)),
              ],
            );
          },
        ));
  }
}
