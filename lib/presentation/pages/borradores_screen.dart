import 'package:auto_route/auto_route.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'package:inspecciones/router.gr.dart';
import '../../infrastructure/moor_database.dart';

@injectable
class BorradoresPage extends StatelessWidget {
  Database _db;

  BorradoresPage(this._db);

  @override
  Widget build(BuildContext context) {
    //final counterBloc = BlocProvider.of<CounterBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Borradores'),
      ),
      body: StreamBuilder<List<Borrador>>(
        stream: _db.borradores(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          final borradores = snapshot.data;

          return ListView.builder(
            itemCount: borradores.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(borradores[index].activo.identificador +
                    " - " +
                    borradores[index].activo.modelo),
                subtitle: Text("Fecha de guardado: " +
                    borradores[index]
                        .inspeccion
                        .momentoBorradorGuardado
                        .toString() +
                    " - " +
                    "Estado: " +
                    EnumToString.convertToString(
                        borradores[index].inspeccion.estado)),
                leading: Icon(Icons.edit),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => eliminarBorrador(borradores[index], context),
                ),
                onTap: () => ExtendedNavigator.of(context).push(
                  Routes.llenadoFormPage,
                  arguments: LlenadoFormPageArguments(
                    vehiculo: borradores[index].activo.identificador,
                    cuestionarioId: borradores[index].inspeccion.cuestionarioId,
                  ),
                ),
              );
            },
          );
        },
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
        await _db.eliminarBorrador(borrador);
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
