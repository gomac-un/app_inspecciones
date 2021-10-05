import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'credenciales.dart';

final loginControlProvider = Provider((ref) => LoginControl(ref.read));

/// View model para el login
class LoginControl extends FormGroup {
  final Reader read;
  LoginControl(this.read)
      : super({
          'usuario': fb.control('', [Validators.required]),
          'password': fb.control('', [Validators.required]),
        });

  Future<void> submit({
    VoidCallback? onStart,
    VoidCallback? onFinish,
    VoidCallback? onSuccess,
    void Function(AuthFailure failure)? onFailure,
  }) async {
    try {
      onStart?.call();

      final credenciales = getCredenciales();
      final authService = read(authProvider.notifier);
      await authService.login(credenciales,
          offline: false, onSuccess: onSuccess, onFailure: onFailure);
    } catch (exception, _) {
      onFailure?.call(AuthFailure.unexpectedError(exception));
    } finally {
      onFinish?.call();
    }
  }

  Credenciales getCredenciales() {
    return Credenciales(
      username: value['usuario'] as String,
      password: value['password'] as String,
    );
  }
}
