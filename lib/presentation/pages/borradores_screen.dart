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
class BorradoresPage extends StatelessWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return MultiProvider(
      providers: [
        RepositoryProvider(
            create: (ctx) => getIt<InspeccionesRepository>(
                param1: authBloc.state.maybeWhen(
                    authenticated: (u) => u.token,
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
    /* final media = MediaQuery.of(context);
    double scaffoldTtitleSize = media.orientation == Orientation.portrait
        ? media.size.height * 0.02
        : media.size.width * 0.02;
    if (media.size.width < 600 || media.size.height < 600) {
      scaffoldTtitleSize = media.orientation == Orientation.portrait
          ? media.size.height * 0.028
          : media.size.width * 0.028;
    } */
    final db = RepositoryProvider.of<Database>(context);
    return Scaffold(
      appBar: AppBar(
        /* toolbarHeight: media.orientation == Orientation.portrait
            ? media.size.height * 0.07
            : media.size.width * 0.07, */
        title: const Text(
          'Inspecciones',
          /* style: TextStyle(
              fontSize: scaffoldTtitleSize,
            ) */
        ),
        actions: [
          // ExtendedNavigator.of(context)
          //     .push(Routes.llenadoFormPage, arguments: res)
          IconButton(icon: Icon(Icons.history), onPressed: (){ ExtendedNavigator.of(context).push(Routes.historyInspeccionesPage);}),
          /* IconButton(
            onPressed: () {
              //TODO: implementar la subida de todas las inspecciones pendientes
              throw Exception();
            },
            icon: const Icon(
              Icons.upload_file,
              /*  size: media.orientation == Orientation.portrait
                  ? media.size.height * 0.03
                  : media.size.width * 0.03, */
            ),
            tooltip: "Subir inspecciones",
          ),
          const SizedBox(
            width: 5,
          ), */
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
      /* media.size.width <= 600 || media.size.height <= 600
          ? UserDrawer()
          : null, */
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
                leading: [
                  EstadoDeInspeccion.finalizada,
                  EstadoDeInspeccion.enReparacion
                ].contains(borrador.inspeccion.estado)
                    ? IconButton(
                        icon: Icon(
                          Icons.cloud_upload,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () async {
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
                                    db.borradoresDao.eliminarBorrador(borrador);
                                    return "exito";
                                  }));
                          res == 'exito'
                              ? showDialog(
                                  context: context,
                                  barrierColor:
                                      Theme.of(context).primaryColorLight,
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
                                            color:
                                                Theme.of(context).accentColor,
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
                        })
                    : const SizedBox(),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => eliminarBorrador(borrador, context),
                ),
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
      ), floatingActionButton: const FloatingActionButtonInicioInspeccion(),
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
        /* final res = RepositoryProvider.of<InspeccionesRepository>(context)
            .getMostrarAlerta();
        if (res == null) {
          showGeneralDialog(
            context: context,
            barrierColor: Colors.black12.withOpacity(0.6), // Background color
            barrierDismissible: false,
            barrierLabel: 'Dialog',
            transitionDuration: const Duration(
                milliseconds:
                    400), // How long it takes to popup dialog after button click
            pageBuilder: (_, __, ___) {
              // Makes widget fullscreen
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: media.width * 0.5,
                            /* decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    //                   <--- left side
                                    color: Colors.white,
                                    width: 3.0,
                                  ),
                                ),
                              ), */
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      size: 50,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    Icon(
                                      Icons.add,
                                      size: iconSize,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Crear una inspección desde cero',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/images/inicioInspeccion.png",
                                    width: media.width * 0.4,
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: media.width * 0.5,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 50,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      Icon(
                                        Icons.edit,
                                        size: iconSize,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Continuar una inspección que inició otro usuario ',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/images/inicioInspeccion.png",
                                      width: media.width * 0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                  Material(
                    color: Colors.transparent,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white, width: 2.5)),
                        width: 16,
                        height: 18,
                        child: ReactiveCheckbox(
                          checkColor: Colors.white,
                          formControl:
                              form.control('mostrar') as FormControl<bool>,
                        ),
                      ),
                      const Text('No mostrar de nuevo',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ]),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Aceptar'),
                  ),
                ],
              );
            },
          ); */
        /* showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: new Text("Material Dialog"),
                    content: new Text("Hey! I'm Coflutter!"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Close me!'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  )); */
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
