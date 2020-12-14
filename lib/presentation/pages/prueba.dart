import 'package:provider/provider.dart';
import 'package:inspecciones/infrastructure/database/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/crear_cuestionario_form_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/presentation/pages/crear_cuestionario_form_page.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import '../../injection.dart';

class ContratistaScreen extends StatelessWidget {
  void _pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de Administrador'),
      ),
      drawer: Opciones(),
      body: ListView(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              getIt<Database>().exportarInspeccion();
            },
            child: Text("exportarInspeccion"),
          ),
        ],
      ),
    );
  }
}

class Opciones extends StatelessWidget {
  void _pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    Usuario usuario = Provider.of<Usuario>(context);
    return SafeArea(
      child: new Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: ListView(
            children: <Widget> [
            Container(
              color: Colors.lightBlue,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: UserAccountsDrawerHeader(
                  accountName: Text(
                    "Inspector",
                  ),
                  accountEmail: Text(usuario.documento),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      usuario.documento[0],
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ),
            ),
              SizedBox(height: 20.0),
              SizedBox(
                height: 5.0,
              ),
              ListTile(
                  tileColor: Colors.lightBlue,
                  title: Text('Creación de Inspecciones'),
                  leading: Icon(Icons.add),
                  onTap: () => {
                        Navigator.pop(context),
                        _pushScreen(
                          context,
                          BlocProvider(
                            create: (context) =>
                                CrearCuestionarioFormBloc(getIt<Database>()),
                            child: CrearCuestionarioFormPage(),
                          ),
                        ),
                      }),
              SizedBox(
                height: 5.0,
              ),
              ListTile(
                tileColor: Colors.lightBlue,
                title: Text('Ver base de Datos'),
                leading: Icon(Icons.view_array),
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
                tileColor: Colors.lightBlue,
                title: Text('Reiniciar base de datos'),
                leading: Icon(Icons.replay_outlined),
                onTap: () => getIt<Database>().dbdePrueba(),
              ),
              SizedBox(
                height: 150.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 160.0),
                  child: ListTile(
                      title: Text('Cerrar Sesión'),
                      leading: Icon(Icons.exit_to_app),
                      onTap: () => {
                            Navigator.pop(context),
                            Navigator.of(context).pushReplacementNamed('/'),
                          }),
                ),
           ],
          ),
        ),
      ),
    );
  }
}
