import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/pages/inicio_inspeccion_form_widget.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';

import '../../infrastructure/moor_database.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  void _pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantallas de ejemplo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Chip(label: Text('Ingreso')),
            //onTap: () => _pushScreen(context, LoginScreen()),
          ),
          ListTile(
            title: Chip(label: Text('Creación de Inspecciones')),
            onTap: () => ExtendedNavigator.of(context).push(
              Routes.creacionFormPage,
            ),
          ),
          ListTile(
            title: Chip(label: Text('Borradores')),
            onTap: () => ExtendedNavigator.of(context).push(
              Routes.borradoresPage,
              arguments: BorradoresPageArguments(db: getIt<Database>()),
            ),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MoorDbViewer(getIt<Database>())));
            },
            child: Text("ver BD"),
          ),
          RaisedButton(
            onPressed: () {
              getIt<Database>().dbdePrueba();
            },
            child: Text("Reiniciar BD"),
          ),
          RaisedButton(
            onPressed: () {
              getIt<Database>().exportarInspeccion();
            },
            child: Text("exportarInspeccion"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButtonInicioInspeccion(),
    );
  }
}

class FloatingActionButtonInicioInspeccion extends StatelessWidget {
  const FloatingActionButtonInicioInspeccion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final res = await showDialog<LlenadoFormPageArguments>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Inicio de inspección'),
            content: InicioInspeccionForm(),
          ),
        );

        if (res != null) {
          final mensajeLlenado = await ExtendedNavigator.of(context)
              .push(Routes.llenadoFormPage, arguments: res);
          // mostar el mensaje que viene desde la pantalla de llenado
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("$mensajeLlenado")));
        }
      },
      icon: Icon(Icons.add),
      label: Text("Inspeccion"),
    );
  }
}
