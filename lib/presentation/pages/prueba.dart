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
          child: ListView(
            children: <Widget> [
            Container(
              color: Colors.lightBlue,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: UserAccountsDrawerHeader(
                  accountName: Text(
                    "Administrador",
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
                  selectedTileColor: Colors.deepPurple,
                  title: Text('Creación de Inspecciones',style: TextStyle(/* color: Colors.white ,*/fontSize: 15)),
                  leading: Icon(Icons.add,/* color: Colors.white, */),
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
                tileColor: Colors.deepPurple,
                title: Text('Ver base de Datos',style: TextStyle(color: Colors.white,fontSize: 15)),
                leading: Icon(Icons.view_array,color: Colors.white,),
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
                title: Text('Reiniciar base de datos',style: TextStyle(color: Colors.white,fontSize: 15),),
                leading: Icon(Icons.replay_outlined,color: Colors.white,),
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
                      onTap: () => {
                            Navigator.pop(context),
                            Navigator.of(context).pushReplacementNamed('/'),
                          }),
                ),
           ],
          ),
        ),
    );
  }
}
