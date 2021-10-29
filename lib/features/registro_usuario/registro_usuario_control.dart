import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:reactive_forms/reactive_forms.dart';

final registroUsuarioProvider = Provider.autoDispose((ref) {
  final control = RegistroUsuarioControl(ref.read);
  ref.onDispose(control.dispose);
  return control;
});

class RegistroUsuarioControl {
  final Reader _read;
  final nombreControl = fb.control('', [Validators.required]);
  final apellidoControl = fb.control('');
  final emailControl = fb.control('', [Validators.required, Validators.email]);
  final celularControl = fb.control('', [Validators.required]);
  final usernameControl = fb.control('');
  final passwordControl = fb.control('', [Validators.required]);
  final passwordConfControl = fb.control('', [Validators.required]);
  final fotoControl = fb.control<AppImage?>(null);
  final aceptoControl = fb.control(false, [Validators.requiredTrue]);

  late final FormGroup control;

  RegistroUsuarioControl(this._read) {
    control = FormGroup({
      'nombre': nombreControl,
      'apellido': apellidoControl,
      'email': emailControl,
      'celular': celularControl,
      'username': usernameControl,
      'password': passwordControl,
      'password_conf': passwordConfControl,
      'foto': fotoControl,
      'acepto': aceptoControl,
    }, validators: [
      Validators.mustMatch('password', 'password_conf'),
    ]);
  }

  Future<void> submit({
    VoidCallback? onStart,
    VoidCallback? onFinish,
    void Function(String username)? onSuccess,
    void Function(ApiFailure failure)? onFailure,
    required int organizacionId,
  }) async {
    try {
      onStart?.call();

      final repo = _read(userRepositoryProvider);
      final res = await repo.registrarUsuario(
        formulario: {
          ...control.value,
          'organizacion': organizacionId,
        }
          ..remove('password_conf')
          ..remove('acepto'),
      );
      res.fold(
          (f) => onFailure?.call(f), (username) => onSuccess?.call(username));
    } catch (exception, _) {
      onFailure?.call(ApiFailure.errorDeProgramacion(exception.toString()));
    } finally {
      onFinish?.call();
    }
  }

  void dispose() => control.dispose();
}
