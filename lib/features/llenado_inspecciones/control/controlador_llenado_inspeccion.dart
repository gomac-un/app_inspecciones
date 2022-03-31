import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

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

final controladorLlenadoInspeccionProvider = FutureProvider.autoDispose
    .family<ControladorLlenadoInspeccion, IdentificadorDeInspeccion>(
        (ref, inspeccionId) async {
  final res = ControladorLlenadoInspeccion(
    (await ref
            .watch(inspeccionesRepositoryProvider)
            .cargarInspeccionLocal(inspeccionId))
        .fold((l) => throw l, (r) => r), //TODO: mirar como manejar errores
    ref.watch(controladorFactoryProvider),
    ref.read,
  );
  ref.onDispose(() {
    res.dispose();
  });
  return res;
});

enum FiltroPreguntas {
  todas,
  criticas,
  invalidas,
}

class ControladorLlenadoInspeccion {
  InspeccionesRepository get repository =>
      _read(inspeccionesRepositoryProvider);
  final ControladorFactory factory;
  final CuestionarioInspeccionado cuestionario;

  final Reader _read;

  late final List<ControladorDePregunta> controladores = cuestionario.bloques
      .whereType<Pregunta>()
      .map((p) => factory.crearControlador(p, this))
      .toList();

  late final ValueStream<List<ControladorDePregunta>> controladoresCriticos =
      Rx.combineLatest<Tuple2<ControladorDePregunta, int>,
              List<ControladorDePregunta>>(
          controladores
              .map((c) => c.criticidadCalculada.map((cr) => Tuple2(c, cr))),
          (values) => values
              .where((v) => v.value2 > 0)
              .map((e) => e.value1)
              .toList()).toVSwithInitial(controladoresCriticosSync);

  List<ControladorDePregunta> get controladoresCriticosSync =>
      controladores.where((c) => c.criticidadCalculada.value > 0).toList();

  late final ValueStream<int> criticidadTotal = Rx.combineLatest<int, int>(
          controladores.map((c) => c.criticidadCalculada),
          (values) => values.fold(0, (a, b) => a + b))
      .toVSwithInitial(criticidadTotalSync);

  int get criticidadTotalSync =>
      controladores.fold(0, (a, b) => a + b.criticidadCalculada.value);

  late final ValueStream<int> criticidadTotalConReparaciones =
      Rx.combineLatest<int, int>(
              controladores.map((c) => c.criticidadCalculadaConReparaciones),
              (values) => values.fold(0, (a, b) => a + b))
          .toVSwithInitial(criticidadTotalConReparacionesSync);

  int get criticidadTotalConReparacionesSync => controladores.fold(
      0, (a, b) => a + b.criticidadCalculadaConReparaciones.value);

  late final FormArray formArray =
      fb.array(controladores.map((e) => e.control).toList());

  late final estadoDeInspeccion =
      BehaviorSubject.seeded(cuestionario.inspeccion.estado);
  late final avance = BehaviorSubject.seeded(cuestionario.inspeccion.avance);

  late final filtrosDisponibles =
      BehaviorSubject.seeded(FiltroPreguntas.values);

  late final filtroPreguntas = BehaviorSubject.seeded(FiltroPreguntas.todas);

  ControladorLlenadoInspeccion(
    this.cuestionario,
    this.factory,
    this._read,
  ) {
    if (cuestionario.inspeccion.estado == EstadoDeInspeccion.finalizada) {
      formArray.markAsDisabled();
    }
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
      cuestionario.inspeccion.avance = avance.value;
      cuestionario.inspeccion.estado = estadoDeInspeccion.value;
      cuestionario.inspeccion.criticidadCalculada = criticidadTotal.value;
      cuestionario.inspeccion.criticidadCalculadaConReparaciones =
          criticidadTotalConReparaciones.value;

      final visitor = GuardadoVisitor(
        repository,
        controladores,
        cuestionario,
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
    estadoDeInspeccion.value = EstadoDeInspeccion.enReparacion;
    filtroPreguntas.value = FiltroPreguntas.criticas;
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
    estadoDeInspeccion.value = EstadoDeInspeccion.finalizada;

    await ejecutarGuardado(
        guardarInspeccion); //TODO: si falla se debe devolver al estado inicial

    formArray.markAsDisabled();
    filtroPreguntas.value = FiltroPreguntas.todas;
  }

  bool _validarInspeccion() {
    formArray.markAllAsTouched();
    return formArray.valid;
  }

  void dispose() {
    formArray.dispose();
    estadoDeInspeccion.close();
  }

  void setAvance(double avanceActual) {
    avance.value = avanceActual;
  }
}
