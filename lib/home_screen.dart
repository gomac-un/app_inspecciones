import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_screen.dart';
import 'blocs/counter_bloc.dart';
import 'login_screen.dart';
import 'create_inspection.dart';
import 'list_of_inspections.dart';
import 'inspeccion_screen.dart';

class HomeScreen extends StatelessWidget {
  void _pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final counterBloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantallas de ejemplo'),
      ),
      body: ListView(
        children: <Widget>[
          /*ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text('Counter'),
            trailing: Chip(
              label: Text('Local state'),
              backgroundColor: Colors.blue[800],
            ),
            onTap: () => _pushScreen(context, CounterScreenWithLocalState()),
          ),
          ListTile(
            leading: Icon(Icons.add_circle_outline),
            title: Text('Counter'),
            subtitle: BlocBuilder(
              builder: (context, state) => Text('$state'),
              cubit: counterBloc,
            ),
            trailing: Chip(
              label: Text('Global state'),
              backgroundColor: Colors.blue[800],
            ),
            onTap: () => _pushScreen(context, CounterScreenWithGlobalState()),
            onLongPress: () => counterBloc.add(CounterEvent.increment),
          ),*/
          ListTile(
            title: Chip(label: Text('Ingreso')),
            onTap: () => _pushScreen(context, LoginScreen()),
          ),
          ListTile(
            title: Chip(label: Text('Creación de Inspecciones')),
            onTap: () => _pushScreen(context, CreateInspectionScreen()),
          ),
          ListTile(
            title: Chip(label: Text('Llenado de Inspecciones')),
            onTap: () => _pushScreen(context, ListOfInspectionsScreen()),
          ),
        ],
      ),
    );
  }
}
