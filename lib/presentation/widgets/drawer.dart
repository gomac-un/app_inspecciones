import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:provider/provider.dart';
import 'package:inspecciones/router.gr.dart';

class UserDrawer extends StatelessWidget {
  DjangoAPI api = DjangoAPI();
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    final authState = authBloc.state;

    if (authState is Authenticated) {
      return SafeArea(
        child: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: ListView(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).backgroundColor,
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: UserAccountsDrawerHeader(
                          accountName: Text(
                            (authBloc.state as Authenticated).usuario.esAdmin
                                ? "Administrador"
                                : "Inspector",
                                style: TextStyle(fontSize: 15),
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
                    Opciones(),
                  ],
                ),
              ),
              LogOut(),
            ],
          ),
        ),
      );
    } else {
      return const Text("error");
    }
  }
}

class Opciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    if ((authBloc.state as Authenticated).usuario.esAdmin) {
      return Column(
        children: <Widget>[
          ListTile(
            tileColor: Theme.of(context).accentColor,
            title: const Text('Creación de Inspecciones',
                style: TextStyle(color: Colors.white, fontSize: 15)),
            leading: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onTap: () async {
              final res =
                  await ExtendedNavigator.of(context).pushCreacionFormPage();
              if (res != null && res is String) {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text(res)));
              }
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
          /* ListTile(
                title: const Text('Ver tabla Sistema',
                    style: TextStyle(color: Colors.black, fontSize: 15)),
                leading: const Icon(
                  Icons.view_array,
                  color: Colors.black,
                ),
                onTap: () async {
                  print(await api.getContratistas());
                },
              ), */
          const SizedBox(height: 5.0),
          ListTile(
            title: const Text(
              'Reiniciar base de datos',
              style: TextStyle(/* color: Colors.white, */ fontSize: 15),
            ),
            leading: const Icon(
              Icons.replay_outlined,
              color: Colors.black,
            ),
            onTap: () => getIt<Database>().dbdePrueba(),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class LogOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 150.0, bottom: 50),
      child: Container(
        width: double.infinity,
        /* 
                    alignment: FractionalOffset.bottomCenter, */
        child: ListTile(
            title: const Text('Cerrar Sesión'),
            leading: const Icon(Icons.exit_to_app, color: Colors.black),
            onTap: () => authBloc.add(const AuthEvent.loggingOut())),
      ),
    );
  }
}
