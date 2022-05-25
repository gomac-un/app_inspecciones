import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/repositories/organizacion_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/presentation/widgets/reactive_textfield_tags.dart';
import 'package:inspecciones/utils/future_either_x.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:uuid/uuid.dart';

import 'administrador_de_etiquetas.dart';
import 'domain/entities.dart';
import 'widgets/simple_future_provider_refreshable_builder.dart';

const _uuid = Uuid();

class ActivoController {
  final ActivoEnLista _activo;

  late final idControl =
      fb.control<String>(_activo.identificador, [Validators.required]);

  late final tagsControl = fb.control<Set<Etiqueta>>(_activo.etiquetas.toSet());

  late final control = fb.group({
    'id': idControl,
    'tags': tagsControl,
  });

  ActivoController(this._activo);

  ActivoEnLista guardar() =>
      ActivoEnLista(_uuid.v4(), idControl.value!, tagsControl.value!.toList());

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
    final nuevoActivo = ActivoEnLista("", "", []);
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

  Future<Either<ApiFailure, Unit>> finEdicionActivo(
      ActivoController controller) {
    final activoActualizado = controller.guardar();
    return _organizacionRepository.guardarActivo(activoActualizado).map((_) {
      state = state
          .map((a) => a.controller == controller
              ? ActivoEnListaConController(activoActualizado, null)
              : a)
          .toSet();
      return const Right(unit);
    });
  }

  Future<Either<ApiFailure, Unit>> borrarActivo(ActivoEnLista activo) {
    return _organizacionRepository.borrarActivo(activo).map((_) {
      state.removeWhere((e) => e.activo == activo);
      state = {...state};
      return const Right(unit);
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
    final user = ref.watch(userProvider);
    if (user == null) return const Text("usuario no identificado");
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
            if (index == activos.length) {
              return const SizedBox(height: 60);
            } else if (activos.elementAt(index).activo.id == "previsualizar") {
              return const SizedBox.shrink();
            }
            final activo = activos.elementAt(index).activo;
            final controller = activos.elementAt(index).controller;
            return controller == null
                ? _buildActivo(context, viewModel, activo, user.esAdmin)
                : _buildActivoEditable(context, viewModel, controller);
          },
        );
      },
    );
  }

  ListTile _buildActivo(
    BuildContext context,
    ListaDeActivosViewModel viewModel,
    ActivoEnLista activo,
    bool editable,
  ) =>
      ListTile(
        key: ObjectKey(activo),
        title: Text(activo.identificador),
        trailing: editable
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => viewModel.inicioEdicionActivo(activo),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          await viewModel.borrarActivo(activo).then(
                                (r) => r.fold((l) => l.toString(),
                                    (r) => "activo borrado"),
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        subtitle: Text(
            activo.etiquetas.map((e) => "${e.clave}:${e.valor}").join(", ")),
      );

  ListTile _buildActivoEditable(
    BuildContext context,
    ListaDeActivosViewModel viewModel,
    ActivoController controller,
  ) =>
      ListTile(
        key: ObjectKey(controller),
        title: ReactiveTextField(
          autofocus: true,
          formControl: controller.idControl,
          decoration: const InputDecoration(
            labelText: "identificador",
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.save_outlined),
          onPressed: () async => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                await viewModel.finEdicionActivo(controller).then(
                      (r) =>
                          r.fold((l) => l.toString(), (r) => "activo guardado"),
                    ),
              ),
            ),
          ),
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
