import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/infrastructure/repositories/user_repository.dart';

import 'sincronizacion_controller.dart';

final sincronizacionProvider =
    StateNotifierProvider<SincronizacionController, SincronizacionState>(
        (ref) => SincronizacionController(ref.read));

/// Emite estado con fecha de la ultima descarga de datos realizada
final momentoDeSincronizacionProvider =
    StateNotifierProvider<_MomentoDeSincronizacionNotifier, DateTime?>((ref) =>
        _MomentoDeSincronizacionNotifier(ref.watch(userRepositoryProvider)));

class _MomentoDeSincronizacionNotifier extends StateNotifier<DateTime?> {
  final UserRepository _userRepository;
  _MomentoDeSincronizacionNotifier(this._userRepository)
      : super(_userRepository.getUltimaSincronizacion());
  void sincronizar() {
    state = DateTime.now();
    _userRepository.saveUltimaSincronizacion(state!);
  }
}
