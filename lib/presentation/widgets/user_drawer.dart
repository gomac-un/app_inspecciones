import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/presentation/pages/inspecciones_db_viewer_screen.dart';
import 'package:inspecciones/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDrawer extends ConsumerWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userProvider);
    if (user == null) return const Text("usuario no identificado");
    // El texto "usuario no identificado" nunca se debería mostrar ya que las
    // pantallas con drawer solo se deben ver cuando el usuario ya esté
    // autenticado, sin embargo no se puede lanzar una exepción porque ha pasado
    // que el drawer intenta reconstruirse mientras el usuario no esta autenticado
    // haciendo que el metodo falle y se quede permanentemente con el mensaje de error
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            const AvatarCard(),
            Expanded(
              child: ListView(
                children: [
                  MenuItem(
                    texto: 'Organizacion',
                    icon: Icons.corporate_fare_outlined,
                    onTap: () => context.goNamed("organizacion"),
                  ),
                  if (user.esAdmin)
                    MenuItem(
                      texto:
                          'Cuestionarios', //TODO: mostrar el numero de  cuestionarios creados pendientes por subir
                      icon: Icons.app_registration_outlined,
                      onTap: kIsWeb
                          ? null
                          : () => context.goNamed("cuestionarios"),
                    ),
                  MenuItem(
                    texto: 'Borradores',
                    icon: Icons.list_alt_outlined,
                    onTap: kIsWeb ? null : () => context.goNamed("borradores"),
                  ),
                  MenuItem(
                    texto: 'Sincronizar con GOMAC',
                    icon: Icons.sync_outlined,
                    onTap:
                        kIsWeb ? null : () => context.goNamed("sincronizacion"),
                  ),
                  if (user.esAdmin)
                    MenuItem(
                      texto: 'Herramientas de desarrollador',
                      icon: Icons.bug_report_outlined,
                      onTap: () => _mostrarHerramientasDeDesarrollo(context),
                    ),
                  MenuItem(
                    texto: 'Limpiar datos de la app',
                    icon: Icons.cleaning_services_outlined,
                    onTap: kIsWeb
                        ? null
                        : () => _mostrarConfirmacionLimpieza(
                              context: context,
                            ),
                  ),
                  MenuItem(
                    texto: 'Cambiar el tema',
                    icon: Icons.dark_mode_outlined,
                    onTap: ref.watch(themeProvider.notifier).switchTheme,
                  ),
                  MenuItem(
                    texto: 'Cerrar Sesión',
                    icon: Icons.exit_to_app_outlined,
                    onTap: ref.watch(authProvider.notifier).logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String texto;
  final IconData icon;
  final VoidCallback? onTap;
  const MenuItem(
      {Key? key, required this.texto, required this.icon, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(texto),
        leading: Icon(icon),
        onTap: onTap,
      ),
    );
  }
}

class AvatarCard extends ConsumerWidget {
  const AvatarCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userProvider);
    if (user == null) return const Text("usuario no identificado");
    return UserAccountsDrawerHeader(
      accountName: Text(
        user.esAdmin
            ? "Administrador"
            : "Inspector" " - " +
                user.map(online: (_) => "online", offline: (_) => "offline"),
      ),
      accountEmail: Text(
        /// Nombre de usuario
        user.documento,
      ),
      currentAccountPicture: CircleAvatar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        child: Center(
          child: Text(
            user.documento[0],
            style: const TextStyle(fontSize: 30),
          ),
        ),
      ),
      otherAccountsPictures: [
        GestureDetector(
          child: Image.asset("assets/images/logo-gomac.png"),
          onTap: () async {
            const _url = 'https://gomac.medellin.unal.edu.co';
            await canLaunch(_url) ? await launch(_url) : null;
          },
        ),
      ],
    );
  }
}

Future<void> _mostrarConfirmacionLimpieza({required BuildContext context}) =>
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Alerta"),
              content: RichText(
                text: TextSpan(
                  text:
                      'Si limpia la base de datos, perderá todos los borradores que tenga.\n\n',
                  style: TextStyle(
                      color: Theme.of(context).hintColor, fontSize: 15),
                  children: [
                    TextSpan(
                      text: 'IMPORTANTE: ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'debe sincronizar nuevamente con GOMAC después de la limpieza',
                      style: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 15),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text("Cancelar"), // OJO con el context
                ),
                Consumer(builder: (context, ref, _) {
                  return ElevatedButton(
                    onPressed: () async {
                      //TODO: realizar esta accion en una clase que no sea de capa ui
                      await ref
                          .read(appRepositoryProvider)
                          .limpiarDatosLocales();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('La limpieza de datos ha finalizado'),
                      ));
                      Navigator.of(context).pop();
                    },
                    child: const Text("Limpiar"),
                  );
                }),
              ],
            ));
Future<void> _mostrarHerramientasDeDesarrollo(BuildContext context) =>
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Consumer(builder: (context, ref, _) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                ElevatedButton(
                    child: const Text("Ver base de datos"),
                    onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const InspeccionesDbViewerPage()),
                        )),
                ElevatedButton(
                    child: const Text("Insertar datos de prueba"),
                    onPressed: () => ref
                        .read(cuestionariosRepositoryProvider)
                        .insertarDatosDePrueba())
              ],
            ),
          );
        }),
      ),
    );
