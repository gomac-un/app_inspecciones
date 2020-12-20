import 'package:auto_route/auto_route.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/pages/inicio_inspeccion_form_widget.dart';
import 'package:inspecciones/presentation/widgets/drawer.dart';
import 'package:inspecciones/router.gr.dart';

import '../../infrastructure/moor_database.dart';

class BorradoresPage extends StatelessWidget {
  final Database _db = getIt<Database>();

  BorradoresPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Borradores'),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: implementar la subida de inspecciones al server
              throw Exception();
            },
            icon: const Icon(Icons.upload_file),
            tooltip: "Subir inspecciones",
          ),
        ],
      ),
      drawer: UserDrawer(),
      body: StreamBuilder<List<Borrador>>(
        stream: _db.borradoresDao.borradores(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //throw snapshot.error;
            return Text("error: ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return const Align(
              child: CircularProgressIndicator(),
            );
          }
          final borradores = snapshot.data;

          if (borradores.isEmpty) {
            return Center(
                child: Text(
              "No tiene borradores sin terminar",
              style: Theme.of(context).textTheme.headline5,
            ));
          }

          return ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemCount: borradores.length,
            itemBuilder: (context, index) {
              final borrador = borradores[index];
              final f = borrador.inspeccion.momentoBorradorGuardado;
              final fechaBorrador = f == null
                  ? ''
                  : "Fecha de guardado: ${f.day}/${f.month}/${f.year} ${f.hour}:${f.minute} \n";
              return ListTile(
                tileColor: Theme.of(context).cardColor,
                title: Text(
                    "${borrador.activo.identificador} - ${borrador.activo.modelo}"),
                subtitle: Text(
                    "Tipo de inspeccion: ${borrador.cuestionario.tipoDeInspeccion} \n" +
                        "$fechaBorrador Estado: " +
                        EnumToString.convertToString(
                            borrador.inspeccion.estado)),
                leading: const Icon(Icons.edit),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => eliminarBorrador(borradores[index], context),
                ),
                onTap: () => ExtendedNavigator.of(context).push(
                  Routes.llenadoFormPage,
                  arguments: LlenadoFormPageArguments(
                    vehiculo: borrador.activo.identificador,
                    cuestionarioId: borrador.inspeccion.cuestionarioId,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: const FloatingActionButtonInicioInspeccion(),
    );
  }

  void eliminarBorrador(Borrador borrador, BuildContext context) {
    // set up the buttons
    final cancelButton = FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text("Cancelar"), // OJO con el context
    );
    final Widget continueButton = FlatButton(
      onPressed: () async {
        Navigator.of(context).pop();
        await _db.borradoresDao.eliminarBorrador(borrador);
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text("Borrador eliminado"),
          duration: Duration(seconds: 3),
        ));
      },
      child: const Text("Eliminar"),
    );
    // set up the AlertDialog
    final alert = AlertDialog(
      title: const Text("Alerta"),
      content: const Text("¿Está seguro que desea eliminar este borrador?"),
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
