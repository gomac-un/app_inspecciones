import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:inspecciones/application/sincronizacion/sincronizacion_cubit.dart';
import 'package:inspecciones/core/error/exceptions.dart';
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
    /*  final media = MediaQuery.of(context); */
    return Scaffold(
      appBar: AppBar(
        /*  toolbarHeight: media.orientation == Orientation.portrait
              ? media.size.height * 0.07
              : media.size.width * 0.07, */
        /* automaticallyImplyLeading:
              // ignore: avoid_bool_literals_in_conditional_expressions
              media.size.width <= 600 || media.size.height <= 600
                  ? true
                  : false, */
        title: const Text(
          'Sincronización',
          /* style: TextStyle(
                fontSize: media.orientation == Orientation.portrait
                    ? media.size.height * 0.02
                    : media.size.width * 0.02), */
        ),
        actions: [
          BotonDescarga(),
        ],
      ),
      drawer: UserDrawer(),
      /* media.size.width <= 600 || media.size.height <= 600
            ? UserDrawer()
            : null, */
      body: BlocBuilder<SincronizacionCubit, SincronizacionState>(
        //TODO: diseñar una mejor interfaz de usuario (Edit: no sé si con la que ya está se ve mejor y sea la forma más óptima de mostrarlo)
        //TODO: manejo de errores
        builder: (context, state) {
          if (!state.cargado) {
            return const Center(child: CircularProgressIndicator());
          }

          final ValueNotifier<int> currentIndex = state.paso == 0
              ? ValueNotifier<int>(0)
              : ValueNotifier<int>(state.paso - 1 ?? 0);
          return Column(
            children: [
              const SizedBox(height: 10),
              Container(
                /* width: media.size.width,
                        height: media.size.height * 0.09, */
                color: Theme.of(context).primaryColorLight,
                child: ListTile(
                  leading: const Icon(
                    Icons.auto_delete,
                    color: Colors.red,
                    /*  size: media.orientation == Orientation.portrait
                                ? media.size.height * 0.025
                                : media.size.width * 0.025, */
                  ),
                  /* title: Text(
                              'Al sincronizar con GOMAC, perderá todos los borradores.',
                              style: TextStyle(color: Theme.of(context).hintColor),
                            ), */
                  subtitle: Text(
                    'Al sincronizar con GOMAC, es posible que se pierdan algunos borradores. Envíe lo que tenga pendiente antes de iniciar la descarga',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      /* fontSize:
                                    media.orientation == Orientation.portrait
                                        ? media.size.width * 0.03
                                        : media.size.height * 0.03 */
                    ),
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: LinearProgressIndicator(
                  value: state.task != null ? state.task.progress / 100 : 0,
                ),
              ),
              const Divider(),
              ValueListenableBuilder(
                valueListenable: currentIndex,
                builder: (BuildContext context, value, Widget child) {
                  return Card(
                    margin: const EdgeInsets.only(left: 50, right: 50),
                    child: SizedBox(
                      /* width: media.size.width, */
                      child: Stepper(
                        controlsBuilder: (BuildContext context,
                                {VoidCallback onStepContinue,
                                VoidCallback onStepCancel}) =>
                            Container(),
                        onStepTapped: (index) {
                          currentIndex.value = index;
                        },
                        currentStep: currentIndex.value,
                        steps: [
                          Step(
                              state: state.paso > 1
                                  ? StepState.complete
                                  : StepState.indexed,
                              content: Text(state.info[1],
                                  style: Theme.of(context).textTheme.subtitle2),
                              title: Text('Descarga de cuestionarios',
                                  style:
                                      Theme.of(context).textTheme.subtitle2)),
                          Step(
                              state: state.paso > 2
                                  ? StepState.complete
                                  : StepState.indexed,
                              content: Text(state.info[2],
                                  style: Theme.of(context).textTheme.subtitle2),
                              title: Text('Instalación base de datos',
                                  style:
                                      Theme.of(context).textTheme.subtitle2)),
                          Step(
                              state: state.paso > 3
                                  ? StepState.complete
                                  : StepState.indexed,
                              content: Text(state.info[3],
                                  style: Theme.of(context).textTheme.subtitle2),
                              title: Text('Descarga de fotos',
                                  style:
                                      Theme.of(context).textTheme.subtitle2)),
                          Step(
                              state: state.paso == 4
                                  ? StepState.complete
                                  : StepState.indexed,
                              title: Text(state.info[4] ?? '',
                                  style: Theme.of(context).textTheme.subtitle2),
                              content: const Text('')),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                state.info[0], /* style: Theme.of(context).textTheme.overline */
              )
            ],
          );
        },
      ),
    );
  }
}

class BotonDescarga extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<SincronizacionCubit>(context);
    return OutlineButton.icon(
      /*color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,*/
      onPressed: () async {
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
          Scaffold.of(context).showSnackBar(SnackBar(
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
