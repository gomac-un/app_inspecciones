import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:inspecciones/application/crear_cuestionario_form/crear_cuestionario_form_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/llenar_cuestionario_form_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/seleccion_activo_inspeccion_bloc.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/pages/borradores_screen.dart';

import 'package:inspecciones/presentation/pages/llenar_cuestionario_form_page.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import '../../infrastructure/moor_database_llenado.dart';
import 'crear_cuestionario_form_page.dart';
import 'login_screen.dart';

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
            onTap: () => _pushScreen(
              context,
              BlocProvider(
                create: (context) =>
                    CrearCuestionarioFormBloc(getIt<Database>()),
                child: CrearCuestionarioFormPage(),
              ),
            ),
          ),
          ListTile(
            title: Chip(label: Text('Llenado de Inspecciones')),
            onTap: () => _pushScreen(
              context,
              BlocProvider(
                create: (context) => getIt<LlenarCuestionarioFormBloc>(),
                child: LLenarCuestionarioFormPage(),
              ),
            ),
          ),
          ListTile(
            title: Chip(label: Text('Borradores')),
            onTap: () =>
                _pushScreen(context, BorradoresPage(getIt<Database>())),
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
              GetIt.I<Database>().dbdePrueba();
            },
            child: Text("Reiniciar BD"),
          ),
        ],
      ),
      floatingActionButton: BlocProvider(
        create: (BuildContext context) =>
            getIt<SeleccionActivoInspeccionBloc>(),
        child: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton.extended(
              onPressed: () => _showMyDialog(context),
              icon: Icon(Icons.add),
              label: Text("Inspeccion"),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showMyDialog(contextHome) async {
    return showDialog<void>(
      //El showDialog no hace parte del arbol principal por lo cual toca guardar el contexto del home
      context: contextHome,
      builder: (BuildContext context) {
        final formBloc =
            BlocProvider.of<SeleccionActivoInspeccionBloc>(contextHome);
        return AlertDialog(
          title: Text('Inicio de inspección'),
          content:
              FormBlocListener<SeleccionActivoInspeccionBloc, String, String>(
            formBloc: formBloc,
            onSuccess: (context, state) {
              Scaffold.of(contextHome).showSnackBar(SnackBar(
                content: Text(state.successResponse ?? "ok"),
                duration: Duration(seconds: 3),
              ));
              _pushScreen(
                context,
                BlocProvider(
                  create: (context) => getIt<LlenarCuestionarioFormBloc>(),
                  child: LLenarCuestionarioFormPage(),
                ),
              );
              /*Navigator.of(contextHome).push(
                MaterialPageRoute(builder: (_) => SuccessScreen())
              );*/
            },
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFieldBlocBuilder(
                    textFieldBloc: formBloc.vehiculo,
                    decoration: InputDecoration(
                      labelText: 'Escriba el ID del vehiculo',
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                  ),
                  RadioButtonGroupFieldBlocBuilder<CuestionarioDeModelo>(
                    selectFieldBloc: formBloc.tiposDeInspeccion,
                    decoration: InputDecoration(
                      labelText: 'Tipo de inspección',
                      prefixIcon: SizedBox(),
                      border: InputBorder.none,
                    ),
                    itemBuilder: (context, item) => item.tipoDeInspeccion,
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Inspeccionar'),
              onPressed: formBloc.submit,
            ),
          ],
        );
      },
    );
  }
}
