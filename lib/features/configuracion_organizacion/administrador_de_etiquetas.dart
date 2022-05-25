import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/features/configuracion_organizacion/widgets/customList.dart';
import 'package:inspecciones/infrastructure/datasources/providers.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/utils/dartz_x.dart';
import 'package:inspecciones/utils/state_notifier_hook.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'domain/entities.dart';

// TODO: eliminar la duplicacion de codigo

final _organizacionDaoProvider = Provider.autoDispose(
    (ref) => ref.watch(driftDatabaseProvider).organizacionDao);

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

  Future<void> Function(Jerarquia) getVolverEtiquetaEditable(WidgetRef ref) =>
      tipoDeEtiqueta == TipoDeEtiqueta.activo
          ? ref.read(_organizacionDaoProvider).volverEtiquetaEditableDeActivo
          : ref.read(_organizacionDaoProvider).volverEtiquetaEditableDePregunta;

  Future<void> Function(Jerarquia) getAgregarEtiqueta(WidgetRef ref) =>
      tipoDeEtiqueta == TipoDeEtiqueta.activo
          ? ref.read(_organizacionDaoProvider).agregarEtiquetaDeActivo
          : ref.read(_organizacionDaoProvider).agregarEtiquetaDePregunta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final etiquetas = getEtiquetas(ref);
    final user = ref.watch(userProvider);
    //final repoLocal = ref.watch(_organizacionDaoProvider);

    return etiquetas.when(
        error: (e, _) => Center(child: Text(e.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (etiquetas) {
          return AlertDialog(
            title: Row(
              children: [
                Text(
                    "Categoría de ${EnumToString.convertToString(tipoDeEtiqueta)}"),
                IconButton(
                  icon: const Icon(Icons.sync_outlined),
                  tooltip: "Sincronizar etiquetas",
                  onPressed: () => getSincronizarEtiquetas(ref)().then((res) =>
                      res.fold(
                          (l) => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Error"),
                                    content: Text(l.toString()),
                                  )),
                          (r) => ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Etiquetas sincronizadas"),
                              )))),
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
                        trailing: user?.esAdmin ?? false
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!etiqueta.esLocal)
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined),
                                      onPressed: () async {
                                        final res = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text("eliminar"),
                                                  content: const Text(
                                                      "Está a punto de permitir la modificación de una etiqueta que ya está subida, asegúrese que nadie más la esté editando ya que se podría perder información"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        child: const Text(
                                                            "Cancelar")),
                                                    TextButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true),
                                                        child:
                                                            const Text("ok")),
                                                  ],
                                                ));
                                        if (res ?? false) {
                                          await getVolverEtiquetaEditable(ref)(
                                              etiqueta);
                                        }
                                      },
                                    ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outlined),
                                    onPressed: () async {
                                      final res = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text("Alerta"),
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
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      child: const Text("si")),
                                                ],
                                              ));
                                      if (res == null) return;
                                      if (res) {
                                        if (!etiqueta.esLocal) {
                                          await getEliminarEtiquetaRemota(ref)(
                                              etiqueta.niveles.first);
                                        }
                                        await getEliminarEtiquetaLocal(ref)(
                                            etiqueta);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "etiqueta eliminada")));
                                      }
                                    },
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    Text(
                      "Para guardar cualquier cambio que realice, presione el botón de sincronizar",
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              if (user?.esAdmin ?? false)
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
                        final arbol =
                            await showDialog<List<EtiquetaEnJerarquia>>(
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
                        final arbol =
                            await showDialog<List<EtiquetaEnJerarquia>>(
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
        scrollable: true,
        insetPadding: const EdgeInsets.all(8.0),
        title: const Text("Agregar categoría"),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReactiveTextField(
                formControl: viewModel.claveControl,
                decoration: const InputDecoration(
                  labelText: "Categoría",
                ),
              ),
              const SizedBox(height: 10),
              ReactiveCheckboxListTile(
                formControl: viewModel.jerarquiaControl,
                title: const Text("Subcategoría"),
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text(
                  '¿Necesitas ayuda?',
                ),
                trailing: const SizedBox.shrink(),
                leading: Icon(Icons.help,
                    color: Theme.of(context).colorScheme.secondary),
                children: const [
                  Text(
                      'En el campo principal, escribe la categoría que quieres agregar.'),
                  SizedBox(
                    height: 8.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '¿Para que sirve?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  CustomListItem(
                      text:
                          'Categoría de activo: permite asignar una inspección a los activos que la usen.'),
                  CustomListItem(
                      text:
                          'Categoría de pregunta: permite clasificar componentes de preguntas.'),
                  Text(
                      'Si quieres agregar una subcategoría, marca la casilla de arriba'),
                  SizedBox(
                    height: 8.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '¿Para que sirve?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  CustomListItem(
                      text:
                          'Permite clasificar de forma más detallada una categoría, por ejemplo: pais > ciudad > barrio'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ReactiveFormConsumer(
            builder: (context, form, child) {
              return TextButton(
                child: const Text("Agregar"),
                onPressed: !form.valid
                    ? null
                    : () {
                        Navigator.of(context).pop(
                          Tuple2(viewModel.claveControl.value!.trim(),
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
            "Por favor agregue los nombres de cada subcategoría, no use nombres que ya existan en otra categoría",
            style: Theme.of(context).textTheme.caption,
          ),
          Text(
            "Podrá agregar valores a cada subcategoría seleccionando el valor correspondiente en la pantalla principal ",
            style: Theme.of(context).textTheme.caption,
          ),
          Text(
            "Importante: No se pueden modificar los nombres una vez creados",
            style: Theme.of(context)
                .textTheme
                .overline
                ?.copyWith(color: Colors.red),
          ),
          Flexible(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final valor in niveles.toIterable())
                      if (valor != claveBase)
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
                              labelText: "Nueva subcategoría",
                            ),
                            showErrors: (_) => false,
                            onEditingComplete: viewModel.agregarNivel,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => viewModel.agregarNivel(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Continuar"),
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
      state = state.appendElement(nuevoNivelControl.value!.trim());
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
    final stateNotifierState = useStateNotifier<
        IList<EtiquetaEnJerarquiaConController>,
        ArbolDeEtiquetasViewModel>(() => ArbolDeEtiquetasViewModel(arbol));

    final viewModel = stateNotifierState.notifier;
    final valores = stateNotifierState.state;

    return WillPopScope(
      onWillPop: () async {
        _popConLaInformacion(context, viewModel);
        return true;
      },
      child: AlertDialog(
        title: Text(clave + (valorPadre != null ? " de $valorPadre" : "")),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
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
                            valor.nombreControl == null
                                ? _buildEtiqueta(context, viewModel, valor)
                                : _buildEtiquetaEditable(viewModel, valor),
                          if (!readOnly)
                            Row(
                              children: [
                                Expanded(
                                  child: ReactiveTextField(
                                    formControl: viewModel.nuevoValorControl,
                                    decoration: InputDecoration(
                                      labelText: clave,
                                    ),
                                    showErrors: (c) =>
                                        c.hasErrors &&
                                        !c.hasError(ValidationMessage.required),
                                    onEditingComplete: viewModel.agregarValor,
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
                if (!esUltimoNivel && valores.toIterable().isNotEmpty)
                  Text(
                    (readOnly
                        ? ""
                        : "Para agregar ${niveles[profundidad + 1]}, seleccione ${niveles[profundidad]} correspondiente"),
                    style: Theme.of(context).textTheme.caption,
                  ),
                if (!readOnly)
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: const Text(
                      '¿Necesitas ayuda?',
                    ),
                    trailing: const SizedBox.shrink(),
                    leading: Icon(Icons.help,
                        color: Theme.of(context).colorScheme.secondary),
                    children: [
                      Text(
                          'Agregue los valores que puede tener la categoría ${clave + (valorPadre != null ? " de $valorPadre" : "")}. Escriba el valor y presione + para agregarlo.'),
                      const SizedBox(height: 8.0),
                      const Text(
                          'Cuando termine de agregar los valores, presione siguiente. \nNo te preocupes, podrás editar o agregar nuevos valores después.'),
                    ],
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Atrás"),
            onPressed: () => _popConLaInformacion(context, viewModel),
          ),
          TextButton(
            child: const Text("Siguiente"),
            onPressed: () => _popConLaInformacion(context, viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildEtiquetaEditable(ArbolDeEtiquetasViewModel viewModel,
      EtiquetaEnJerarquiaConController valor) {
    return ListTile(
      title: ReactiveTextField(
        formControl: valor.nombreControl,
        decoration: InputDecoration(
          labelText: clave,
        ),
        onSubmitted: () => viewModel.finalizarEdicion(valor),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.check),
        onPressed: () => viewModel.finalizarEdicion(valor),
      ),
    );
  }

  Widget _buildEtiqueta(
      BuildContext context,
      ArbolDeEtiquetasViewModel viewModel,
      EtiquetaEnJerarquiaConController valor) {
    final etiqueta = valor.etiqueta;
    return ListTile(
      title: Text("${etiqueta.valor} (${etiqueta.children.length})"),
      onTap: esUltimoNivel
          ? null
          : () async {
              final children = await showDialog<List<EtiquetaEnJerarquia>>(
                context: context,
                builder: (_) => CreacionDeArbolDeEtiquetasDialog(
                  niveles: niveles,
                  profundidad: profundidad + 1,
                  arbol: etiqueta.children,
                  valorPadre: etiqueta.valor,
                  readOnly: readOnly,
                ),
              );
              if (children == null) return;

              viewModel.agregarSubArbol(valor, children);
            },
      trailing: readOnly
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => viewModel.comenzarEdicion(valor),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outlined),
                  onPressed: () async {
                    final confirmacion = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Eliminar ${etiqueta.valor}"),
                        content: Text(
                            "¿Está seguro que desea eliminar ${etiqueta.valor}? esto eliminará también todas las etiquetas que dependen de esta."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("no"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
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
              ],
            ),
    );
  }

  void _popConLaInformacion(
      BuildContext context, ArbolDeEtiquetasViewModel viewModel) {
    if (readOnly) return Navigator.of(context).pop();
    viewModel.agregarValor();
    // ignore: invalid_use_of_protected_member
    Navigator.of(context)
        .pop(viewModel.state.map((ec) => ec.etiqueta).toIterable().toList());
  }
}

class EtiquetaEnJerarquiaConController {
  final FormControl<String>? nombreControl;
  final EtiquetaEnJerarquia etiqueta;
  EtiquetaEnJerarquiaConController(this.etiqueta, [this.nombreControl]);
}

class ArbolDeEtiquetasViewModel
    extends StateNotifier<IList<EtiquetaEnJerarquiaConController>> {
  late final nuevoValorControl =
      fb.control("", [Validators.required, _noSeRepiteValidator]);

  ArbolDeEtiquetasViewModel(List<EtiquetaEnJerarquia> valoresIniciales)
      : super(IList.from(
            valoresIniciales.map((e) => EtiquetaEnJerarquiaConController(e))));

  void agregarValor() {
    nuevoValorControl.markAsTouched();
    nuevoValorControl.updateValueAndValidity();
    if (nuevoValorControl.valid) {
      state = state.appendElement(EtiquetaEnJerarquiaConController(
          EtiquetaEnJerarquia(nuevoValorControl.value!.trim())));
      nuevoValorControl.reset();
    }
  }

  void eliminarValor(EtiquetaEnJerarquiaConController valor) {
    state = state.remove(valor);
  }

  void agregarSubArbol(EtiquetaEnJerarquiaConController valor,
      List<EtiquetaEnJerarquia> children) {
    state = state.update(
        valor,
        (etiqueta) => EtiquetaEnJerarquiaConController(
            etiqueta.etiqueta.copyWith(children: children)));
  }

  void comenzarEdicion(EtiquetaEnJerarquiaConController valor) {
    state = state.update(
        valor,
        (etiqueta) => EtiquetaEnJerarquiaConController(etiqueta.etiqueta,
            fb.control(etiqueta.etiqueta.valor, [Validators.required])));
  }

  void finalizarEdicion(EtiquetaEnJerarquiaConController valor) {
    if (!valor.nombreControl!.valid) return;
    state = state.update(
        valor,
        (etiqueta) => EtiquetaEnJerarquiaConController(etiqueta.etiqueta
            .copyWith(valor: valor.nombreControl!.value!.trim())));
    valor.nombreControl!.dispose();
  }

  Map<String, dynamic>? _noSeRepiteValidator(AbstractControl<dynamic> control) {
    final error = <String, dynamic>{'repetido': true};

    if (control.value == null) {
      return null;
    }

    if (state.any((a) => a.etiqueta.valor == control.value!)) {
      return error;
    }

    return null;
  }

  @override
  void dispose() {
    nuevoValorControl.dispose();
    for (final etiqueta in state.toIterable()) {
      etiqueta.nombreControl?.dispose();
    }
    super.dispose();
  }
}
