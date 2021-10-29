import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';

import 'widgets/profile_widget.dart';

final perfilProvider = FutureProvider.autoDispose
    .family<Either<ApiFailure, Perfil>, int>(
        (ref, id) => ref.watch(userRepositoryProvider).getPerfil(id));

class InspectorProfilePage extends ConsumerWidget {
  final int id;
  const InspectorProfilePage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final perfil = ref.watch(perfilProvider(id));
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: perfil.when(
        data: (r) => r.fold(
            (f) => Text(f.mensaje),
            (perfil) => ListView(
                  children: [
                    ProfileWidget(
                      imagePath: perfil.foto,
                      onClicked: () {},
                    ),
                    const SizedBox(height: 24),
                    buildName(perfil.nombre, perfil.email),
                    const SizedBox(height: 24),
                    const NumbersWidget(),
                    const SizedBox(height: 24),
                    buildAbout(perfil),
                  ],
                )),
        loading: (b) => const Center(child: CircularProgressIndicator()),
        error: (e, s, b) => Center(child: Text(e.toString())),
      ),
    );
  }

  Widget buildName(String nombre, String email) => Column(
        children: [
          Text(
            nombre,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(Perfil perfil) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Info',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DataTable(
              headingRowHeight: 0,
              columns: [
                DataColumn(label: Container()),
                DataColumn(label: Container()),
              ],
              rows: [
                _buildRow('Organizacion', perfil.organizacion),
                _buildRow('Rol', perfil.rol),
                _buildRow('Activo', perfil.estaActivo ? "si" : "no"),
                _buildRow(
                    'Fecha de registro', perfil.fechaRegistro.formatoAmigable),
                _buildRow('Celular', perfil.celular),
                _buildRow('Username', perfil.username),
              ],
            ),
          ],
        ),
      );
}

DataRow _buildRow(String key, String value) => DataRow(
      cells: [
        DataCell(Text(
          key,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(value)),
      ],
    );

class NumbersWidget extends StatelessWidget {
  const NumbersWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildButton(context, '0', 'Ranking'), // TODO: Implementar
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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

extension FormatoAmigable on DateTime {
  String get formatoAmigable => '$day/$month/$year';
}
