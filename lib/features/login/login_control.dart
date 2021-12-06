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
  AuthService get _authService => _read(authProvider.notifier);
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

      final res = await _authService.login(getCredenciales());
      res.fold((l) => onFailure?.call(l), (r) {
        onSuccess?.call();
        reset();
      });
    } catch (exception, _) {
      onFailure?.call(AuthFailure.unexpectedError(exception));
    } finally {
      onFinish?.call();
    }
  }

  ///TODO: permitir la seleccion de una organizacion de las que ya tengan informacion offline guardada
  Future<void> loginOffline() =>
      _authService.loginOffline(getCredenciales(), organizacion: "offline");

  Credenciales getCredenciales() {
    return Credenciales(
      username: value['usuario'] as String,
      password: value['password'] as String,
    );
  }
}
