import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';
import 'package:inspecciones/domain/cuestionario/cuestionario.dart';
import 'package:inspecciones/domain/cuestionario/cuestionario_failure.dart';

abstract class ICuestionarioRepository {
  Stream<Either<CuestionarioFailure, KtList<Cuestionario>>> watchAll();
  Stream<Either<CuestionarioFailure, KtList<Cuestionario>>> watchUncompleted();
  Future<Either<CuestionarioFailure, Unit>> create(Cuestionario cuestionario);
  Future<Either<CuestionarioFailure, Unit>> update(Cuestionario cuestionario);
  Future<Either<CuestionarioFailure, Unit>> delete(Cuestionario cuestionario);
}
