import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';

import 'edicion_form_page.dart';
import 'lista_cuestionarios_locales.dart';
import 'lista_cuestionarios_remotos.dart';

class ListaCuestionariosPage extends HookConsumerWidget {
  const ListaCuestionariosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userProvider);
    if (user == null) return const Text("usuario no identificado");
    TabController _tabController =
        useTabController(initialLength: 2, initialIndex: 0);
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        return Scaffold(
            drawer: const UserDrawer(),
            appBar: AppBar(
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                      text: "descargados",
                      icon: Icon(Icons.download_for_offline_outlined)),
                  Tab(
                      text: "disponibles",
                      icon: Icon(Icons.cloud_circle_outlined)),
                ],
              ),
              title: const Text('Cuestionarios'),
            ),
            body: child,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: !user.esAdmin
                ? null
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FloatingActionButtonCreacionCuestionario(),
                  ));
      },
      child: TabBarView(
        controller: _tabController,
        children: const [
          ListaCuestionariosLocales(),
          ListaCuestionariosRemotos(),
        ],
      ),
    );
  }
}

/// Botón de creación de cuestionarios
class FloatingActionButtonCreacionCuestionario extends StatelessWidget {
  const FloatingActionButtonCreacionCuestionario({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final res = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => const EdicionFormPage(),
          ),
        );
        if (res ?? false) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(const SnackBar(
                content: Text("Cuestionario finalizado, recuerda subirlo")));
        }
      },
      icon: const Icon(Icons.add),
      label: const Text("Cuestionario"),
    );
  }
}
