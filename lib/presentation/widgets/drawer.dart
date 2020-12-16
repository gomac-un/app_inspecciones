import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:provider/provider.dart';
import 'package:inspecciones/router.gr.dart';

class UserDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    final authState = authBloc.state;
    if (!(authState is Authenticated)) return Text("error");
    if (authState is Authenticated)
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
                      (authBloc.state as Authenticated).usuario.esAdministrador
                          ? "Administrador"
                          : "inspector",
                    ),
                    accountEmail: Text(authState.usuario.documento),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text(
                        authState.usuario.documento[0],
                        style: TextStyle(fontSize: 35),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              ListTile(
                selectedTileColor: Colors.deepPurple,
                title: Text('Creación de Inspecciones',
                    style: TextStyle(/* color: Colors.white ,*/ fontSize: 15)),
                leading: Icon(
                  Icons.add, /* color: Colors.white, */
                ),
                onTap: () =>
                    ExtendedNavigator.of(context).pushCreacionFormPage(),
              ),
              SizedBox(
                height: 5.0,
              ),
              ListTile(
                tileColor: Colors.deepPurple,
                title: Text('Ver base de Datos',
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                leading: Icon(
                  Icons.view_array,
                  color: Colors.white,
                ),
                onTap: () => {
                  Navigator.pop(context),
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MoorDbViewer(
                        getIt<Database>(),
                      ),
                    ),
                  ),
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              ListTile(
                tileColor: Colors.deepPurple,
                title: Text(
                  'Reiniciar base de datos',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                leading: Icon(
                  Icons.replay_outlined,
                  color: Colors.white,
                ),
                onTap: () => getIt<Database>().dbdePrueba(),
              ),
              SizedBox(
                height: 200.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 160.0),
                child: ListTile(
                    title: Text('Cerrar Sesión'),
                    leading: Icon(Icons.exit_to_app),
                    onTap: () => authBloc.add(LoggingOut())),
              ),
            ],
          ),
        ),
      );
  }
}
