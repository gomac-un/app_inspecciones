import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:textfield_tags/textfield_tags.dart';

import 'domain/entities.dart';
import 'widgets/simple_future_provider_refreshable_builder.dart';

class ActivoController {
  final ActivoEnLista _activo;

  late final idControl = fb.control<String>(_activo.id, [Validators.required]);

  late final tagsControl = fb.control<Set<String>>(
      _activo.etiquetas.map((e) => '${e.clave}:${e.valor}').toSet());

  ActivoController(this._activo);

  ActivoEnLista guardar() => ActivoEnLista(
      idControl.value!,
      tagsControl.value!
          .map((e) => Etiqueta(e.split(":").first, e.split(":").last))
          .toList());

  void dispose() {
    tagsControl.dispose();
  }
}

class ActivoEnListaConController {
  final ActivoController? controller;
  final ActivoEnLista activo;
  ActivoEnListaConController(this.activo, this.controller);
}

class ListaDeActivosViewModel
    extends StateNotifier<List<ActivoEnListaConController>> {
  final Reader _read;

  ListaDeActivosViewModel(this._read, List<ActivoEnLista> activos)
      : super(activos.map((a) => ActivoEnListaConController(a, null)).toList());

  void agregarActivo() {
    final nuevoActivo = ActivoEnLista("", []);
    state = [
      ...state,
      ActivoEnListaConController(nuevoActivo, ActivoController(nuevoActivo))
    ];
  }

  void inicioEdicionActivo(ActivoEnLista activo) {
    state = state
        .map((a) => a.activo == activo
            ? ActivoEnListaConController(a.activo, ActivoController(a.activo))
            : a)
        .toList();
  }

  void finEdicionActivo(ActivoController controller) {
    final activoActualizado = controller.guardar();
    _read(organizacionRemoteRepositoryProvider)
        .guardarActivo(activoActualizado);

    state = state
        .map((a) => a.controller == controller
            ? ActivoEnListaConController(activoActualizado, null)
            : a)
        .toList();
  }

  @override
  void dispose() {
    for (var a in state) {
      a.controller?.dispose();
    }
    super.dispose();
  }
}

/// El provider del viewModel de los activos escucha a este provider para
/// saber cuando se debe agregar uno nuevo. El numero no importa, lo importante
/// es que cambie
final agregarActivoProvider = StateProvider((ref) => 0);

final _listaActivosProvider =
    FutureProvider.autoDispose<Either<ApiFailure, List<ActivoEnLista>>>(
  (ref) => ref.watch(organizacionRemoteRepositoryProvider).getListaDeActivos(),
);

final _viewModelProvider = StateNotifierProvider.autoDispose.family<
    ListaDeActivosViewModel,
    List<ActivoEnListaConController>,
    List<ActivoEnLista>>((ref, lista) {
  final viewModel = ListaDeActivosViewModel(ref.read, lista);
  ref.listen(agregarActivoProvider, (_, __) {
    viewModel.agregarActivo();
  });
  return viewModel;
});

class ListaDeActivosPage extends ConsumerWidget {
  const ListaDeActivosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SimpleFutureProviderRefreshableBuilder(
      provider: _listaActivosProvider,
      builder: (context, List<ActivoEnLista> activosFromRepo) {
        final viewModel =
            ref.watch(_viewModelProvider(activosFromRepo).notifier);
        final activos = ref.watch(_viewModelProvider(activosFromRepo));
        return ListView.separated(
          padding: const EdgeInsets.only(
              bottom: 60), // para que el fab no estorbe en el ultimo
          itemCount: activos.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final activo = activos[index].activo;
            final controller = activos[index].controller;
            return controller == null
                ? _buildActivo(viewModel, activo)
                : _buildActivoEditable(viewModel, controller);
          },
        );
      },
    );
  }

  ListTile _buildActivo(
          ListaDeActivosViewModel viewModel, ActivoEnLista activo) =>
      ListTile(
        title: Text(activo.id),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => viewModel.inicioEdicionActivo(activo),
        ),
        subtitle: Text(
            activo.etiquetas.map((e) => "${e.clave}:${e.valor}").join(", ")),
      );

  ListTile _buildActivoEditable(
          ListaDeActivosViewModel viewModel, ActivoController controller) =>
      ListTile(
        title: ReactiveTextField(
          formControl: controller.idControl,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.save_outlined),
          onPressed: () => viewModel.finEdicionActivo(controller),
        ),
        subtitle: ReactiveTextFieldTags(
            formControl: controller.tagsControl,
            validator: (String tag) {
              if (tag.isEmpty) return "ingrese algo";

              final splited = tag.split(":");

              if (splited.length == 1) {
                return "agregue : para separar la etiqueta";
              }

              if (splited.length > 2) return "solo se permite un :";

              if (splited[0].isEmpty || splited[1].isEmpty) {
                return "agregue texto antes y despues de :";
              }

              return null;
            }),
      );
}
