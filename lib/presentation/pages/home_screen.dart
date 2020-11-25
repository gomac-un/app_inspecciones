import 'package:auto_route/auto_route.dart';
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
import 'package:inspecciones/router.gr.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import '../../infrastructure/moor_database.dart';
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _inicioInspeccion(context),
        icon: Icon(Icons.add),
        label: Text("Inspeccion"),
      ),
    );
  }

  Future<void> _inicioInspeccion(contextHome) async {
    final formBloc = getIt<SeleccionActivoInspeccionBloc>();
    return showDialog<void>(
      //El showDialog no hace parte del arbol principal por lo cual toca guardar el contexto del home
      context: contextHome,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Inicio de inspección'),
          content:
              FormBlocListener<SeleccionActivoInspeccionBloc, String, String>(
            formBloc: formBloc,
            onSuccess: (context, state) {
              ExtendedNavigator.of(contextHome).push(
                Routes.llenarCuestionarioFormPage,
                arguments: LlenarCuestionarioFormPageArguments(
                  formBloc: LlenarCuestionarioFormBloc(
                    getIt<Database>(),
                    formBloc.vehiculo.value,
                    formBloc.tiposDeInspeccion.value.cuestionarioId,
                  ),
                ),
              );
              ExtendedNavigator.of(context).pop();
            },
            child: Container(
              width: double.maxFinite,
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
