import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/presentation/widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
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
      drawer: UserDrawer(),
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

