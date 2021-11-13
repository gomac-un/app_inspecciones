import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';

import 'configuracion_organizacion_page.dart';
import 'domain/entities.dart';
import 'widgets/profile_widget.dart';
import 'widgets/simple_future_provider_refreshable_builder.dart';

final miOrganizacionProvider = FutureProvider.autoDispose((ref) =>
    ref.watch(organizacionRemoteRepositoryProvider).getMiOrganizacion());

class OrganizacionProfilePage extends ConsumerWidget {
  const OrganizacionProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SimpleFutureProviderRefreshableBuilder(
      provider: miOrganizacionProvider,
      builder: (context, Either<ApiFailure, Organizacion> r) => r.fold(
        (f) => Text("$f"),
        (organizacion) => ListView(
          children: [
            const SizedBox(height: 24),
            ProfileWidget(
              imagePath: organizacion.logo,
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ConfiguracionOrganizacionPage(
                        organizacion: organizacion,
                      ))),
            ),
            const SizedBox(height: 24),
            buildName(organizacion.nombre, organizacion.link),
            const SizedBox(height: 24),
            Center(child: buildUpgradeButton()),
            const SizedBox(height: 24),
            const _EstadisticasWidget(),
            const SizedBox(height: 48),
            buildAbout(organizacion.acerca),
          ],
        ),
      ),
    );
  }

  Widget buildName(String nombre, String link) => Column(
        children: [
          Text(
            nombre,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            link, //email
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ElevatedButton(
        child: const Text('Mejorar plan'),
        onPressed: () {},
      );

  Widget buildAbout(String acerca) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acerca de',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              acerca,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}

class _EstadisticasWidget extends StatelessWidget {
  const _EstadisticasWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildButton(context, '0', 'Ranking'), //TODO: implementar
          buildDivider(),
          buildButton(context, '0', 'Inspecciones'),
          buildDivider(),
          buildButton(context, '0', 'Reparaciones'),
        ],
      );
  Widget buildDivider() => const SizedBox(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}
