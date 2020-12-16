import 'package:auto_route/auto_route.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/crear_cuestionario_form/llenar_cuestionario_form_bloc.dart';
import 'package:inspecciones/presentation/pages/login_screen.dart';
import 'package:inspecciones/presentation/pages/llenar_cuestionario_form_page.dart';
import '../../infrastructure/moor_database.dart';
import '../../injection.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:inspecciones/application/crear_cuestionario_form/seleccion_activo_inspeccion_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:auto_route/auto_route.dart';
import '../../router.gr.dart';
import 'package:provider/provider.dart';
import 'package:inspecciones/infrastructure/database/usuario.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/router.gr.dart';

import '../../infrastructure/moor_database.dart';

class BorradoresPage extends StatelessWidget {
  final Database _db = getIt<Database>();

  BorradoresPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borradores'),
      ),
      drawer: Opciones(),
      body: StreamBuilder<List<Borrador>>(
        stream: _db.borradoresDao.borradores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          final borradores = snapshot.data;

          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: borradores.length,
            itemBuilder: (context, index) {
              final borrador = borradores[index];
              final f = borrador.inspeccion.momentoBorradorGuardado;
              final fechaBorrador = f == null
                  ? ''
                  : "Fecha de guardado: ${f.day}/${f.month}/${f.year} ${f.hour}:${f.minute} \n";
              return ListTile(
                tileColor: Theme.of(context).cardColor,
                title: Text(borrador.activo.identificador +
                    " - " +
                    borrador.activo.modelo),
                subtitle: Text(
                    "Tipo de inspeccion: ${borrador.cuestionarioDeModelo.tipoDeInspeccion} \n" +
                        "$fechaBorrador Estado: " +
                        EnumToString.convertToString(
                            borrador.inspeccion.estado)),
                leading: Icon(Icons.edit),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => eliminarBorrador(borradores[index], context),
                ),
                onTap: () => ExtendedNavigator.of(context).push(
                  Routes.llenadoFormPage,
                  arguments: LlenadoFormPageArguments(
                    vehiculo: borrador.activo.identificador,
                    cuestionarioId: borrador.inspeccion.cuestionarioId,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _inicioInspeccion(context),
        icon: Icon(Icons.add),
        label: Text("Inspeccion"),
        onPressed: () {
          //TODO: implementar la subida de inspecciones al server
          throw Exception();
        },
        icon: Icon(Icons.upload_file),
        label: Text("Subir inspecciones"),
      ),
    );
  }

  void eliminarBorrador(Borrador borrador, BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () => Navigator.of(context).pop(), // OJO con el context
    );
    Widget continueButton = FlatButton(
      child: Text("Eliminar"),
      onPressed: () async {
        Navigator.of(context).pop();
        await _db.borradoresDao.eliminarBorrador(borrador);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Borrador eliminado"),
          duration: Duration(seconds: 3),
        ));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("¿Está seguro que desea eliminar este borrador?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

//Creacion de inspecciones
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

class Opciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Usuario usuario = Provider.of<Usuario>(context);
    return SafeArea(
      child: new Drawer(
        child: ListView(
          children: <Widget>[
            /* Container(color: Colors.deepPurple[100], height:56), */
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
                  /* decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/1200px-User_icon_2.svg.png"),
                              fit: BoxFit.fitHeight,
                              alignment: Alignment.bottomRight,
                              ),
                              
                              ), */
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
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.bottomRight,
              height: 500,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0, left: 160.0),
                child: ListTile(
                    title: Text('Cerrar Sesión'),
                    leading: Icon(Icons.exit_to_app),
                    onTap: () => {
                          Navigator.pop(context),
                          Navigator.of(context).pushReplacementNamed('/'),
                        }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}