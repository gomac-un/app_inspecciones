import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:provider/provider.dart';
import 'package:inspecciones/router.gr.dart';

class UserDrawer extends StatelessWidget {
  //TODO: si se genera este mismo drawer en varias paginas se puede crear un stack indeseado, una solucion seria que la instancia del drawer fuera unica en toda la app
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    final authState = authBloc.state;

    if (authState is Authenticated) {
      return SafeArea(
        child: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                color: Colors.lightBlue,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: UserAccountsDrawerHeader(
                    accountName: Text(
                      (authBloc.state as Authenticated).usuario.esAdmin
                          ? "Administrador"
                          : "inspector",
                    ),
                    accountEmail: Text(authState.usuario.documento),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text(
                        authState.usuario.documento[0],
                        style: const TextStyle(fontSize: 35),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              ListTile(
                selectedTileColor: Theme.of(context).accentColor,
                title: const Text('Creación de Inspecciones',
                    style: TextStyle(/* color: Colors.white ,*/ fontSize: 15)),
                leading: const Icon(
                  Icons.add,
                  color: Colors.black, /* color: Colors.white, */
                ),
                onTap: () async {
                  final res = await ExtendedNavigator.of(context)
                      .pushCreacionFormPage();
                  if (res != null && res is String) {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text(res)));
                  }
                  ExtendedNavigator.of(context).pop();
                },
              ),
              const SizedBox(height: 5.0),
              ListTile(
                selectedTileColor: Theme.of(context).accentColor,
                title: const Text(
                    'Lista de cuestionarios', //TODO: mostrar el numero de  inspecciones creadas pendientes por subir
                    style: TextStyle(/* color: Colors.white ,*/ fontSize: 15)),
                leading: const Icon(
                  Icons.list_alt,
                  color: Colors.black, /* color: Colors.white, */
                ),
                onTap: () => ExtendedNavigator.of(context)
                    .replace(Routes.cuestionariosPage),
              ),
              const SizedBox(height: 5.0),
              ListTile(
                selectedTileColor: Theme.of(context).accentColor,
                title: const Text(
                    'Lista de borradores', //TODO: mostrar el numero de  inspecciones creadas pendientes por subir
                    style: TextStyle(/* color: Colors.white ,*/ fontSize: 15)),
                leading: const Icon(
                  Icons.list,
                  color: Colors.black, /* color: Colors.white, */
                ),
                onTap: () => ExtendedNavigator.of(context)
                    .replace(Routes.borradoresPage),
              ),
              const SizedBox(height: 5.0),
              ListTile(
                title: const Text(
                  'Limpiar base de datos',
                  style: TextStyle(/* color: Colors.white, */ fontSize: 15),
                ),
                leading: const Icon(
                  Icons.clear,
                  color: Colors.black,
                ),
                onTap: () => getIt<Database>().dbdePrueba(),
              ),
              ListTile(
                selectedTileColor: Theme.of(context).accentColor,
                title: const Text('Actualizar inspecciones',
                    style: TextStyle(/* color: Colors.white ,*/ fontSize: 15)),
                leading: const Icon(
                  Icons.update,
                  color: Colors.black, /* color: Colors.white, */
                ),
                onTap: () async {
                  await ExtendedNavigator.of(context).pushSincronizacionPage();
                  ExtendedNavigator.of(context).pop();
                },
              ),
              const SizedBox(height: 5.0),
              ListTile(
                title: const Text('Ver base de Datos',
                    style: TextStyle(color: Colors.black, fontSize: 15)),
                leading: const Icon(
                  Icons.view_array,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MoorDbViewer(
                        getIt<Database>(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                  height:
                      50.0), //TODO: hacer que el boton de logout flote abajo en lugar de establecer esta distancia quemada
              Padding(
                padding: const EdgeInsets.only(left: 160.0),
                child: ListTile(
                    title: const Text('Cerrar Sesión'),
                    leading: const Icon(Icons.exit_to_app),
                    onTap: () => authBloc.add(const AuthEvent.loggingOut())),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Text("error");
    }
  }
}
