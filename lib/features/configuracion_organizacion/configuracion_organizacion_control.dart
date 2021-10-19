import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/domain/auth/auth_failure.dart';
import 'package:reactive_forms/reactive_forms.dart';

final configuracionOrganizacionProvider =
    Provider((ref) => ConfiguracionOrganizacionControl(ref.read));

class ConfiguracionOrganizacionControl {
  final Reader read;

  final logoControl = fb.control<List<AppImage>>([]);
  final nombreControl = fb.control('', [Validators.required]);

  late final control = FormGroup({
    'logo': logoControl,
    'nombre': nombreControl,
  });
  ConfiguracionOrganizacionControl(this.read);

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
