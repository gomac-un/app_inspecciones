part of 'sincronizacion_notifier.dart';

@freezed
class SincronizacionState with _$SincronizacionState {
  const factory SincronizacionState.initial(int paso) = SincronizacionInitial;
  const factory SincronizacionState.inProgress(int paso) =
      SincronizacionInProgress;
  const factory SincronizacionState.success(int paso) = SincronizacionSuccess;
  const factory SincronizacionState.failure(int paso) = SincronizacionFailure;
}

@freezed
class SincronizacionStepState with _$SincronizacionStepState {
  const factory SincronizacionStepState.initial([@Default("") String log]) =
      SincronizacionStepInitial;
  const factory SincronizacionStepState.inProgress(int progress,
      [@Default("") String log]) = SincronizacionStepInProgress;
  const factory SincronizacionStepState.success([@Default("") String log]) =
      SincronizacionStepSuccess;
  const factory SincronizacionStepState.failure([@Default("") String log]) =
      SincronizacionStepFailure;
}
