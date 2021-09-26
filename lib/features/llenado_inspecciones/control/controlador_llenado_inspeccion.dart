import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../domain/bloques/pregunta.dart';
import '../domain/cuestionario.dart';
import '../domain/inspeccion.dart';
import '../infrastructure/inspecciones_repository.dart';
import 'controlador_de_pregunta.dart';
import 'controlador_factory.dart';
import 'visitors/guardado_visitor.dart';

typedef CallbackWithMessage = void Function(String message);

final controladorFactoryProvider = Provider((ref) => ControladorFactory());

final inspeccionIdProvider = StateProvider((ref) => 1);

final cuestionarioProvider = FutureProvider.autoDispose
    .family<CuestionarioInspeccionado, int>((ref, inspeccionId) => ref
        .watch(inspeccionesRepositoryProvider)
        .cargarInspeccion(inspeccionId));

final controladorLlenadoInspeccionProvider =
    FutureProvider.autoDispose((ref) async => ControladorLlenadoInspeccion(
          await ref.watch(
              cuestionarioProvider(ref.watch(inspeccionIdProvider).state)
                  .future),
          ref.watch(controladorFactoryProvider),
          ref.read,
        ));

final estadoDeInspeccionProvider = StateProvider.autoDispose((ref) =>
    ref.watch(cuestionarioProvider(ref.watch(inspeccionIdProvider).state)).when(
          data: (cuestionario) => cuestionario.inspeccion.estado,
          loading: () => EstadoDeInspeccion.finalizada,
          // TODO: mirar como declarar que simplemente esta cargando, de todas maneras este estado no se debe ver en la ui
          error: (_, __) => EstadoDeInspeccion.finalizada,
        ));

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
  );

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

  void iniciarReparaciones({VoidCallback? onInvalid}) {
    formArray.markAllAsTouched();
    if (!esValida) {
      onInvalid?.call();
    } else {
      read(estadoDeInspeccionProvider).state = EstadoDeInspeccion.enReparacion;
      read(filtroPreguntasProvider).state = FiltroPreguntas.criticas;
    }
  }

  void finalizar() async {
    await guardarInspeccion();
    read(estadoDeInspeccionProvider).state = EstadoDeInspeccion.finalizada;
    formArray.markAsDisabled();
    read(filtroPreguntasProvider).state = FiltroPreguntas.todas;
  }

  bool get esValida => formArray.valid;

  void dispose() {
    //estadoDeInspeccion.dispose();
    formArray.dispose();
  }
}
