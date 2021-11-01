import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'domain/entities.dart';

final configuracionOrganizacionProvider = Provider.autoDispose
    .family<ConfiguracionOrganizacionControl, Organizacion?>((ref, org) {
  final control = ConfiguracionOrganizacionControl(
    ref.read,
    organizacion: org,
  );
  return control;
});

class ConfiguracionOrganizacionControl {
  final Reader _read;

  /// si es null, la organizacion es nueva
  final Organizacion? organizacion;

  late final nombreControl =
      fb.control(organizacion?.nombre ?? '', [Validators.required]);
  late final logoControl = fb.control<AppImage?>(
      organizacion?.link == null ? null : RemoteImage(organizacion!.logo));
  late final linkControl = fb.control(organizacion?.link ?? '');
  late final acercaControl = fb.control(organizacion?.acerca ?? '');

  late final FormGroup control;

  ConfiguracionOrganizacionControl(this._read, {this.organizacion}) {
    control = FormGroup({
      'nombre': nombreControl,
      'logo': logoControl,
      'link': linkControl,
      'acerca': acercaControl,
    });
  }

  Future<void> submit({
    VoidCallback? onStart,
    VoidCallback? onFinish,
    VoidCallback? onSuccess,
    void Function(ApiFailure failure)? onFailure,
  }) async {
    try {
      onStart?.call();

      final repo = _read(organizacionRemoteRepositoryProvider);

      final Either<ApiFailure, Unit> res;
      if (organizacion == null) {
        res = await repo.crearOrganizacion(formulario: control.value);
      } else {
        res = await repo.actualizarOrganizacion(
            id: organizacion!.id, formulario: control.value);
      }

      res.fold((f) => onFailure?.call(f), (_) => onSuccess?.call());
    } catch (exception, _) {
      onFailure?.call(ApiFailure.errorDeProgramacion(exception.toString()));
    } finally {
      onFinish?.call();
    }
  }

  void dispose() => control.dispose();
}
