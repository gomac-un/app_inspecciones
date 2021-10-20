import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:reactive_forms/reactive_forms.dart';

final registroUsuarioProvider =
    Provider((ref) => RegistroUsuarioControl(ref.read));

class RegistroUsuarioControl {
  final Reader read;
  final nombreControl = fb.control('', [Validators.required]);
  final apellidoControl = fb.control('');
  final emailControl = fb.control('', [Validators.required, Validators.email]);
  final passwordControl = fb.control('', [Validators.required]);
  final passwordConfControl = fb.control('', [Validators.required]);
  final fotoControl = fb.control<AppImage?>(null);

  late final control = fb.group({
    'nombre': fb.control('', [Validators.required]),
    'apellido': fb.control(''),
    'email': fb.control('', [Validators.required, Validators.email]),
    'password': fb.control('', [Validators.required]),
    'password_conf': fb.control('', [Validators.required]),
    'foto': fotoControl,
  });
  RegistroUsuarioControl(this.read);

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
