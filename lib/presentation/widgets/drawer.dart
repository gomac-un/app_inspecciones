import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:provider/provider.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDrawer extends StatelessWidget {
  //TODO: si se genera este mismo drawer en varias paginas se puede crear un stack indeseado, una solucion seria que la instancia del drawer fuera unica en toda la app
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    final authState = authBloc.state;

    bool esAdmin = false;

    /// El usuario puede acceder desde el login aun cuando no tenga internet.
    /// En ese caso, [esAdmin] es false.
    /// Si tiene internet, [esAdmin] se obtiene desde la Api
    if (authState is Authenticated) {
      if ((authBloc.state as Authenticated).usuario.esAdmin != null) {
        esAdmin = (authBloc.state as Authenticated).usuario.esAdmin;
      }
      return SafeArea(
        child: Drawer(
          child: Column(
            children: <Widget>[
              /// Información del usuario
              Expanded(
                flex: 2,
                child: ListView(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: UserAccountsDrawerHeader(
                          accountName: Text(
                            esAdmin ? "Administrador" : "Inspector",
                          ),
                          accountEmail: Text(
                            /// Nombre de usuario
                            authState.usuario.documento,
                          ),
                          currentAccountPicture: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            child: Center(
                              child: Text(
                                authState.usuario.documento[0],
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Theme.of(context).accentColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// La app muestra diferentes funcionalidades dependiendo de si [esAdmin]
                    Opciones(esAdmin: esAdmin),
                  ],
                ),
              ),

              /// Comun
              Gomac(),
            ],
          ),
        ),
      );
    } else {
      return const Text("error");
    }
  }
}

/// Widget que divide las funcionalidades para administradores e inspectores
class Opciones extends StatelessWidget {
  final bool esAdmin;

  const Opciones({Key key, this.esAdmin}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    /// Si [esAdmin] muestra pagina de creación de cuestionarios y ver bases de datos
    if (esAdmin) {
      return Column(
        children: <Widget>[
          /* Card(
            child: ExpansionTile(
              childrenPadding: const EdgeInsets.only(left: 50),
              tilePadding: EdgeInsets.zero,
              title: ListTile(
                selectedTileColor: Theme.of(context).accentColor,
                title: const Text(
                  'Planeación', /* style: TextStyle(fontSize: textSize) */
                ),
                leading: const Icon(
                  Icons.assignment,
                  color: Colors.black, /* size: iconSize */
                ),
              ),
              children: <Widget>[
                Planeacion(/* conSize: iconSize, textSize: textSize */),
              ],
            ),
          ), */
          Card(
            child: ListTile(
                focusColor: Colors.yellow,
                selectedTileColor: Theme.of(context).accentColor,
                title: const Text(
                  'Cuestionarios', //TODO: mostrar el numero de  cuestionarios creados pendientes por subir
                ),
                leading: const Icon(
                  Icons.app_registration,
                  color: Colors.black,
                ),
                onTap: () => {
                      ExtendedNavigator.of(context).pop(),
                      ExtendedNavigator.of(context)
                          .push(Routes.cuestionariosPage),
                    }),
          ),
          Borradores(),
          /*  LimpiezaBase(), */
          SincronizarConGomac(),
          /* Card(
            child: ListTile(
              title: const Text('Ver base de datos',
                  style: TextStyle(
                    color: Colors.black,
                  )),
              leading: const Icon(
                Icons.storage,
                color: Colors.black,
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MoorDbViewer(
                      getIt<Database>(),
                    ),
                  ),
                );
              },
            ),
          ), */
          LogOut(),
        ],
      );
    } else {
      return Column(
        children: [
          Borradores(),
          /* LimpiezaBase(), */
          SincronizarConGomac(),
          LogOut(),
        ],
      );
    }
  }
}

/// Lleva a lista de inspecciones pendientes
class Borradores extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        selectedTileColor: Theme.of(context).accentColor,
        title: const Text(
          'Inspecciones', //TODO: mostrar el numero de  inspecciones creadas pendientes por subir
          /* style: TextStyle(/* color: Colors.white ,*/ fontSize: textSize) */
        ),
        leading: const Icon(
          Icons.list_alt,
          color: Colors.black,
          /* size: iconSize, */ /* color: Colors.white, */
        ),
        onTap: () => {
          ExtendedNavigator.of(context).pop(),
          ExtendedNavigator.of(context).push(Routes.borradoresPage),
        },
      ),
    );
  }
}

/// Abre el sitio web de Gomac
class Gomac extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const _url = 'https://gomac.medellin.unal.edu.co';
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: double.infinity,
        /* 
                    alignment: FractionalOffset.bottomCenter, */
        child: ListTile(
          title: const Text(
            'Ir a Gomac',
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/images/logo-gomac.png",
              /* width: media.orientation == Orientation.portrait
                  ? media.size.width * 0.06
                  : media.size.height * 0.06, */
            ),
          ),
          onTap: () async => await canLaunch(_url)
              ? await launch(_url)
              : {
                  Navigator.of(context).pop(),
                  Scaffold.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'No se puede abrir el sitio, verifique su conexión'),
                    ),
                  ),
                },
        ),
      ),
    );
  }
}

/// Cierra sesión al lanzar evento [AuthEvent.loggingOut()]
class LogOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);

    return Card(
      /* 
                    alignment: FractionalOffset.bottomCenter, */
      child: ListTile(
          selectedTileColor: Theme.of(context).accentColor,
          title: const Text(
            'Cerrar Sesión',
          ),
          leading: const Icon(
            Icons.exit_to_app,
            color: Colors.black,
          ),
          onTap: () => authBloc.add(const AuthEvent.loggingOut())),
    );
  }
}

class Planeacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          selectedTileColor: Theme.of(context).accentColor,
          title: const Text('Grupos', style: TextStyle(fontSize: 13)),
          onTap: () async {
            await ExtendedNavigator.of(context).push(
              Routes.gruposScreen,
            );
            ExtendedNavigator.of(context).pop();
          },
        ),
        /*  ListTile(
          selectedTileColor: Theme.of(context).accentColor,
          title: const Text('Sistemas', style: TextStyle(fontSize: 13)),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SistemaPage(),
              ),
            );
          },
        ), */
      ],
    );
  }
}

/// Lleva a pagina de sincronizacion para descargar los datos del server
class SincronizarConGomac extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        selectedTileColor: Theme.of(context).accentColor,
        title: const Text(
          'Sincronizar con GOMAC',
        ),
        leading: const Icon(
          Icons.sync,
          color: Colors.black,
          /* color: Colors.white, */
        ),
        onTap: () async {
          await ExtendedNavigator.of(context).pushSincronizacionPage();
          ExtendedNavigator.of(context).pop();
        },
      ),
    );
  }
}

/// Limpia todos los datos de la bd.
class LimpiezaBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cancelButton = FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text("Cancelar",
          style: TextStyle(
              color: Theme.of(context).accentColor)), // OJO con el context
    );
    final Widget continueButton = FlatButton(
      onPressed: () {
        Navigator.of(context).pop();
        getIt<Database>().limpiezaBD();
        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('La limpieza de datos ha finalizado'),
        ));
      },
      child: Text("Limpiar",
          style: TextStyle(color: Theme.of(context).accentColor)),
    );
    // set up the AlertDialog
    final alert = AlertDialog(
      title: Text(
        "Alerta",
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      content: RichText(
        text: TextSpan(
          text:
              'Si limpia la base de datos, perderá todos los borradores que tenga.\n\n',
          style: TextStyle(color: Theme.of(context).hintColor, fontSize: 15),
          children: <TextSpan>[
            TextSpan(
              text: 'IMPORTANTE: ',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text:
                  'debe sincronizar nuevamente con GOMAC después de la limpieza',
              style:
                  TextStyle(color: Theme.of(context).hintColor, fontSize: 15),
            ),
          ],
        ),
      ),

      /* Text(
          "Si limpia la base de datos, perderá todos los borradores que tenga.\n\nIMPORTANTE: debe sincronizar nuevamente con GOMAC después de la limpieza",
          style: TextStyle(color: Theme.of(context).hintColor)), */
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    return Card(
      child: ListTile(
        title: const Text(
          'Limpiar datos de la app',
        ),
        leading: const Icon(
          Icons.cleaning_services,
          color: Colors.black,
        ),
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        ),
      ),
    );
  }
}
