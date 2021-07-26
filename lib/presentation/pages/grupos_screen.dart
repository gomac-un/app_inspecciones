import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/planeacion_grupos_cards.dart';
import 'package:inspecciones/presentation/widgets/drawer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GruposScreen extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return MultiProvider(
      providers: [
        RepositoryProvider(
            create: (ctx) => getIt<InspeccionesRepository>(
                param1: authBloc.state.maybeWhen(
                    authenticated: (u, s) => u.token,
                    orElse: () => throw Exception(
                        "Error inesperado: usuario no encontrado")))),
        RepositoryProvider(create: (_) => getIt<Database>()),
        StreamProvider(
          create: (_) =>
              getIt<Database>().planeacionDao.obtenerGruposActuales(),
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grupos',
        ),
      ),
      drawer: UserDrawer(),
      body: Consumer<List<GrupoXTipoInspeccion>>(
        builder: (context, grupos1, child) {
          if (grupos1 == null) {
            return const Align(
              child: CircularProgressIndicator(),
            );
          }
          if (grupos1.isEmpty) {
            return Center(
              child: Text(
                'No ha programado nigún grupo, presione el botón para crear uno',
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
              height: 10,
            ),
            itemCount: grupos1.length,
            itemBuilder: (context, index) {
              final grupo = grupos1[index];
              return GruposCard(
                title: Text(grupo.tipoInspeccion.tipo),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_ios,
                      color: Theme.of(context).accentColor, size: 30),
                  onPressed: null,
                ),
                leading: const SizedBox.shrink(),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => DetailGruposPage(
                              tipoInspeccion:
                                  grupo.tipoInspeccion.toCompanion(true),
                            )),
                  );
                },
                children: [
                  Text(
                    'Número de grupos: ${grupo.grupos.length}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    "Desde: ${DateFormat('dd/MM/yyyy').format(grupo.grupos.first.inicio)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    "Hasta: ${DateFormat('dd/MM/yyyy').format(grupo.grupos.last.fin)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              );
              /* GruposCard(
                grupo: grupo,
                leading: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.miscellaneous_services_rounded,
                      color: Theme.of(context).accentColor, size: 30),
                ),
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Fecha inicio: ${DateFormat('dd/MM/yyyy').format(grupo.inicio)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Fecha fin: ${DateFormat('dd/MM/yyyy').format(grupo.fin)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ); */
            },
          );
          /*  */
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const CreacionGrupoCard(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
