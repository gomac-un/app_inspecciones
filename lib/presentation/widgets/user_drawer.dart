import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/infrastructure/repositories/app_repository.dart';
import 'package:inspecciones/presentation/pages/borradores_screen.dart';
import 'package:inspecciones/presentation/pages/cuestionarios_screen.dart';
import 'package:inspecciones/presentation/pages/inspecciones_db_viewer_screen.dart';
import 'package:inspecciones/presentation/pages/sincronizacion_page.dart';
import 'package:inspecciones/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDrawer extends ConsumerWidget {
  const UserDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userProvider);
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            const AvatarCard(),
            Expanded(
              child: ListView(
                children: [
                  if (user.esAdmin)
                    MenuItem(
                      texto:
                          'Cuestionarios', //TODO: mostrar el numero de  cuestionarios creados pendientes por subir
                      icon: Icons.app_registration_outlined,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const CuestionariosPage())),
                    ),
                  MenuItem(
                    texto: 'Borradores',
                    icon: Icons.list_alt_outlined,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const BorradoresPage())),
                  ),
                  MenuItem(
                    texto: 'Sincronizar con GOMAC',
                    icon: Icons.sync_outlined,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const SincronizacionPage())),
                  ),
                  if (user.esAdmin)
                    MenuItem(
                      texto: 'Ver base de datos',
                      icon: Icons.storage_outlined,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const InspeccionesDbViewerPage())),
                    ),
                  MenuItem(
                    texto: 'Limpiar datos de la app',
                    icon: Icons.cleaning_services_outlined,
                    onTap: () => _mostrarConfirmacionLimpieza(
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
  final VoidCallback onTap;
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
    return UserAccountsDrawerHeader(
      accountName: Text(
        user.esAdmin ? "Administrador" : "Inspector",
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
