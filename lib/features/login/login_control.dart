import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'credenciales.dart';

final loginControlProvider = Provider((ref) => LoginControl(ref.read));

/// View model para el login
class LoginControl extends FormGroup {
  final Reader _read;
  LoginControl(this._read)
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

      final authService = _read(authProvider.notifier);
      await authService.login(getCredenciales(),
          offline: false, onSuccess: onSuccess, onFailure: onFailure);
    } catch (exception, _) {
      onFailure?.call(AuthFailure.unexpectedError(exception));
    } finally {
      reset();
      onFinish?.call();
    }
  }

  Future<void> loginOffline() async {
    final authService = _read(authProvider.notifier);
    return authService.login(getCredenciales(), offline: true);
  }

  Credenciales getCredenciales() {
    return Credenciales(
      username: value['usuario'] as String,
      password: value['password'] as String,
    );
  }
}
