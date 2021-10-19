import 'package:flutter/material.dart';
import 'package:inspecciones/features/configuracion_organizacion/lista_de_inspectores_page.dart';
import 'package:inspecciones/features/configuracion_organizacion/organizacion_profile_page.dart';
import 'package:inspecciones/presentation/widgets/user_drawer.dart';

import 'lista_de_activos_page.dart';

class OrganizacionPage extends StatelessWidget {
  const OrganizacionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: const UserDrawer(),
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.corporate_fare_outlined)),
              Tab(icon: Icon(Icons.people_outline_outlined)),
              Tab(icon: Icon(Icons.commute_sharp)),
            ],
          ),
          title: const Text('Organizacion'),
        ),
        body: const TabBarView(
          children: [
            OrganizacionProfilePage(),
            ListaDeInspectoresPage(),
            ListaDeActivosPage(),
          ],
        ),
      ),
    );
  }
}
