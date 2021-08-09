import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/sincronizacion/sincronizacion_cubit.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/widgets/drawer.dart';

/// Pantalla que muestra el progreso de a descarga de datos de gomac
class SincronizacionPage extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (ctx) => getIt<SincronizacionCubit>(),
        child: this,
      );

  const SincronizacionPage();

  @override
  Widget build(BuildContext context) {
    final sincronizacionCubit = BlocProvider.of<SincronizacionCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronización'),
        actions: [
          /// Inicio de descarga de datos
          BotonDescarga(),
        ],
      ),
      drawer: UserDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            color: Theme.of(context).primaryColorLight,
            child: ListTile(
              leading: const Icon(
                Icons.auto_delete,
                color: Colors.red,
              ),
              subtitle: Text(
                'Al sincronizar con GOMAC, es posible que se pierdan algunos borradores. Envíe lo que tenga pendiente antes de iniciar la descarga',
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ),
          const Divider(),
          /*Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: LinearProgressIndicator(
              value: state.task != null ? state.task.progress / 100 : 0,
            ),
          ),
          const Divider(),*/

          /// División de los pasos de la sincronización
          Card(
            margin: const EdgeInsets.only(left: 50, right: 50),
            child: SizedBox(
              child: BlocBuilder<SincronizacionCubit, SincronizacionState>(
                builder: (context, state) {
                  return Stepper(
                    controlsBuilder: (BuildContext context,
                            {VoidCallback? onStepContinue,
                            VoidCallback? onStepCancel}) =>
                        Container(),
                    onStepTapped: (index) {
                      sincronizacionCubit.selectPaso(index);
                    },
                    currentStep: state.paso,
                    steps: [
                      for (final step in sincronizacionCubit.steps)
                        Step(
                          state: step.state.map(
                              initial: (_) => StepState.indexed,
                              inProgress: (_) => StepState.editing,
                              success: (_) => StepState.complete,
                              failure: (_) => StepState.error),
                          title: Text(step.titulo,
                              style: Theme.of(context).textTheme.subtitle2),
                          content: BlocBuilder<SincronizacionStep,
                              SincronizacionStepState>(
                            bloc: step,
                            builder: (context, state) => Text(state.log,
                                style: Theme.of(context).textTheme.subtitle2),
                          ),
                        )
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),

          /// Ultima sincronización.
          ValueListenableBuilder<Option<DateTime>>(
              valueListenable: sincronizacionCubit.ultimaActualizacion,
              builder: (_, value, __) => Text("Ultima sincronizacion: " +
                  value.fold(() => "Nunca se ha sincronizado",
                      (date) => date.toIso8601String())))
        ],
      ),
    );
  }
}

/// Inicio de descarga de datos mediante el [FlutterDownloader]
class BotonDescarga extends StatelessWidget {
  const BotonDescarga({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SincronizacionCubit>(context);
    return OutlinedButton.icon(
      /*color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,*/
      onPressed: () async {
        /// Intento de hacer manejo de errores, pero aún no sé como hacerlo con [FlutterDownloader]
        final res = await bloc.descargarServer().then((res) => res.fold(
                (fail) => fail.when(
                    pageNotFound: () =>
                        'No se pudo encontrar la página, informe al encargado',
                    noHayConexionAlServidor: () =>
                        "No hay conexion al servidor",
                    noHayInternet: () => "No tiene conexión a internet",
                    serverError: (msg) => "Error interno: $msg",
                    credencialesException: () =>
                        'Error inesperado: intente inciar sesión nuevamente'),
                (u) {
              return "exito";
            }));
        if (res != 'exito') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res),
          ));
        }
      },
      icon: const Icon(Icons.play_arrow, color: Colors.white),
      label: const Text(
        "Iniciar descarga",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
