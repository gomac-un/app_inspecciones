import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/utils/dartz_x.dart';
import 'package:inspecciones/utils/state_notifier_hook.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'domain/entities.dart';

final _organizacionDaoProvider =
    Provider((ref) => ref.watch(driftDatabaseProvider).organizacionDao);

final listaEtiquetasDeActivosProvider =
    StreamProvider.autoDispose<List<Jerarquia>>(
  (ref) => ref.watch(_organizacionDaoProvider).watchEtiquetasDeActivos(),
);

final listaEtiquetasDePreguntasProvider =
    StreamProvider.autoDispose<List<Jerarquia>>(
  (ref) => ref.watch(_organizacionDaoProvider).watchEtiquetasDePreguntas(),
);

enum TipoDeEtiqueta {
  activo,
  pregunta,
}

class MenuDeEtiquetas extends ConsumerWidget {
  final TipoDeEtiqueta tipoDeEtiqueta;

  const MenuDeEtiquetas(this.tipoDeEtiqueta, {Key? key}) : super(key: key);

  AsyncValue<List<Jerarquia>> getEtiquetas(WidgetRef ref) =>
      tipoDeEtiqueta == TipoDeEtiqueta.activo
          ? ref.watch(listaEtiquetasDeActivosProvider)
          : ref.watch(listaEtiquetasDePreguntasProvider);

  Future<Either<ApiFailure, Unit>> Function() getSincronizarEtiquetas(
          WidgetRef ref) =>
      tipoDeEtiqueta == TipoDeEtiqueta.activo
          ? ref
              .read(organizacionRepositoryProvider)
              .sincronizarEtiquetasDeActivos
          : ref
              .read(organizacionRepositoryProvider)
              .sincronizarEtiquetasDePreguntas;

  Future<void> Function(Jerarquia) getEliminarEtiquetaLocal(WidgetRef ref) =>
      tipoDeEtiqueta == TipoDeEtiqueta.activo
          ? ref.read(_organizacionDaoProvider).eliminarEtiquetaDeActivo
          : ref.read(_organizacionDaoProvider).eliminarEtiquetaDePregunta;

  Future<void> Function(String) getEliminarEtiquetaRemota(WidgetRef ref) =>
      tipoDeEtiqueta == TipoDeEtiqueta.activo
          ? ref
              .read(organizacionRemoteDataSourceProvider)
              .eliminarEtiquetaDeActivo
          : ref
              .read(organizacionRemoteDataSourceProvider)
              .eliminarEtiquetaDePregunta;

  Future<void> Function(Jerarquia) getAgregarEtiqueta(WidgetRef ref) =>
      tipoDeEtiqueta == TipoDeEtiqueta.activo
          ? ref.read(_organizacionDaoProvider).agregarEtiquetaDeActivo
          : ref.read(_organizacionDaoProvider).agregarEtiquetaDePregunta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etiquetas = getEtiquetas(ref);

    //final repoLocal = ref.watch(_organizacionDaoProvider);

    return etiquetas.when(
        error: (e, _) => Center(child: Text(e.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (etiquetas) {
          return AlertDialog(
            title: Row(
              children: [
                const Text("etiquetas"),
                IconButton(
                  icon: const Icon(Icons.sync_outlined),
                  onPressed: () =>
                      getSincronizarEtiquetas(ref)().then((res) => res.fold(
                          (l) => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("error"),
                                    content: Text(l.toString()),
                                  )),
                          (r) => null)),
                ),
              ],
            ),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final etiqueta in etiquetas)
                      ListTile(
                        title: Text(
                            "${etiqueta.niveles.first} (${etiqueta.niveles.length})"),
                        onTap: () async {
                          final arbol =
                              await showDialog<List<EtiquetaEnJerarquia>>(
                            context: context,
                            builder: (_) => CreacionDeArbolDeEtiquetasDialog(
                              niveles: etiqueta.niveles,
                              profundidad: 0,
                              arbol: etiqueta.arbol,
                              readOnly: !etiqueta.esLocal,
                            ),
                          );
                          if (arbol == null) return;
                          if (!etiqueta.esLocal) return;
                          getEliminarEtiquetaLocal(ref)(etiqueta);
                          getAgregarEtiqueta(ref)(Jerarquia(
                              niveles: etiqueta.niveles,
                              arbol: arbol,
                              esLocal: true));
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outlined),
                          onPressed: () async {
                            final res = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("eliminar"),
                                      content: const Text(
                                          "¿Está seguro de eliminar esta etiqueta? los activos que la hayan usado quedarán con ella y tendrá que limpiarlos manualmente."),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("no")),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text("si")),
                                      ],
                                    ));
                            if (res == null) return;
                            if (res) {
                              if (!etiqueta.esLocal) {
                                await getEliminarEtiquetaRemota(ref)(
                                    etiqueta.niveles.first);
                              }
                              await getEliminarEtiquetaLocal(ref)(etiqueta);
                            }
                          },
                        ),
                      )
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final res = await showDialog<Tuple2<String, bool>>(
                    context: context,
                    builder: (_) => const CreacionDeEtiquetaDialog(),
                  );
                  if (res != null) {
                    final clave = res.value1;
                    final jerarquia = res.value2;
                    if (jerarquia) {
                      final niveles = await showDialog<List<String>>(
                        context: context,
                        builder: (_) =>
                            CreacionDeNivelesDialog(claveBase: clave),
                      );
                      if (niveles == null) return;
                      final arbol = await showDialog<List<EtiquetaEnJerarquia>>(
                        context: context,
                        builder: (_) => CreacionDeArbolDeEtiquetasDialog(
                          niveles: niveles,
                          profundidad: 0,
                        ),
                      );
                      if (arbol == null) return;
                      getAgregarEtiqueta(ref)(Jerarquia(
                          niveles: niveles, arbol: arbol, esLocal: true));
                    } else {
                      final niveles = [clave];
                      final arbol = await showDialog<List<EtiquetaEnJerarquia>>(
                        context: context,
                        builder: (_) => CreacionDeArbolDeEtiquetasDialog(
                          niveles: niveles,
                          profundidad: 0,
                        ),
                      );
                      if (arbol == null) return;
                      getAgregarEtiqueta(ref)(Jerarquia(
                          niveles: niveles, arbol: arbol, esLocal: true));
                    }
                  }
                },
              ),
            ],
          );
        });
  }
}

class CreacionDeEtiquetaDialog extends ConsumerWidget {
  const CreacionDeEtiquetaDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(creacionDeEtiquetaViewModelProvider);
    return ReactiveForm(
      formGroup: viewModel.form,
      child: AlertDialog(
        title: const Text("agregar etiqueta"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReactiveTextField(
              formControl: viewModel.claveControl,
              decoration: const InputDecoration(
                labelText: "etiqueta",
              ),
            ),
            ReactiveCheckboxListTile(
              formControl: viewModel.jerarquiaControl,
              title: const Text("jerarquía"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("cancelar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ReactiveFormConsumer(
            builder: (context, form, child) {
              return TextButton(
                child: const Text("agregar"),
                onPressed: !form.valid
                    ? null
                    : () {
                        Navigator.of(context).pop(
                          Tuple2(viewModel.claveControl.value!,
                              viewModel.jerarquiaControl.value!),
                        );
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}

final creacionDeEtiquetaViewModelProvider = Provider.autoDispose((ref) {
  final res = CreacionDeEtiquetaViewModel();
  ref.onDispose(res.dispose);
  return res;
});

class CreacionDeEtiquetaViewModel {
  final claveControl = fb.control("", [Validators.required]);
  final jerarquiaControl = fb.control(false);

  late final form = fb.group({
    "clave": claveControl,
    "jerarquia": jerarquiaControl,
  });

  void dispose() => form.dispose();
}

class CreacionDeNivelesDialog extends HookConsumerWidget {
  final String claveBase;
  late final List<String> nivelesIniciales = [claveBase];

  CreacionDeNivelesDialog({Key? key, required this.claveBase})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final stateNotifierState =
        useStateNotifier<IList<String>, NivelesViewModel>(
            () => NivelesViewModel(nivelesIniciales));

    final viewModel = stateNotifierState.notifier;
    final niveles = stateNotifierState.state;

    return AlertDialog(
      title: Text(claveBase),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Por favor agregue todos los niveles que tiene la jerarquía, por favor no use nombres de niveles que ya existan en otra etiqueta",
            style: Theme.of(context).textTheme.caption,
          ),
          Flexible(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final valor in niveles.toIterable())
                      ListTile(
                        title: Text(valor),
                        onTap: null,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outlined),
                          onPressed: () => viewModel.eliminarNivel(valor),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: ReactiveTextField(
                            formControl: viewModel.nuevoNivelControl,
                            decoration: const InputDecoration(
                              labelText: "nuevo nivel",
                            ),
                            showErrors: (_) => false,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => viewModel.agregarNivel(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("continuar"),
          onPressed: () {
            viewModel.agregarNivel();
            // ignore: invalid_use_of_protected_member
            Navigator.of(context).pop(viewModel.state.toIterable().toList());
          },
        ),
      ],
    );
  }
}

class NivelesViewModel extends StateNotifier<IList<String>> {
  late final nuevoNivelControl = fb.control("", [Validators.required]);

  NivelesViewModel(List<String> nivelesIniciales)
      : super(IList.from(nivelesIniciales));

  void agregarNivel() {
    nuevoNivelControl.markAsTouched();
    if (nuevoNivelControl.valid) {
      state = state.appendElement(nuevoNivelControl.value!);
      nuevoNivelControl.reset();
    }
  }

  void eliminarNivel(String nivel) {
    state = state.remove(nivel);
  }
}

class CreacionDeArbolDeEtiquetasDialog extends HookConsumerWidget {
  final List<String> niveles;
  final int profundidad;
  final List<EtiquetaEnJerarquia> arbol;
  final String? valorPadre;
  final bool readOnly;

  String get clave => niveles[profundidad];
  bool get esUltimoNivel => profundidad == niveles.length - 1;

  const CreacionDeArbolDeEtiquetasDialog({
    Key? key,
    required this.niveles,
    required this.profundidad,
    this.arbol = const [],
    this.valorPadre,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final stateNotifierState =
        useStateNotifier<IList<EtiquetaEnJerarquia>, ArbolDeEtiquetasViewModel>(
            () => ArbolDeEtiquetasViewModel(arbol));

    final viewModel = stateNotifierState.notifier;
    final valores = stateNotifierState.state;

    return WillPopScope(
      onWillPop: () async {
        _popConLaInformacion(context, viewModel);
        return true;
      },
      child: AlertDialog(
        title: Text(clave + (valorPadre != null ? " de $valorPadre" : "")),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (readOnly ? "" : "Por favor agregue cada " + clave) +
                  (valorPadre != null
                      ? " para el ${niveles[profundidad - 1]} $valorPadre"
                      : ""),
              style: Theme.of(context).textTheme.caption,
            ),
            Flexible(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final valor in valores.toIterable())
                        ListTile(
                          title:
                              Text("${valor.valor} (${valor.children.length})"),
                          onTap: esUltimoNivel
                              ? null
                              : () async {
                                  final children = await showDialog<
                                      List<EtiquetaEnJerarquia>>(
                                    context: context,
                                    builder: (_) =>
                                        CreacionDeArbolDeEtiquetasDialog(
                                      niveles: niveles,
                                      profundidad: profundidad + 1,
                                      arbol: valor.children,
                                      valorPadre: valor.valor,
                                      readOnly: readOnly,
                                    ),
                                  );
                                  if (children == null) return;

                                  viewModel.agregarHijo(valor, children);
                                },
                          trailing: readOnly
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.delete_outlined),
                                  onPressed: () async {
                                    final confirmacion = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text("Eliminar ${valor.valor}"),
                                        content: Text(
                                            "¿Está seguro que desea eliminar ${valor.valor}? esto eliminará también todas las etiquetas que dependen de esta."),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text("no"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text("si"),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirmacion == true) {
                                      viewModel.eliminarValor(valor);
                                    }
                                  },
                                ),
                        ),
                      if (!readOnly)
                        Row(
                          children: [
                            Expanded(
                              child: ReactiveTextField(
                                formControl: viewModel.nuevoValorControl,
                                decoration: InputDecoration(
                                  labelText: clave,
                                ),
                                showErrors: (_) => false,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => viewModel.agregarValor(),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("atrás"),
            onPressed: () => _popConLaInformacion(context, viewModel),
          ),
        ],
      ),
    );
  }

  void _popConLaInformacion(
      BuildContext context, ArbolDeEtiquetasViewModel viewModel) {
    if (readOnly) return Navigator.of(context).pop();
    viewModel.agregarValor();
    // ignore: invalid_use_of_protected_member
    Navigator.of(context).pop(viewModel.state.toIterable().toList());
  }
}

class ArbolDeEtiquetasViewModel
    extends StateNotifier<IList<EtiquetaEnJerarquia>> {
  late final nuevoValorControl = fb.control("", [Validators.required]);

  ArbolDeEtiquetasViewModel(List<EtiquetaEnJerarquia> valoresIniciales)
      : super(IList.from(valoresIniciales));

  void agregarValor() {
    nuevoValorControl.markAsTouched();
    if (nuevoValorControl.valid) {
      state =
          state.appendElement(EtiquetaEnJerarquia(nuevoValorControl.value!));
      nuevoValorControl.reset();
    }
  }

  void eliminarValor(EtiquetaEnJerarquia valor) {
    state = state.remove(valor);
  }

  void agregarHijo(
      EtiquetaEnJerarquia valor, List<EtiquetaEnJerarquia> children) {
    state = state.update(
        valor, (etiqueta) => etiqueta.copyWith(children: children));
  }
}
