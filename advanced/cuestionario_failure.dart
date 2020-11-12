import 'package:freezed_annotation/freezed_annotation.dart';

part 'cuestionario_failure.freezed.dart';

@freezed
abstract class CuestionarioFailure with _$CuestionarioFailure {
  const factory CuestionarioFailure.unexpected() = Unexpected;
  const factory CuestionarioFailure.insufficientPermissions() =
      InsufficientPermissions;
  const factory CuestionarioFailure.unableToUpdate() = UnableToUpdate;
}
