import 'package:auto_route/auto_route.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/sincronizacion/sincronizacion_bloc.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/pages/inicio_inspeccion_form_widget.dart';
import 'package:inspecciones/presentation/widgets/drawer.dart';
import 'package:inspecciones/router.gr.dart';

import '../../infrastructure/moor_database.dart';

class SincronizacionPage extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (ctx) =>
            SincronizacionBloc()..add(const SincronizacionEvent.inicializar()),
        child: this,
      );

  final Database _db = getIt<Database>();

  SincronizacionPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('sincronizacion'),
        ),
        drawer: UserDrawer(),
        body: BlocBuilder<SincronizacionBloc, SincronizacionState>(
          //TODO: diseñar una mejor interfaz de usuario
          builder: (context, state) {
            final bloc = BlocProvider.of<SincronizacionBloc>(context);
            return state.when(
                cargando: () =>
                    const Center(child: CircularProgressIndicator()),
                cargado: (ultimaActualizacion) => Column(
                      children: [
                        Text(
                            'La ultima actualizacion fué $ultimaActualizacion'),
                        OutlineButton(
                            onPressed: bloc.descargarBD,
                            child: Text("descargar bd de gomac"))
                      ],
                    ),
                descargandoServer: (ultimaActualizacion, task) =>
                    Text('Descargando'),
                instalandoBD: () => Text('Instalando'));
          },
        ));
  }
}
