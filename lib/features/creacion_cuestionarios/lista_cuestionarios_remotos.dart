import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/configuracion_organizacion/widgets/simple_future_provider_refreshable_builder.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';

final cuestionariosServidorProvider = FutureProvider.autoDispose((ref) =>
    ref.watch(cuestionariosRepositoryProvider).getListaDeCuestionariosServer());

/// Pantalla que muestra la lista de cuestionarios subidos y en proceso.
/// TODO: boton para descargarlos todos
class ListaCuestionariosRemotos extends ConsumerWidget {
  const ListaCuestionariosRemotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SimpleFutureProviderRefreshableBuilder(
      provider: cuestionariosServidorProvider,
      builder: (context, Either<ApiFailure, List<Cuestionario>> r) => r.fold(
        (f) => Text("$f"),
        (l) => ListView.separated(
          itemCount: l.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return _buildCuestionarioTile(context, l[index], ref);
          },
        ),
      ),
    );
  }

  ListTile _buildCuestionarioTile(
      BuildContext context, Cuestionario cuestionario, WidgetRef ref) {
    return ListTile(
      onTap: null,
      title:
          Text("${cuestionario.tipoDeInspeccion} - v${cuestionario.version}"),
      subtitle: Text(EnumToString.convertToString(cuestionario.estado)),
      trailing: IconButton(
          onPressed: () => ref
              .watch(cuestionariosRepositoryProvider)
              .descargarCuestionario(cuestionarioId: cuestionario.id),
          icon: const Icon(Icons.download_for_offline_outlined)),
    );
  }
}
