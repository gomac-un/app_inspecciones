import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/infrastructure/repositories/inspeccion_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/widgets/drawer.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/moor_database.dart';

//TODO: creacion de inpecciones con excel
class CuestionariosPage extends StatelessWidget {
  final Database _db = getIt<Database>();

  CuestionariosPage();

  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return RepositoryProvider(
      create: (ctx) => getIt<InspeccionRepository>(
          param1: authBloc.state.maybeWhen(
              authenticated: (u) => u.token,
              orElse: () =>
                  throw Exception("Error inesperado: usuario no encontrado"))),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cuestionarios'),
        ),
        drawer: UserDrawer(),
        body: StreamBuilder<List<Cuestionario>>(
          stream: _db.borradoresDao.getCuestionarios(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              //throw snapshot.error;
              return Text("error: ${snapshot.error}");
            }
            if (!snapshot.hasData) {
              return const Align(
                child: CircularProgressIndicator(),
              );
            }
            final cuestionarios = snapshot.data;

            if (cuestionarios.isEmpty) {
              return Center(
                  child: Text(
                "No tiene cuestionarios por subir",
                style: Theme.of(context).textTheme.headline5,
              ));
            }

            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: cuestionarios.length,
              itemBuilder: (context, index) {
                final cuestionario = cuestionarios[index];
                return ListTile(
                  tileColor: Theme.of(context).cardColor,
                  title: Text(cuestionario.tipoDeInspeccion),
                  subtitle: Text(cuestionario.esLocal ? 'Sin subir' : 'subido'),
                  leading: cuestionario.esLocal
                      ? IconButton(
                          icon: const Icon(Icons.cloud_upload),
                          onPressed: () async {
                            final res = await RepositoryProvider.of<
                                    InspeccionRepository>(context)
                                .subirCuestionario(cuestionario)
                                .then((res) => res.fold(
                                    (fail) => fail.when(
                                        noHayConexionAlServidor: () =>
                                            "no hay conexion al servidor",
                                        noHayInternet: () => "no hay internet",
                                        serverError: (msg) =>
                                            "error inesperado: $msg"),
                                    (u) => "exito"));
                            print(res);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(res),
                            ));
                          })
                      : const SizedBox.shrink(),
                  trailing: cuestionario.esLocal
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              eliminarCuestionario(cuestionario, context),
                        )
                      : const Icon(Icons
                          .cloud), //Los cuestionarios subidos ya no se pueden borrar
                  onTap: () => {
                    throw UnimplementedError(
                        "implementar la edicion de cuestionarios")
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: const FloatingActionButtonCreacionCuestionario(),
      ),
    );
  }

  void eliminarCuestionario(Cuestionario cuestionario, BuildContext context) {
    // set up the buttons
    final cancelButton = FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text("Cancelar"), // OJO con el context
    );
    final Widget continueButton = FlatButton(
      onPressed: () async {
        Navigator.of(context).pop();
        await _db.borradoresDao.eliminarCuestionario(cuestionario);
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text("Cuestionario eliminado"),
          duration: Duration(seconds: 3),
        ));
      },
      child: const Text("Eliminar"),
    );
    // set up the AlertDialog
    final alert = AlertDialog(
      title: const Text("Alerta"),
      content: const Text("¿Está seguro que desea eliminar este cuestionario?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class FloatingActionButtonCreacionCuestionario extends StatelessWidget {
  const FloatingActionButtonCreacionCuestionario({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final res = await ExtendedNavigator.of(context).pushCreacionFormPage();
        // mostar el mensaje que viene desde la pantalla de llenado
        if (res != null) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("$res")));
        }
      },
      icon: const Icon(Icons.add),
      label: const Text("Cuestionario"),
    );
  }
}
