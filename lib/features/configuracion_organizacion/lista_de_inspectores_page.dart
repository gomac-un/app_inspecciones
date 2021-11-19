import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';

import 'domain/entities.dart';
import 'inspector_profile_page.dart';
import 'widgets/simple_future_provider_refreshable_builder.dart';

final _listaDeUsuariosProvider = FutureProvider.autoDispose(
    (ref) => ref.watch(organizacionRepositoryProvider).getListaDeUsuarios());

class ListaDeInspectoresPage extends ConsumerWidget {
  const ListaDeInspectoresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SimpleFutureProviderRefreshableBuilder(
      provider: _listaDeUsuariosProvider,
      builder: (context, Either<ApiFailure, List<UsuarioEnLista>> r) => r.fold(
        (f) => Text("$f"),
        (l) => ListView.separated(
          itemCount: l.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final usuario = l[index];
            return ListTile(
              leading:
                  CircleAvatar(backgroundImage: NetworkImage(usuario.fotoUrl)),
              title: Hero(tag: usuario.id, child: Text(usuario.nombre)),
              subtitle: Text(usuario.rol),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InspectorProfilePage(
                        id: usuario.id,
                      ))),
            );
          },
        ),
      ),
    );
  }
}
