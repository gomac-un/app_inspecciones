import 'package:auto_route/auto_route.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/pages/inicio_inspeccion_form_widget.dart';
import 'package:inspecciones/presentation/widgets/drawer.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

//TODO: creacion de inpecciones con excel
//TODO: A futuro, Implementar que se puedan seleccionar varias inspecciones para eliminarlas.
/// Pantalla con lista de todas las inspecciones pendientes por subir.
class BorradoresPage extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return MultiProvider(
      providers: [
        RepositoryProvider(
            create: (ctx) => getIt<InspeccionesRepository>(
                param1: authBloc.state.maybeWhen(
                    authenticated: (u, s) => u.token,
                    orElse: () => throw Exception(
                        "Error inesperado: usuario no encontrado")))),
        RepositoryProvider(create: (_) => getIt<Database>()),
        StreamProvider(
            create: (_) => getIt<Database>().borradoresDao.borradores()),
      ],
      child: this,
    );
  }

  const BorradoresPage();

  @override
  Widget build(BuildContext context) {
    final db = RepositoryProvider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inspecciones',
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                ExtendedNavigator.of(context)
                    .push(Routes.historyInspeccionesPage);
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/logo-gomac.png",
              /* width: media.orientation == Orientation.portrait
                  ? media.size.width * 0.06
                  : media.size.height * 0.06, */
            ),
          ),
        ],
      ),
      drawer: UserDrawer(),
      body: Consumer<List<Borrador>>(
        // Toco usar un proviedr porque estaba creando el stream en cada rebuild
        //stream: Provider.of<Stream<List<Borrador>>>(context),
        builder: (context, borradores, child) {
          /*
                if (snapshot.hasError) {
                  //throw snapshot.error;
                  return Text("error: ${snapshot.error}");
                }*/
          if (borradores == null) {
            return const Align(
              child: CircularProgressIndicator(),
            );
          }

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
              final criticidad =
                  borrador.inspeccion.estado == EstadoDeInspeccion.finalizada
                      ? 'Criticidad total inicial: '
                      : 'Criticidad parcial inicial: ';
              bool loading = true;
              return ListTile(
                tileColor: Theme.of(context).cardColor,
                title: Text(
                    "${borrador.activo.id} - ${borrador.activo.modelo} (${borrador.cuestionario.tipoDeInspeccion})",
                    style: Theme.of(context).textTheme.subtitle1),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      "Estado: ${EnumToString.convertToString(borrador.inspeccion.estado, camelCase: true)}",
                    ),
                    Text(
                      "Avance del cuestionario: ${((borrador.avance / borrador.total) * 100).round()}%",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(f == null
                        ? ''
                        : "Fecha de guardado: ${f.day}/${f.month}/${f.year} ${f.hour}:${f.minute}"),
                    Text(
                      '$criticidad ${borrador.inspeccion.criticidadTotal}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      'Criticidad reparaciones pendientes: ${borrador.inspeccion.criticidadReparacion}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),

                /// Solo se puede subir al server si está finalizado o enReparacion
                leading: IconButton(
                    icon: Icon(
                      Icons.cloud_upload,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          loading = true;
                          return AlertDialog(
                            content: Row(
                              children: const [
                                CircularProgressIndicator(),
                                SizedBox(
                                  width: 20,
                                ),
                                Text("Enviando")
                              ],
                            ),
                            actions: [
                              Center(
                                child: RaisedButton(
                                  onPressed: () {
                                    loading = false;
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Ocultar'),
                                ),
                              )
                            ],
                          );
                        },
                      );
                      final res = await RepositoryProvider.of<
                              InspeccionesRepository>(context)
                          .subirInspeccion(borrador.inspeccion)
                          .then((res) => res.fold(
                                  (fail) => fail.when(
                                      pageNotFound: () =>
                                          'No se pudo encontrar la página, informe al encargado',
                                      noHayConexionAlServidor: () =>
                                          "No hay conexión al servidor",
                                      noHayInternet: () =>
                                          "No tiene conexión a internet",
                                      serverError: (msg) =>
                                          "Error interno: $msg",
                                      credencialesException: () =>
                                          'Error inesperado: intente inciar sesión nuevamente'),
                                  (u) {
                                RepositoryProvider.of<InspeccionesRepository>(
                                        context)
                                    .eliminarInfoInspeccion(borrador);
                                return "exito";
                              }));
                      if (loading) {
                        Navigator.of(context).pop();
                      }
                      res == 'exito'
                          ? showDialog(
                              context: context,
                              barrierColor: Theme.of(context).primaryColorLight,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  contentTextStyle:
                                      Theme.of(context).textTheme.headline5,
                                  title: const Icon(Icons.done_sharp,
                                      size: 100, color: Colors.green),
                                  actions: [
                                    Center(
                                      child: RaisedButton(
                                        color: Theme.of(context).accentColor,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Aceptar'),
                                      ),
                                    )
                                  ],
                                  content: const Text(
                                    'Inspección enviada correctamente',
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            )
                          : Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(res),
                            ));
                    }),

                trailing: borrador.inspeccion.esNueva
                    ? IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => eliminarBorrador(borrador, context),
                      )
                    : const SizedBox.shrink(),
                onTap: () => ExtendedNavigator.of(context).push(
                  Routes.llenadoFormPage,
                  arguments: LlenadoFormPageArguments(
                    activo: borrador.activo.id,
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

  ///Elimia [borrador].
  void eliminarBorrador(Borrador borrador, BuildContext context) {
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
            .eliminarBorrador(borrador);
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

/// Botón de creación de inspecciones
class FloatingActionButtonInicioInspeccion extends StatelessWidget {
  const FloatingActionButtonInicioInspeccion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final orientacion = MediaQuery.of(context).orientation;
    double textSize = orientacion == Orientation.portrait
        ? media.width * 0.02
        : media.height * 0.03;
    double iconSize = orientacion == Orientation.portrait
        ? media.width * 0.04
        : media.height * 0.04;
    if (media.width < 600 || media.height < 600) {
      textSize = orientacion == Orientation.portrait
          ? media.width * 0.04
          : media.height * 0.04;
      iconSize = orientacion == Orientation.portrait
          ? media.width * 0.05
          : media.height * 0.05;
    }
    final form = FormGroup(
      {'mostrar': FormControl<bool>(value: false)},
    );
    return FloatingActionButton.extended(
      onPressed: () async {
        final repository =
            RepositoryProvider.of<InspeccionesRepository>(context);
        final res = await showDialog<LlenadoFormPageArguments>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Inicio de inspección',
            ),
            content: InicioInspeccionForm(repository),
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
      icon: Icon(
        Icons.add,
        size: iconSize,
      ),
      label: Text("Inspección",
          style: TextStyle(
            fontSize: textSize,
          )),
    );
  }
}
