import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/repositories/organizacion_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/presentation/widgets/reactive_textfield_tags.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'administrador_de_etiquetas.dart';
import 'domain/entities.dart';
import 'widgets/simple_future_provider_refreshable_builder.dart';

class ActivoController {
  final ActivoEnLista _activo;

  late final idControl = fb.control<String>(_activo.id, [Validators.required]);

  late final tagsControl = fb.control<Set<Etiqueta>>(_activo.etiquetas.toSet());

  late final control = fb.group({
    'id': idControl,
    'tags': tagsControl,
  });

  ActivoController(this._activo);

  ActivoEnLista guardar() =>
      ActivoEnLista(idControl.value!, tagsControl.value!.toList());

  List<Etiqueta> getEtiquetasDisponibles(List<Jerarquia> todas) {
    final usadas = tagsControl.value!;

    final result = <Etiqueta>[];

    for (final jerarquia in todas) {
      final ruta = <String>[];
      for (final nivel in jerarquia.niveles) {
        final etiquetaParaNivel =
            usadas.firstWhereOrNull((e) => e.clave == nivel);
        if (etiquetaParaNivel != null) {
          ruta.add(etiquetaParaNivel.valor);
          continue;
        } else {
          result.addAll(jerarquia.getEtiquetasDeNivel(nivel, ruta));
          break;
        }
      }
    }
    return result;
  }

  void dispose() {
    control.dispose();
  }
}

class ActivoEnListaConController {
  final ActivoController? controller;
  final ActivoEnLista activo;
  ActivoEnListaConController(this.activo, this.controller);
}

class ListaDeActivosViewModel
    extends StateNotifier<Set<ActivoEnListaConController>> {
  final Reader _read;
  OrganizacionRepository get _organizacionRepository =>
      _read(organizacionRepositoryProvider);

  ListaDeActivosViewModel(this._read, Set<ActivoEnLista> activos)
      : super(activos.map((a) => ActivoEnListaConController(a, null)).toSet());

  void agregarActivo() {
    final nuevoActivo = ActivoEnLista("", []);
    state = {
      ActivoEnListaConController(nuevoActivo, ActivoController(nuevoActivo)),
      ...state,
    };
  }

  void inicioEdicionActivo(ActivoEnLista activo) {
    state = state
        .map((a) => a.activo == activo
            ? ActivoEnListaConController(a.activo, ActivoController(a.activo))
            : a)
        .toSet();
  }

  void finEdicionActivo(ActivoController controller) {
    final activoActualizado = controller.guardar();
    _organizacionRepository.guardarActivo(activoActualizado);

    state = state
        .map((a) => a.controller == controller
            ? ActivoEnListaConController(activoActualizado, null)
            : a)
        .toSet();
  }

  void borrarActivo(ActivoEnLista activo) async {
    final res = await _organizacionRepository.borrarActivo(activo);
    res.fold((l) => throw l, (r) {
      state.removeWhere((e) => e.activo == activo);
      state = {...state};
    });
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
/// es que cambie. Nótese que esto es un machetazo.
final agregarActivoProvider = StateProvider((ref) => 0);

final _listaActivosProvider =
    FutureProvider.autoDispose<Tuple2<ApiFailure?, Set<ActivoEnLista>>>(
  (ref) => ref.watch(organizacionRepositoryProvider).refreshListaDeActivos(),
);

final _viewModelProvider = StateNotifierProvider.autoDispose.family<
    ListaDeActivosViewModel,
    Set<ActivoEnListaConController>,
    Set<ActivoEnLista>>((ref, lista) {
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
    ref.listen<AsyncValue<Tuple2<ApiFailure?, Set<ActivoEnLista>>>>(
        _listaActivosProvider, (_, next) {
      next.whenData((value) {
        final ApiFailure? maybeFailure = value.value1;
        if (maybeFailure != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(maybeFailure.toString()),
          ));
        }
      });
    });
    return SimpleFutureProviderRefreshableBuilder(
      provider: _listaActivosProvider,
      builder: (context, Tuple2<ApiFailure?, Set<ActivoEnLista>> res) {
        final activosFromRepo = res.value2;
        final viewModel =
            ref.watch(_viewModelProvider(activosFromRepo).notifier);
        final activos = ref.watch(_viewModelProvider(activosFromRepo));
        return ListView.separated(
          // para que el fab no estorbe en el ultimo
          padding: const EdgeInsets.only(bottom: 60),
          itemCount: activos.length + 1, // +1 para el espacio al final
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            if (index == activos.length) return const SizedBox(height: 60);

            final activo = activos.elementAt(index).activo;
            final controller = activos.elementAt(index).controller;
            return controller == null
                ? _buildActivo(activo,
                    onEdicion: viewModel.inicioEdicionActivo,
                    onBorrar: viewModel.borrarActivo)
                : _buildActivoEditable(
                    context, viewModel.finEdicionActivo, controller);
          },
        );
      },
    );
  }

  ListTile _buildActivo(
    ActivoEnLista activo, {
    void Function(ActivoEnLista activo)? onEdicion,
    void Function(ActivoEnLista activo)? onBorrar,
  }) =>
      ListTile(
        title: Text(activo.id),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => onEdicion?.call(activo),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => onBorrar?.call(activo),
            ),
          ],
        ),
        subtitle: Text(
            activo.etiquetas.map((e) => "${e.clave}:${e.valor}").join(", ")),
      );

  ListTile _buildActivoEditable(
    BuildContext context,
    void Function(ActivoController controller) onFinalizarEdicion,
    ActivoController controller,
  ) =>
      ListTile(
        title: ReactiveTextField(
          autofocus: true,
          formControl: controller.idControl,
          decoration: const InputDecoration(
            labelText: "identificador",
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.save_outlined),
          onPressed: () => onFinalizarEdicion(controller),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Consumer(builder: (context, ref, _) {
            final todasLasJerarquias =
                ref.watch(listaEtiquetasDeActivosProvider).asData?.value ??
                    const <Jerarquia>[];

            return ReactiveTextFieldTags(
              decoration: const InputDecoration(labelText: "etiquetas"),
              formControl: controller.tagsControl,
              optionsBuilder: (TextEditingValue val) async {
                /*WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Future.delayed(
                      const Duration(seconds: 3), () => yourFunction());
                });*/
                return controller
                    .getEtiquetasDisponibles(todasLasJerarquias)
                    .where((e) =>
                        e.clave.toLowerCase().contains(val.text.toLowerCase()));
              },
              onMenu: () {
                showDialog(
                  context: context,
                  builder: (_) => const MenuDeEtiquetas(TipoDeEtiqueta.activo),
                );
              },
            );
          }),
        ),
      );
}
