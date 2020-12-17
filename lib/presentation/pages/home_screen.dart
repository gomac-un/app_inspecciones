import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/pages/inicio_inspeccion_form_widget.dart';
import 'package:inspecciones/presentation/widgets/drawer.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantallas de ejemplo'),
      ),
      drawer: UserDrawer(),
      body: const ListaDeOpciones(),
      floatingActionButton: const FloatingActionButtonInicioInspeccion(),
    );
  }
}

class ListaDeOpciones extends StatelessWidget {
  const ListaDeOpciones({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const ListTile(
          title: Chip(label: Text('Ingreso')),
          //onTap: () => _pushScreen(context, LoginScreen()),
        ),
        ListTile(
          title: const Chip(label: Text('Creación de Inspecciones')),
          onTap: () async {
            final res =
                await ExtendedNavigator.of(context).pushCreacionFormPage();
            if (res != null && res is String) {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(res)));
            }
          },
        ),
        ListTile(
          title: const Chip(label: Text('Borradores')),
          onTap: () => ExtendedNavigator.of(context).pushBorradoresPage(),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MoorDbViewer(getIt<Database>())));
          },
          child: const Text("ver BD"),
        ),
        RaisedButton(
          onPressed: () {
            getIt<Database>().dbdePrueba();
          },
          child: const Text("Reiniciar BD"),
        ),
        RaisedButton(
          onPressed: () {
            getIt<Database>().exportarInspeccion();
          },
          child: const Text("exportarInspeccion"),
        ),
      ],
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
            title: const Text('Inicio de inspección'),
            content: InicioInspeccionForm(),
          ),
        );

        if (res != null) {
          final mensajeLlenado = await ExtendedNavigator.of(context)
              .push(Routes.llenadoFormPage, arguments: res);
          // mostar el mensaje que viene desde la pantalla de llenado
          if (mensajeLlenado != null) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("$mensajeLlenado")));
          }
        }
      },
      icon: const Icon(Icons.add),
      label: const Text("Inspeccion"),
    );
  }
}
