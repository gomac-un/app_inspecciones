import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../domain/bloques/pregunta.dart';
import '../domain/cuestionario.dart';
import '../domain/identificador_inspeccion.dart';
import '../domain/inspeccion.dart';
import '../infrastructure/inspecciones_repository.dart';
import 'controlador_de_pregunta.dart';
import 'controlador_factory.dart';
import 'visitors/guardado_visitor.dart';

typedef CallbackWithMessage = void Function(String message);

typedef GuardadoCallback = Future<void> Function({
  VoidCallback? onStart,
  VoidCallback? onFinish,
  CallbackWithMessage? onSuccess,
  CallbackWithMessage? onError,
});

typedef EjecucionCallback = Future<void> Function(
    GuardadoCallback funcionDeGuardado);

final controladorFactoryProvider = Provider((ref) => ControladorFactory());

final inspeccionIdProvider =
    StateProvider<IdentificadorDeInspeccion?>((ref) => null);

final cuestionarioProvider = FutureProvider((ref) => ref
    .watch(inspeccionesRepositoryProvider)
    .cargarInspeccionLocal(ref.watch(inspeccionIdProvider).state!));

final controladorLlenadoInspeccionProvider =
    FutureProvider.autoDispose((ref) async => ControladorLlenadoInspeccion(
          (await ref.watch(cuestionarioProvider.future)).fold(
              (l) => throw l, (r) => r), //TODO: mirar como manejar errores
          ref.watch(controladorFactoryProvider),
          ref.read,
        ));

final estadoDeInspeccionProvider = StateProvider(
  (ref) => EstadoDeInspeccion.finalizada,
  // TODO: mirar como declarar que simplemente esta cargando,
  //de todas maneras este estado no se debe ver en la ui porque el constructor
  //de [ControladorLlenadoInspeccion] le pone el valor que viene de la DB.
);

enum FiltroPreguntas {
  todas,
  criticas,
  invalidas,
}
final filtroDisponibleProvider = StateProvider((_) => FiltroPreguntas.values);
final filtroPreguntasProvider = StateProvider((_) => FiltroPreguntas.todas);

class ControladorLlenadoInspeccion {
  final ControladorFactory factory;
  final CuestionarioInspeccionado cuestionario;

  /// usado para leer providers
  final Reader read;

  late final List<ControladorDePregunta> controladores = cuestionario.bloques
      .whereType<Pregunta>()
      .map(factory.crearControlador)
      .toList();

  late final FormArray formArray =
      fb.array(controladores.map((e) => e.control).toList());

  ControladorLlenadoInspeccion(
    this.cuestionario,
    this.factory,
    this.read,
  ) {
    read(estadoDeInspeccionProvider).state = cuestionario.inspeccion.estado;
  }

  @pragma('vm:notify-debugger-on-exception')
  Future<void> guardarInspeccion({
    VoidCallback? onStart,
    VoidCallback? onFinish,
    CallbackWithMessage? onSuccess,
    CallbackWithMessage? onError,
  }) async {
    try {
      onStart?.call();
      final repository = read(inspeccionesRepositoryProvider);
      final visitor = GuardadoVisitor(
        repository,
        controladores,
        inspeccionId: cuestionario.inspeccion.id,
      );
      await visitor.guardarInspeccion();
      onSuccess?.call("Inspeccion guardada");
    } catch (exception, stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: exception,
        stack: stack,
        library: 'inspecciones',
        context: ErrorDescription('while saving inspeccion'),
        /*informationCollector: () sync* {
          yield DiagnosticsProperty<ChangeNotifier>(
            'The $runtimeType sending notification was',
            this,
            style: DiagnosticsTreeStyle.errorProperty,
          );
        },*/
      ));
      onError?.call(exception.toString());
    } finally {
      onFinish?.call();
    }
  }

  bool _validarInspeccion({VoidCallback? onInvalid}) {
    formArray.markAllAsTouched();
    if (!formArray.valid) {
      onInvalid?.call();
      return false;
    }
    return true;
  }

  void iniciarReparaciones({VoidCallback? onInvalid}) {
    final esValida = _validarInspeccion(onInvalid: onInvalid);
    if (!esValida) return;

    read(estadoDeInspeccionProvider).state = EstadoDeInspeccion.enReparacion;
    read(filtroPreguntasProvider).state = FiltroPreguntas.criticas;
  }

  void finalizar(
      {required Future<bool?> Function() confirmation,
      required EjecucionCallback ejecutarGuardado,
      VoidCallback? onInvalid}) async {
    final esValida = _validarInspeccion(onInvalid: onInvalid);
    if (!esValida) return;

    final c = await confirmation();
    if (c == null || !c) return;
    await ejecutarGuardado(guardarInspeccion);
    read(estadoDeInspeccionProvider).state = EstadoDeInspeccion.finalizada;
    formArray.markAsDisabled();
    read(filtroPreguntasProvider).state = FiltroPreguntas.todas;
  }

  void dispose() {
    //estadoDeInspeccion.dispose();
    formArray.dispose();
  }
}
