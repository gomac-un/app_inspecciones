import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/domain/api/api_failure.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';

final cuestionarioListViewModelProvider = Provider((ref) =>
    CuestionarioListViewModel(ref.watch(cuestionariosRepositoryProvider)));

class CuestionarioListViewModel {
  final CuestionariosRepository _cuestionariosRepository;

  CuestionarioListViewModel(this._cuestionariosRepository);

  Stream<List<Cuestionario>> getCuestionarios() =>
      _cuestionariosRepository.getCuestionariosLocales();

  Future<Either<ApiFailure, Unit>> subirCuestionario(
          Cuestionario cuestionario) =>
      _cuestionariosRepository.subirCuestionario(cuestionario);

  Future eliminarCuestionario(Cuestionario cuestionario) =>
      _cuestionariosRepository.eliminarCuestionario(cuestionario);
}
