import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:reactive_forms/reactive_forms.dart';

final registroUsuarioProvider =
    Provider((ref) => RegistroUsuarioControl(ref.read));

class RegistroUsuarioControl extends FormGroup {
  final Reader read;
  RegistroUsuarioControl(this.read)
      : super({
          'nombre': fb.control('', [Validators.required]),
          'apellido': fb.control(''),
          'password': fb.control('', [Validators.required]),
          'password_conf': fb.control('', [Validators.required]),
        });

  Future<void> submit({
    VoidCallback? onStart,
    VoidCallback? onFinish,
    VoidCallback? onSuccess,
    void Function(AuthFailure failure)? onFailure,
  }) async {
    try {
      onStart?.call();

      //final registrationService = read(authProvider.notifier);
      //await registrationService.registrarUsuario(data);
    } catch (exception, _) {
      onFailure?.call(AuthFailure.unexpectedError(exception));
    } finally {
      onFinish?.call();
    }
  }
}
