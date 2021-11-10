import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/inspecciones/inspecciones_failure.dart';
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

final cuestionarioProvider = FutureProvider.family<
        Either<InspeccionesFailure, CuestionarioInspeccionado>,
        IdentificadorDeInspeccion>(
    (ref, inspeccionId) => ref
        .watch(inspeccionesRepositoryProvider)
        .cargarInspeccionLocal(inspeccionId));
//TODO: hacer que este y otros providers hagan dispose cuando se dejen de usar
// para liberar memoria
final controladorLlenadoInspeccionProvider = FutureProvider.family<
        ControladorLlenadoInspeccion, IdentificadorDeInspeccion>(
    (ref, inspeccionId) async => ControladorLlenadoInspeccion(
          (await ref.watch(cuestionarioProvider(inspeccionId).future)).fold(
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
  InspeccionesRepository get repository =>
      _read(inspeccionesRepositoryProvider);
  final ControladorFactory factory;
  final CuestionarioInspeccionado cuestionario;

  /// usado para leer providers
  final Reader _read;

  late final List<ControladorDePregunta> controladores = cuestionario.bloques
      .whereType<Pregunta>()
      .map(factory.crearControlador)
      .toList();

  late final FormArray formArray =
      fb.array(controladores.map((e) => e.control).toList());

  ControladorLlenadoInspeccion(
    this.cuestionario,
    this.factory,
    this._read,
  ) {
    _read(estadoDeInspeccionProvider).state = cuestionario.inspeccion.estado;
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
      final i = cuestionario.inspeccion;
      final estado = _read(estadoDeInspeccionProvider).state;
      final inspeccionAGuardar = Inspeccion(
        id: i.id,
        estado: estado,
        activo: i.activo,
        momentoBorradorGuardado: DateTime.now(),
        momentoEnvio:
            estado == EstadoDeInspeccion.finalizada ? DateTime.now() : null,
      );
      final visitor = GuardadoVisitor(
        repository,
        controladores,
        inspeccionAGuardar,
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

  void iniciarReparaciones(
      {VoidCallback? onInvalid, VoidCallback? mensajeReparacion}) {
    final esValida = _validarInspeccion();
    if (!esValida) {
      onInvalid?.call();
      return;
    }

    mensajeReparacion?.call();
    _read(estadoDeInspeccionProvider).state = EstadoDeInspeccion.enReparacion;
    _read(filtroPreguntasProvider).state = FiltroPreguntas.criticas;
  }

  void finalizar(
      {required Future<bool?> Function() confirmation,
      required EjecucionCallback ejecutarGuardado,
      VoidCallback? onInvalid}) async {
    final esValida = _validarInspeccion();
    if (!esValida) {
      onInvalid?.call();
      return;
    }

    final c = await confirmation();
    if (c == null || !c) return;
    _read(estadoDeInspeccionProvider).state = EstadoDeInspeccion.finalizada;

    await ejecutarGuardado(
        guardarInspeccion); //TODO: si falla se debe devolver al estado inicial

    formArray.markAsDisabled();
    _read(filtroPreguntasProvider).state = FiltroPreguntas.todas;
  }

  bool _validarInspeccion() {
    formArray.markAllAsTouched();
    if (!formArray.valid) {
      return false;
    }
    return true;
  }

  void dispose() {
    formArray.dispose();
  }
}
