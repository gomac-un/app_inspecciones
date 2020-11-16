import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/application/crear_cuestionario_form/llenar_cuestionario_form_bloc.dart';

import 'package:inspecciones/presentation/pages/llenar_cuestionario_form_page.dart';
import '../../infrastructure/moor_database_llenado.dart';
import '../../injection.dart';
import 'login_screen.dart';

@injectable
class BorradoresPage extends StatelessWidget {
  void _pushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

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
                subtitle: Text(
                    borradores[index].cuestionarioDeModelo.tipoDeInspeccion),
                leading: Icon(Icons.edit),
                trailing: Icon(Icons.delete),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LlenarCuestionarioFormPage(
                      LlenarCuestionarioFormBloc.withBorrador(
                        getIt<Database>(),
                        borradores[index],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
