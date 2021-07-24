import 'package:auto_route/auto_route.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/widgets/drawer.dart';
import 'package:inspecciones/presentation/widgets/alertas.dart';
import 'package:inspecciones/presentation/widgets/loading_dialog.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:provider/provider.dart';
import '../../infrastructure/moor_database.dart';

//TODO: creacion de inpecciones con excel
/// Pantalla que muestra la lista de cuestionarios subidos y en proceso.
class CuestionariosPage extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (ctx) => getIt<InspeccionesRepository>(
                param1: authBloc.state.maybeWhen(
                    authenticated: (u, s) => u.token,
                    orElse: () => throw Exception(
                        "Error inesperado: usuario no encontrado")))),
        RepositoryProvider(create: (_) => getIt<Database>()),
      ],
      child: this,
    );
  }

  const CuestionariosPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cuestionarios'),
        ),
        drawer: UserDrawer(),
        body: StreamBuilder<List<Cuestionario>>(
          /// Se reconstruye automaticamente con los cuestionarios que se van agregando.
          stream: RepositoryProvider.of<Database>(context)
              .borradoresDao
              .getCuestionarios(),
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
            final cuestionarios = snapshot.data;

            /// no hay cuestionarios creados
            if (cuestionarios.isEmpty) {
              return Center(
                  child: Text(
                "No tiene cuestionarios por subir",
                style: Theme.of(context).textTheme.headline5,
              ));
            }

            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: cuestionarios.length,
              itemBuilder: (context, index) {
                final cuestionario = cuestionarios[index];
                return ListTile(
                    tileColor: Theme.of(context).cardColor,
                    title: Text(cuestionario.tipoDeInspeccion),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Código: ${cuestionario.id}'),
                        Text(cuestionario.esLocal
                            ? 'Sin subir \nEstado: ${EnumToString.convertToString(cuestionario.estado)}'
                            : 'Subido \nEstado: ${EnumToString.convertToString(cuestionario.estado)}'),
                      ],
                    ),

                    /// Si no se ha subido apaarece la opción de subir.
                    leading: cuestionario.esLocal
                        ? IconButton(
                            icon: const Icon(Icons.cloud_upload),
                            onPressed: () async {
                              final estado = cuestionario.estado;

                              /// Solo permite subirlo si está finalizado.
                              if (estado == EstadoDeCuestionario.finalizada) {
                                final res = await RepositoryProvider.of<
                                        InspeccionesRepository>(context)
                                    .subirCuestionario(cuestionario)
                                    .then((res) => res.fold(
                                        (fail) => fail.when(
                                            noHayConexionAlServidor: () =>
                                                "No hay conexion al servidor",
                                            noHayInternet: () =>
                                                "No hay internet",
                                            serverError: (msg) =>
                                                "Error inesperado: $msg",
                                            credencialesException: () =>
                                                'Error, intente inciar sesión nuevamente',
                                            pageNotFound: () =>
                                                'No se pudo encontrar la página, informe al encargado'),
                                        (u) =>
                                            "El cuestionario ha sido enviado"));
                                res == 'El cuestionario ha sido enviado'
                                    ? mostrarMensaje(context, 'exito', res,
                                        ocultar: false)
                                    : Scaffold.of(context)
                                        .showSnackBar(SnackBar(
                                        content: Text(res),
                                      ));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Advertencia'),
                                    content: const Text(
                                        "Aún no ha finalizado este cuestionario, no puede ser enviado."),
                                    actions: [
                                      FlatButton(
                                        textColor: Colors.blue,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Aceptar"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            })
                        : const SizedBox.shrink(),
                    trailing: cuestionario.esLocal
                        ? IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                eliminarCuestionario(cuestionario, context),
                          )
                        : Icon(Icons.cloud,
                            color: Theme.of(context).accentColor),

                    /// Los cuestionarios subidos ya no se pueden borrar
                    onTap: () async {
                      LoadingDialog.show(context);
                      // Se está haciendo esta consulta antes de cargar la pantalla de creacion
                      // Cuando son muchos bloques, tarda demasiado en pasar a la próxima pantalla.
                      //TODO: mirar como refactorizar esta parte.
                      final cuestionarioDeModelo =
                          await RepositoryProvider.of<Database>(context)
                              .borradoresDao
                              .cargarCuestionarioDeModelo(cuestionario);
                      final bloquesBD =
                          await RepositoryProvider.of<Database>(context)
                              .creacionDao
                              .cargarCuestionario(cuestionario.id);
                      LoadingDialog.hide(context);

                      ExtendedNavigator.of(context).push(
                        Routes.creacionFormPage,
                        arguments: CreacionFormPageArguments(
                          cuestionario: cuestionario,
                          cuestionarioDeModelo: cuestionarioDeModelo,
                          bloques: bloquesBD,
                        ),
                      );
                    } /* => {cargarCreacionPage(cuestionario, context)}, */
                    );
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const Padding(
          padding: EdgeInsets.all(8.0),
          child: FloatingActionButtonCreacionCuestionario(),
        ));
  }

  /// Elimina [cuestionario] y todas sus preguntas
  void eliminarCuestionario(Cuestionario cuestionario, BuildContext context) {
    // set up the buttons
    final cancelButton = FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text("Cancelar"), // OJO con el context
    );
    final Widget continueButton = FlatButton(
      onPressed: () async {
        Navigator.of(context).pop();
        await RepositoryProvider.of<Database>(context)
            .borradoresDao
            .eliminarCuestionario(cuestionario);
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text("Cuestionario eliminado"),
          duration: Duration(seconds: 3),
        ));
      },
      child: const Text("Eliminar"),
    );
    // set up the AlertDialog
    final alert = AlertDialog(
      title: const Text("Alerta"),
      content: const Text("¿Está seguro que desea eliminar este cuestionario?"),
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

/// Botón de creación de cuestionarios
class FloatingActionButtonCreacionCuestionario extends StatelessWidget {
  const FloatingActionButtonCreacionCuestionario({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final res = await ExtendedNavigator.of(context).pushCreacionFormPage();
        // mostar el mensaje que viene desde la pantalla de llenado
        if (res != null) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("$res")));
        }
      },
      icon: const Icon(Icons.add),
      label: const Text("Cuestionario"),
    );
  }
}
