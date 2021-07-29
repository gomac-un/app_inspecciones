import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:provider/provider.dart';

/// Vista con el historial de las inspecciones enviadas satisfactoriamente al servidor
class HistoryInspeccionesPage extends StatelessWidget
    implements AutoRouteWrapper {
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
                getIt<Database>().borradoresDao.borradoresHistorial()),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Borrador> toDelete = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          Builder(
            builder: (context) => FlatButton(
              child: const Text(
                'Limpiar Historial',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              onPressed: () => _clearHistory(context, toDelete),
            ),
          )
        ],
      ),
      body: Consumer<List<Borrador>>(
          builder: (context, borradoresHistorial, child) {
        final textTheme = Theme.of(context).textTheme;
        if (borradoresHistorial == null) {
          return const Text("Hay un null");
        }
        if (borradoresHistorial.isEmpty) {
          return Center(
            child: Text(
              "No tiene inspecciones enviadas",
              style: textTheme.headline5,
            ),
          );
        }
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemCount: borradoresHistorial.length,
          itemBuilder: (context, index) {
            final borrador = borradoresHistorial[index];
            toDelete.add(borrador);
            toDelete.forEach((element) {
              print(element);
            });
            final _dateSend = borrador.inspeccion.momentoEnvio;
            return ListTile(
              tileColor: Theme.of(context).cardColor,
              title: Text(
                "${borrador.inspeccion.activoId} - ${borrador.activo.modelo}",
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
  void _deleteBorrador(BuildContext context, Borrador borrador) {
    final _noButton = FlatButton(
        onPressed: () => Navigator.of(context).pop(), child: const Text("No"));
    final _yesButton = FlatButton(
        onPressed: () async {
          Navigator.of(context).pop();
          await RepositoryProvider.of<Database>(context)
              .borradoresDao
              .eliminarBorrador(borrador);
          Scaffold.of(context).showSnackBar(const SnackBar(
            content: Text("Borrador eliminado"),
            duration: Duration(seconds: 3),
          ));
        },
        child: const Text("Si"));
    final alert = AlertDialog(
        title: const Text("Eliminar historial"),
        content: const Text(
            "¿Esta seguro de eliminar ésta inspección del historial?"),
        actions: [
          _yesButton,
          _noButton,
        ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
  /// Usado para limipiar el contenido del historial
  /// [List<Borrador> toDelete] contiene todos los items de la vista que no han sido eliminados
  /// [_noButton]: Privado Cancela la trasaccion de limipiar el historial
  /// [_yesButton]: Privado Elimina todos los items que contiene [toDelete] de la vista
  void _clearHistory(BuildContext context, List<Borrador> toDelete) {
    final _noButton = FlatButton(
        onPressed: () => Navigator.of(context).pop(), child: const Text("No"));
    final _yesButton = FlatButton(
        onPressed: () async {
          Navigator.of(context).pop();
          await toDelete.forEach((borrador) {
            RepositoryProvider.of<Database>(context)
                .borradoresDao
                .eliminarBorrador(borrador);
          });
          Scaffold.of(context).showSnackBar(const SnackBar(
            content: Text("Finalizado"),
            duration: Duration(seconds: 3),
          ));
        },
        child: const Text("Si"));
    final alert = AlertDialog(
        title: const Text("Vaciar historial"),
        content:
            const Text("Está a punto de vaciar el historial ¿Está seguro?"),
        actions: [
          _yesButton,
          _noButton,
        ]);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
