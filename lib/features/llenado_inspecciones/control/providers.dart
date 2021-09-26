import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'controlador_de_pregunta.dart';

// codigo util para depurar providers, usar en el build method
// print("criticidad pregunta ${controladorPregunta.criticidadPregunta}");
// print(
//     "respuestaProvider ${ref.read(criticidadRespuestaProvider(controladorPregunta))}");
// print("reparado $reparado");
// print("calculada: $criticidadCalculada");
// ref.listen<AsyncValue<int>>(
//     criticidadRespuestaProvider(controladorPregunta), (v) {
//   print(v);
// });

final ProviderFamily<bool, AbstractControl> controlValidoProvider =
    Provider.family<bool, AbstractControl>((ref, control) {
  StreamSubscription? subscription;
  subscription = control.statusChanged.listen((_) {
    ref.refresh(controlValidoProvider(control));
    subscription?.cancel();
  });
  return control.valid;
});

/// provider para la criticidad de la respuesta de un [ControladorDePregunta]
final ProviderFamily<int?, ControladorDePregunta> criticidadRespuestaProvider =
    Provider.family<int?, ControladorDePregunta>((ref, controlador) {
  StreamSubscription? subscription;
  subscription =
      controlador.respuestaEspecificaControl.valueChanges.listen((_) {
    ref.refresh(criticidadRespuestaProvider(controlador));
    subscription?.cancel();
  });
  return controlador.criticidadRespuesta;
});

final ProviderFamily<bool, FormControl<bool>> reparadoProvider =
    Provider.family<bool, FormControl<bool>>((ref, control) {
  StreamSubscription? subscription;
  subscription = control.valueChanges.listen((_) {
    ref.refresh(reparadoProvider(control));
    subscription?.cancel();
  });
  return control.value!;
});

/// calcula lo mismo que [ControladorDePregunta.criticidadCalculada] pero de manera reactiva
final criticidadCalculadaProvider = Provider.family<int, ControladorDePregunta>(
  (ref, controlador) {
    ref.watch(criticidadRespuestaProvider(controlador));
    ref.watch(reparadoProvider(controlador.reparadoControl));
    return controlador.criticidadCalculada;
  },
);
