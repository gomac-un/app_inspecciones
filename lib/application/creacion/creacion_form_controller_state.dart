part of 'creacion_form_controller_cubit.dart';

@freezed
class CreacionFormControllerState with _$CreacionFormControllerState {
  const factory CreacionFormControllerState.initial() =
      CreacionFormControllerInitial;
  const factory CreacionFormControllerState.inProgress() =
      CreacionFormControllerInProgress;
  const factory CreacionFormControllerState.success(
      CreacionFormController controller) = CreacionFormControllerSuccess;
  const factory CreacionFormControllerState.failure(Object exception) =
      CreacionFormControllerFailure;
}
