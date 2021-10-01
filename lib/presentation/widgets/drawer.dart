import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/router.gr.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OpcionesAdmin extends StatelessWidget {
  /// La app muestra diferentes funcionalidades dependiendo de si [esAdmin]
  final String nombre;
  const OpcionesAdmin({Key? key, required this.nombre}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        children: <Widget>[
          AvatarCard(nombre: nombre, esAdmin: true),

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
                selectedTileColor: Theme.of(context).colorScheme.secondary,
                title: const Text(
                  'Cuestionarios', //TODO: mostrar el numero de  cuestionarios creados pendientes por subir
                ),
                leading: const Icon(
                  Icons.app_registration,
                  color: Colors.black,
                  /* size: iconSize, */ /* color: Colors.white, */
                ),
                onTap: () =>
                    context.router.popAndPush(const CuestionariosRoute())),
          ),
          const Borradores(),
          const LimpiezaBase(),
          const SincronizarConGomac(),
          Card(
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
          ),
          const LogOut(),
          const Gomac(),
        ],
      );
}

class OpcionesInspector extends StatelessWidget {
  final String nombre;
  const OpcionesInspector({Key? key, required this.nombre}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          AvatarCard(nombre: nombre, esAdmin: false),
          const Borradores(),
          const LimpiezaBase(),
          const SincronizarConGomac(),
          const LogOut(),
          const Gomac(),
        ],
      );
}

class UserDrawer extends StatelessWidget {
  const UserDrawer({Key? key}) : super(key: key);
  //TODO: si se genera este mismo drawer en varias paginas se puede crear un stack indeseado, una solucion seria que la instancia del drawer fuera unica en toda la app
  @override
  Widget build(BuildContext context) => SafeArea(
        child: Drawer(
          child: Expanded(
            flex: 2,
            child: BlocBuilder<AuthBloc, AuthState>(
              /// El usuario puede acceder desde el login aun cuando no tenga internet.
              /// En ese caso, [esAdmin] es false.
              /// Si tiene internet, [esAdmin] se obtiene desde la Api
              builder: (context, state) => state.maybeMap(
                  authenticated: (state) => state.usuario.esAdmin
                      ? OpcionesAdmin(nombre: state.usuario.documento)
                      : OpcionesInspector(nombre: state.usuario.documento),
                  unauthenticated: (state) => const OpcionesInspector(
                      nombre:
                          "anonimo"), //TODO: este estado no deberia existir al menos en el drawer
                  orElse: () => Container()),
            ),
          ),
        ),
      );
}

class AvatarCard extends StatelessWidget {
  final String nombre;
  final bool esAdmin;
  const AvatarCard({Key? key, required this.nombre, required this.esAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      /*   height: height, */
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: UserAccountsDrawerHeader(
          accountName: Text(
            esAdmin ? "Administrador" : "Inspector",
          ),
          accountEmail: Text(
            /// Nombre de usuario
            nombre,
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColorLight,
            child: Center(
              child: Text(
                nombre[0],
                style: TextStyle(
                    fontSize: 30, color: Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Lleva a lista de inspecciones pendientes
class Borradores extends StatelessWidget {
  const Borradores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        selectedTileColor: Theme.of(context).colorScheme.secondary,
        title: const Text(
          'Inspecciones', //TODO: mostrar el numero de  inspecciones creadas pendientes por subir
        ),
        leading: const Icon(
          Icons.list_alt,
          color: Colors.black,
        ),
        onTap: () => context.router.navigate(const BorradoresRoute()),
      ),
    );
  }
}

/// Abre el sitio web de Gomac
class Gomac extends StatelessWidget {
  const Gomac({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const _url = 'https://gomac.medellin.unal.edu.co';
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: double.infinity,
        child: ListTile(
          title: const Text(
            'Ir a Gomac',
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/logo-gomac.png"),
          ),
          onTap: () async => await canLaunch(_url)
              ? await launch(_url)
              : {
                  context.router.pop(),
                  ScaffoldMessenger.of(context).showSnackBar(
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
  const LogOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return Card(
      child: ListTile(
          selectedTileColor: Theme.of(context).colorScheme.secondary,
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
  const Planeacion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          selectedTileColor: Theme.of(context).colorScheme.secondary,
          title: const Text('Grupos', style: TextStyle(fontSize: 13)),
          onTap: null, //() => context.router.popAndPush(const GruposScreen()),
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
  const SincronizarConGomac({Key? key}) : super(key: key);

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
        onTap: () => context.router.popAndPush(const SincronizacionRoute()),
      ),
    );
  }
}

/// Limpia todos los datos de la bd.
class LimpiezaBase extends StatelessWidget {
  const LimpiezaBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cancelButton = TextButton(
      onPressed: () => context.router.pop(),
      child: Text("Cancelar",
          style: TextStyle(
              color: Theme.of(context).accentColor)), // OJO con el context
    );
    final Widget continueButton = TextButton(
      onPressed: () {
        context.router.pop();
        getIt<Database>().limpiezaBD();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
