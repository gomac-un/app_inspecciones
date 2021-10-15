import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/repositories/app_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';

import 'sincronizacion_controller.dart';

final sincronizacionProvider =
    StateNotifierProvider<SincronizacionController, SincronizacionState>(
        (ref) => SincronizacionController(ref.read));

/// Emite estado con fecha de la ultima descarga de datos realizada
final momentoDeSincronizacionProvider =
    StateNotifierProvider<_MomentoDeSincronizacionNotifier, DateTime?>((ref) =>
        _MomentoDeSincronizacionNotifier(ref.watch(appRepositoryProvider)));

class _MomentoDeSincronizacionNotifier extends StateNotifier<DateTime?> {
  final AppRepository _appRepository;
  _MomentoDeSincronizacionNotifier(this._appRepository)
      : super(_appRepository.getUltimaSincronizacion());
  void sincronizar() {
    state = DateTime.now();
    _appRepository.saveUltimaSincronizacion(state!);
  }
}
