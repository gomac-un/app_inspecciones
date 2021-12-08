import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/features/configuracion_organizacion/lista_de_inspectores_page.dart';
import 'package:inspecciones/features/configuracion_organizacion/organizacion_profile_page.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';

import 'lista_de_activos_page.dart';
import 'lista_de_etiquetas_page.dart';

class OrganizacionPage extends HookConsumerWidget {
  const OrganizacionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    TabController _tabController =
        useTabController(initialLength: 4, initialIndex: 0);
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, child) {
        return Scaffold(
          drawer: const UserDrawer(),
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.corporate_fare_outlined)),
                Tab(icon: Icon(Icons.people_outline_outlined)),
                Tab(icon: Icon(Icons.view_in_ar_outlined)),
                Tab(icon: Icon(Icons.label_outline)),
              ],
            ),
            title: const Text('Organización'),
          ),
          body: child,
          floatingActionButton: _buildFab(context, _tabController, ref),
        );
      },
      child: TabBarView(
        controller: _tabController,
        children: const [
          OrganizacionProfilePage(),
          ListaDeInspectoresPage(),
          ListaDeActivosPage(),
          ListaDeEtiquetasPage(),
        ],
      ),
    );
  }

  FloatingActionButton? _buildFab(
      BuildContext context, TabController tabController, WidgetRef ref) {
    if (tabController.index == 1) {
      return FloatingActionButton.extended(
        onPressed: () =>
            ref.read(organizacionRepositoryProvider).getMiOrganizacion().then(
                  (r) => r.map((o) => context.goNamed("registro",
                      queryParams: {"org": o.id.toString()})),
                ),
        label: const Text("Registrar"),
        icon: const Icon(Icons.how_to_reg_outlined),
      );
    } else if (tabController.index == 2) {
      return FloatingActionButton.extended(
        onPressed: () => ref.read(agregarActivoProvider.notifier).state++,
        label: const Text("Activo"),
        icon: const Icon(Icons.add_outlined),
      );
    } else {
      return null;
    }
  }
}
