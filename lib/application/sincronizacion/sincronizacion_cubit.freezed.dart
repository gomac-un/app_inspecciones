// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'sincronizacion_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TaskTearOff {
  const _$TaskTearOff();

  _Task call(
      {required path.String id,
      required path.DownloadTaskStatus status,
      required path.int progress}) {
    return _Task(
      id: id,
      status: status,
      progress: progress,
    );
  }
}

/// @nodoc
const $Task = _$TaskTearOff();

/// @nodoc
mixin _$Task {
  path.String get id => throw _privateConstructorUsedError;
  path.DownloadTaskStatus get status => throw _privateConstructorUsedError;
  path.int get progress => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res>;
  $Res call(
      {path.String id, path.DownloadTaskStatus status, path.int progress});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res> implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  final Task _value;
  // ignore: unused_field
  final $Res Function(Task) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? status = freezed,
    Object? progress = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as path.String,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as path.DownloadTaskStatus,
      progress: progress == freezed
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as path.int,
    ));
  }
}

/// @nodoc
abstract class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) then) =
      __$TaskCopyWithImpl<$Res>;
  @override
  $Res call(
      {path.String id, path.DownloadTaskStatus status, path.int progress});
}

/// @nodoc
class __$TaskCopyWithImpl<$Res> extends _$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(_Task _value, $Res Function(_Task) _then)
      : super(_value, (v) => _then(v as _Task));

  @override
  _Task get _value => super._value as _Task;

  @override
  $Res call({
    Object? id = freezed,
    Object? status = freezed,
    Object? progress = freezed,
  }) {
    return _then(_Task(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as path.String,
      status: status == freezed
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as path.DownloadTaskStatus,
      progress: progress == freezed
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as path.int,
    ));
  }
}

/// @nodoc

class _$_Task with DiagnosticableTreeMixin implements _Task {
  _$_Task({required this.id, required this.status, required this.progress});

  @override
  final path.String id;
  @override
  final path.DownloadTaskStatus status;
  @override
  final path.int progress;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Task(id: $id, status: $status, progress: $progress)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Task'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('progress', progress));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Task &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.progress, progress) ||
                const DeepCollectionEquality()
                    .equals(other.progress, progress)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(progress);

  @JsonKey(ignore: true)
  @override
  _$TaskCopyWith<_Task> get copyWith =>
      __$TaskCopyWithImpl<_Task>(this, _$identity);
}

abstract class _Task implements Task {
  factory _Task(
      {required path.String id,
      required path.DownloadTaskStatus status,
      required path.int progress}) = _$_Task;

  @override
  path.String get id => throw _privateConstructorUsedError;
  @override
  path.DownloadTaskStatus get status => throw _privateConstructorUsedError;
  @override
  path.int get progress => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$TaskCopyWith<_Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
class _$SincronizacionStateTearOff {
  const _$SincronizacionStateTearOff();

  SincronizacionInitial initial(path.int paso) {
    return SincronizacionInitial(
      paso,
    );
  }

  SincronizacionInProgress inProgress(path.int paso) {
    return SincronizacionInProgress(
      paso,
    );
  }

  SincronizacionSuccess success(path.int paso) {
    return SincronizacionSuccess(
      paso,
    );
  }

  SincronizacionFailure failure(path.int paso) {
    return SincronizacionFailure(
      paso,
    );
  }
}

/// @nodoc
const $SincronizacionState = _$SincronizacionStateTearOff();

/// @nodoc
mixin _$SincronizacionState {
  path.int get paso => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(path.int paso) initial,
    required TResult Function(path.int paso) inProgress,
    required TResult Function(path.int paso) success,
    required TResult Function(path.int paso) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(path.int paso)? initial,
    TResult Function(path.int paso)? inProgress,
    TResult Function(path.int paso)? success,
    TResult Function(path.int paso)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(path.int paso)? initial,
    TResult Function(path.int paso)? inProgress,
    TResult Function(path.int paso)? success,
    TResult Function(path.int paso)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SincronizacionInitial value) initial,
    required TResult Function(SincronizacionInProgress value) inProgress,
    required TResult Function(SincronizacionSuccess value) success,
    required TResult Function(SincronizacionFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SincronizacionInitial value)? initial,
    TResult Function(SincronizacionInProgress value)? inProgress,
    TResult Function(SincronizacionSuccess value)? success,
    TResult Function(SincronizacionFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SincronizacionInitial value)? initial,
    TResult Function(SincronizacionInProgress value)? inProgress,
    TResult Function(SincronizacionSuccess value)? success,
    TResult Function(SincronizacionFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SincronizacionStateCopyWith<SincronizacionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SincronizacionStateCopyWith<$Res> {
  factory $SincronizacionStateCopyWith(
          SincronizacionState value, $Res Function(SincronizacionState) then) =
      _$SincronizacionStateCopyWithImpl<$Res>;
  $Res call({path.int paso});
}

/// @nodoc
class _$SincronizacionStateCopyWithImpl<$Res>
    implements $SincronizacionStateCopyWith<$Res> {
  _$SincronizacionStateCopyWithImpl(this._value, this._then);

  final SincronizacionState _value;
  // ignore: unused_field
  final $Res Function(SincronizacionState) _then;

  @override
  $Res call({
    Object? paso = freezed,
  }) {
    return _then(_value.copyWith(
      paso: paso == freezed
          ? _value.paso
          : paso // ignore: cast_nullable_to_non_nullable
              as path.int,
    ));
  }
}

/// @nodoc
abstract class $SincronizacionInitialCopyWith<$Res>
    implements $SincronizacionStateCopyWith<$Res> {
  factory $SincronizacionInitialCopyWith(SincronizacionInitial value,
          $Res Function(SincronizacionInitial) then) =
      _$SincronizacionInitialCopyWithImpl<$Res>;
  @override
  $Res call({path.int paso});
}

/// @nodoc
class _$SincronizacionInitialCopyWithImpl<$Res>
    extends _$SincronizacionStateCopyWithImpl<$Res>
    implements $SincronizacionInitialCopyWith<$Res> {
  _$SincronizacionInitialCopyWithImpl(
      SincronizacionInitial _value, $Res Function(SincronizacionInitial) _then)
      : super(_value, (v) => _then(v as SincronizacionInitial));

  @override
  SincronizacionInitial get _value => super._value as SincronizacionInitial;

  @override
  $Res call({
    Object? paso = freezed,
  }) {
    return _then(SincronizacionInitial(
      paso == freezed
          ? _value.paso
          : paso // ignore: cast_nullable_to_non_nullable
              as path.int,
    ));
  }
}

/// @nodoc

class _$SincronizacionInitial
    with DiagnosticableTreeMixin
    implements SincronizacionInitial {
  const _$SincronizacionInitial(this.paso);

  @override
  final path.int paso;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionState.initial(paso: $paso)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionState.initial'))
      ..add(DiagnosticsProperty('paso', paso));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SincronizacionInitial &&
            (identical(other.paso, paso) ||
                const DeepCollectionEquality().equals(other.paso, paso)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(paso);

  @JsonKey(ignore: true)
  @override
  $SincronizacionInitialCopyWith<SincronizacionInitial> get copyWith =>
      _$SincronizacionInitialCopyWithImpl<SincronizacionInitial>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(path.int paso) initial,
    required TResult Function(path.int paso) inProgress,
    required TResult Function(path.int paso) success,
    required TResult Function(path.int paso) failure,
  }) {
    return initial(paso);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(path.int paso)? initial,
    TResult Function(path.int paso)? inProgress,
    TResult Function(path.int paso)? success,
    TResult Function(path.int paso)? failure,
  }) {
    return initial?.call(paso);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(path.int paso)? initial,
    TResult Function(path.int paso)? inProgress,
    TResult Function(path.int paso)? success,
    TResult Function(path.int paso)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(paso);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SincronizacionInitial value) initial,
    required TResult Function(SincronizacionInProgress value) inProgress,
    required TResult Function(SincronizacionSuccess value) success,
    required TResult Function(SincronizacionFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SincronizacionInitial value)? initial,
    TResult Function(SincronizacionInProgress value)? inProgress,
    TResult Function(SincronizacionSuccess value)? success,
    TResult Function(SincronizacionFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SincronizacionInitial value)? initial,
    TResult Function(SincronizacionInProgress value)? inProgress,
    TResult Function(SincronizacionSuccess value)? success,
    TResult Function(SincronizacionFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SincronizacionInitial implements SincronizacionState {
  const factory SincronizacionInitial(path.int paso) = _$SincronizacionInitial;

  @override
  path.int get paso => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $SincronizacionInitialCopyWith<SincronizacionInitial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SincronizacionInProgressCopyWith<$Res>
    implements $SincronizacionStateCopyWith<$Res> {
  factory $SincronizacionInProgressCopyWith(SincronizacionInProgress value,
          $Res Function(SincronizacionInProgress) then) =
      _$SincronizacionInProgressCopyWithImpl<$Res>;
  @override
  $Res call({path.int paso});
}

/// @nodoc
class _$SincronizacionInProgressCopyWithImpl<$Res>
    extends _$SincronizacionStateCopyWithImpl<$Res>
    implements $SincronizacionInProgressCopyWith<$Res> {
  _$SincronizacionInProgressCopyWithImpl(SincronizacionInProgress _value,
      $Res Function(SincronizacionInProgress) _then)
      : super(_value, (v) => _then(v as SincronizacionInProgress));

  @override
  SincronizacionInProgress get _value =>
      super._value as SincronizacionInProgress;

  @override
  $Res call({
    Object? paso = freezed,
  }) {
    return _then(SincronizacionInProgress(
      paso == freezed
          ? _value.paso
          : paso // ignore: cast_nullable_to_non_nullable
              as path.int,
    ));
  }
}

/// @nodoc

class _$SincronizacionInProgress
    with DiagnosticableTreeMixin
    implements SincronizacionInProgress {
  const _$SincronizacionInProgress(this.paso);

  @override
  final path.int paso;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionState.inProgress(paso: $paso)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionState.inProgress'))
      ..add(DiagnosticsProperty('paso', paso));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SincronizacionInProgress &&
            (identical(other.paso, paso) ||
                const DeepCollectionEquality().equals(other.paso, paso)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(paso);

  @JsonKey(ignore: true)
  @override
  $SincronizacionInProgressCopyWith<SincronizacionInProgress> get copyWith =>
      _$SincronizacionInProgressCopyWithImpl<SincronizacionInProgress>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(path.int paso) initial,
    required TResult Function(path.int paso) inProgress,
    required TResult Function(path.int paso) success,
    required TResult Function(path.int paso) failure,
  }) {
    return inProgress(paso);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(path.int paso)? initial,
    TResult Function(path.int paso)? inProgress,
    TResult Function(path.int paso)? success,
    TResult Function(path.int paso)? failure,
  }) {
    return inProgress?.call(paso);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(path.int paso)? initial,
    TResult Function(path.int paso)? inProgress,
    TResult Function(path.int paso)? success,
    TResult Function(path.int paso)? failure,
    required TResult orElse(),
  }) {
    if (inProgress != null) {
      return inProgress(paso);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SincronizacionInitial value) initial,
    required TResult Function(SincronizacionInProgress value) inProgress,
    required TResult Function(SincronizacionSuccess value) success,
    required TResult Function(SincronizacionFailure value) failure,
  }) {
    return inProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SincronizacionInitial value)? initial,
    TResult Function(SincronizacionInProgress value)? inProgress,
    TResult Function(SincronizacionSuccess value)? success,
    TResult Function(SincronizacionFailure value)? failure,
  }) {
    return inProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SincronizacionInitial value)? initial,
    TResult Function(SincronizacionInProgress value)? inProgress,
    TResult Function(SincronizacionSuccess value)? success,
    TResult Function(SincronizacionFailure value)? failure,
    required TResult orElse(),
  }) {
    if (inProgress != null) {
      return inProgress(this);
    }
    return orElse();
  }
}

abstract class SincronizacionInProgress implements SincronizacionState {
  const factory SincronizacionInProgress(path.int paso) =
      _$SincronizacionInProgress;

  @override
  path.int get paso => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $SincronizacionInProgressCopyWith<SincronizacionInProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SincronizacionSuccessCopyWith<$Res>
    implements $SincronizacionStateCopyWith<$Res> {
  factory $SincronizacionSuccessCopyWith(SincronizacionSuccess value,
          $Res Function(SincronizacionSuccess) then) =
      _$SincronizacionSuccessCopyWithImpl<$Res>;
  @override
  $Res call({path.int paso});
}

/// @nodoc
class _$SincronizacionSuccessCopyWithImpl<$Res>
    extends _$SincronizacionStateCopyWithImpl<$Res>
    implements $SincronizacionSuccessCopyWith<$Res> {
  _$SincronizacionSuccessCopyWithImpl(
      SincronizacionSuccess _value, $Res Function(SincronizacionSuccess) _then)
      : super(_value, (v) => _then(v as SincronizacionSuccess));

  @override
  SincronizacionSuccess get _value => super._value as SincronizacionSuccess;

  @override
  $Res call({
    Object? paso = freezed,
  }) {
    return _then(SincronizacionSuccess(
      paso == freezed
          ? _value.paso
          : paso // ignore: cast_nullable_to_non_nullable
              as path.int,
    ));
  }
}

/// @nodoc

class _$SincronizacionSuccess
    with DiagnosticableTreeMixin
    implements SincronizacionSuccess {
  const _$SincronizacionSuccess(this.paso);

  @override
  final path.int paso;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionState.success(paso: $paso)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionState.success'))
      ..add(DiagnosticsProperty('paso', paso));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SincronizacionSuccess &&
            (identical(other.paso, paso) ||
                const DeepCollectionEquality().equals(other.paso, paso)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(paso);

  @JsonKey(ignore: true)
  @override
  $SincronizacionSuccessCopyWith<SincronizacionSuccess> get copyWith =>
      _$SincronizacionSuccessCopyWithImpl<SincronizacionSuccess>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(path.int paso) initial,
    required TResult Function(path.int paso) inProgress,
    required TResult Function(path.int paso) success,
    required TResult Function(path.int paso) failure,
  }) {
    return success(paso);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(path.int paso)? initial,
    TResult Function(path.int paso)? inProgress,
    TResult Function(path.int paso)? success,
    TResult Function(path.int paso)? failure,
  }) {
    return success?.call(paso);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(path.int paso)? initial,
    TResult Function(path.int paso)? inProgress,
    TResult Function(path.int paso)? success,
    TResult Function(path.int paso)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(paso);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SincronizacionInitial value) initial,
    required TResult Function(SincronizacionInProgress value) inProgress,
    required TResult Function(SincronizacionSuccess value) success,
    required TResult Function(SincronizacionFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SincronizacionInitial value)? initial,
    TResult Function(SincronizacionInProgress value)? inProgress,
    TResult Function(SincronizacionSuccess value)? success,
    TResult Function(SincronizacionFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SincronizacionInitial value)? initial,
    TResult Function(SincronizacionInProgress value)? inProgress,
    TResult Function(SincronizacionSuccess value)? success,
    TResult Function(SincronizacionFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SincronizacionSuccess implements SincronizacionState {
  const factory SincronizacionSuccess(path.int paso) = _$SincronizacionSuccess;

  @override
  path.int get paso => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $SincronizacionSuccessCopyWith<SincronizacionSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SincronizacionFailureCopyWith<$Res>
    implements $SincronizacionStateCopyWith<$Res> {
  factory $SincronizacionFailureCopyWith(SincronizacionFailure value,
          $Res Function(SincronizacionFailure) then) =
      _$SincronizacionFailureCopyWithImpl<$Res>;
  @override
  $Res call({path.int paso});
}

/// @nodoc
class _$SincronizacionFailureCopyWithImpl<$Res>
    extends _$SincronizacionStateCopyWithImpl<$Res>
    implements $SincronizacionFailureCopyWith<$Res> {
  _$SincronizacionFailureCopyWithImpl(
      SincronizacionFailure _value, $Res Function(SincronizacionFailure) _then)
      : super(_value, (v) => _then(v as SincronizacionFailure));

  @override
  SincronizacionFailure get _value => super._value as SincronizacionFailure;

  @override
  $Res call({
    Object? paso = freezed,
  }) {
    return _then(SincronizacionFailure(
      paso == freezed
          ? _value.paso
          : paso // ignore: cast_nullable_to_non_nullable
              as path.int,
    ));
  }
}

/// @nodoc

class _$SincronizacionFailure
    with DiagnosticableTreeMixin
    implements SincronizacionFailure {
  const _$SincronizacionFailure(this.paso);

  @override
  final path.int paso;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionState.failure(paso: $paso)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionState.failure'))
      ..add(DiagnosticsProperty('paso', paso));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SincronizacionFailure &&
            (identical(other.paso, paso) ||
                const DeepCollectionEquality().equals(other.paso, paso)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(paso);

  @JsonKey(ignore: true)
  @override
  $SincronizacionFailureCopyWith<SincronizacionFailure> get copyWith =>
      _$SincronizacionFailureCopyWithImpl<SincronizacionFailure>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(path.int paso) initial,
    required TResult Function(path.int paso) inProgress,
    required TResult Function(path.int paso) success,
    required TResult Function(path.int paso) failure,
  }) {
    return failure(paso);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(path.int paso)? initial,
    TResult Function(path.int paso)? inProgress,
    TResult Function(path.int paso)? success,
    TResult Function(path.int paso)? failure,
  }) {
    return failure?.call(paso);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(path.int paso)? initial,
    TResult Function(path.int paso)? inProgress,
    TResult Function(path.int paso)? success,
    TResult Function(path.int paso)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(paso);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SincronizacionInitial value) initial,
    required TResult Function(SincronizacionInProgress value) inProgress,
    required TResult Function(SincronizacionSuccess value) success,
    required TResult Function(SincronizacionFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SincronizacionInitial value)? initial,
    TResult Function(SincronizacionInProgress value)? inProgress,
    TResult Function(SincronizacionSuccess value)? success,
    TResult Function(SincronizacionFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SincronizacionInitial value)? initial,
    TResult Function(SincronizacionInProgress value)? inProgress,
    TResult Function(SincronizacionSuccess value)? success,
    TResult Function(SincronizacionFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class SincronizacionFailure implements SincronizacionState {
  const factory SincronizacionFailure(path.int paso) = _$SincronizacionFailure;

  @override
  path.int get paso => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $SincronizacionFailureCopyWith<SincronizacionFailure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$SincronizacionStepStateTearOff {
  const _$SincronizacionStepStateTearOff();

  SincronizacionStepInitial initial([path.String log = ""]) {
    return SincronizacionStepInitial(
      log,
    );
  }

  SincronizacionStepInProgress inProgress(path.int progress,
      [path.String log = ""]) {
    return SincronizacionStepInProgress(
      progress,
      log,
    );
  }

  SincronizacionStepSuccess success([path.String log = ""]) {
    return SincronizacionStepSuccess(
      log,
    );
  }

  SincronizacionStepFailure failure([path.String log = ""]) {
    return SincronizacionStepFailure(
      log,
    );
  }
}

/// @nodoc
const $SincronizacionStepState = _$SincronizacionStepStateTearOff();

/// @nodoc
mixin _$SincronizacionStepState {
  path.String get log => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(path.String log) initial,
    required TResult Function(path.int progress, path.String log) inProgress,
    required TResult Function(path.String log) success,
    required TResult Function(path.String log) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(path.String log)? initial,
    TResult Function(path.int progress, path.String log)? inProgress,
    TResult Function(path.String log)? success,
    TResult Function(path.String log)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(path.String log)? initial,
    TResult Function(path.int progress, path.String log)? inProgress,
    TResult Function(path.String log)? success,
    TResult Function(path.String log)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SincronizacionStepInitial value) initial,
    required TResult Function(SincronizacionStepInProgress value) inProgress,
    required TResult Function(SincronizacionStepSuccess value) success,
    required TResult Function(SincronizacionStepFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SincronizacionStepInitial value)? initial,
    TResult Function(SincronizacionStepInProgress value)? inProgress,
    TResult Function(SincronizacionStepSuccess value)? success,
    TResult Function(SincronizacionStepFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SincronizacionStepInitial value)? initial,
    TResult Function(SincronizacionStepInProgress value)? inProgress,
    TResult Function(SincronizacionStepSuccess value)? success,
    TResult Function(SincronizacionStepFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SincronizacionStepStateCopyWith<SincronizacionStepState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SincronizacionStepStateCopyWith<$Res> {
  factory $SincronizacionStepStateCopyWith(SincronizacionStepState value,
          $Res Function(SincronizacionStepState) then) =
      _$SincronizacionStepStateCopyWithImpl<$Res>;
  $Res call({path.String log});
}

/// @nodoc
class _$SincronizacionStepStateCopyWithImpl<$Res>
    implements $SincronizacionStepStateCopyWith<$Res> {
  _$SincronizacionStepStateCopyWithImpl(this._value, this._then);

  final SincronizacionStepState _value;
  // ignore: unused_field
  final $Res Function(SincronizacionStepState) _then;

  @override
  $Res call({
    Object? log = freezed,
  }) {
    return _then(_value.copyWith(
      log: log == freezed
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as path.String,
    ));
  }
}

/// @nodoc
abstract class $SincronizacionStepInitialCopyWith<$Res>
    implements $SincronizacionStepStateCopyWith<$Res> {
  factory $SincronizacionStepInitialCopyWith(SincronizacionStepInitial value,
          $Res Function(SincronizacionStepInitial) then) =
      _$SincronizacionStepInitialCopyWithImpl<$Res>;
  @override
  $Res call({path.String log});
}

/// @nodoc
class _$SincronizacionStepInitialCopyWithImpl<$Res>
    extends _$SincronizacionStepStateCopyWithImpl<$Res>
    implements $SincronizacionStepInitialCopyWith<$Res> {
  _$SincronizacionStepInitialCopyWithImpl(SincronizacionStepInitial _value,
      $Res Function(SincronizacionStepInitial) _then)
      : super(_value, (v) => _then(v as SincronizacionStepInitial));

  @override
  SincronizacionStepInitial get _value =>
      super._value as SincronizacionStepInitial;

  @override
  $Res call({
    Object? log = freezed,
  }) {
    return _then(SincronizacionStepInitial(
      log == freezed
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as path.String,
    ));
  }
}

/// @nodoc

class _$SincronizacionStepInitial
    with DiagnosticableTreeMixin
    implements SincronizacionStepInitial {
  const _$SincronizacionStepInitial([this.log = ""]);

  @JsonKey(defaultValue: "")
  @override
  final path.String log;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionStepState.initial(log: $log)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionStepState.initial'))
      ..add(DiagnosticsProperty('log', log));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SincronizacionStepInitial &&
            (identical(other.log, log) ||
                const DeepCollectionEquality().equals(other.log, log)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(log);

  @JsonKey(ignore: true)
  @override
  $SincronizacionStepInitialCopyWith<SincronizacionStepInitial> get copyWith =>
      _$SincronizacionStepInitialCopyWithImpl<SincronizacionStepInitial>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(path.String log) initial,
    required TResult Function(path.int progress, path.String log) inProgress,
    required TResult Function(path.String log) success,
    required TResult Function(path.String log) failure,
  }) {
    return initial(log);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(path.String log)? initial,
    TResult Function(path.int progress, path.String log)? inProgress,
    TResult Function(path.String log)? success,
    TResult Function(path.String log)? failure,
  }) {
    return initial?.call(log);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(path.String log)? initial,
    TResult Function(path.int progress, path.String log)? inProgress,
    TResult Function(path.String log)? success,
    TResult Function(path.String log)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(log);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SincronizacionStepInitial value) initial,
    required TResult Function(SincronizacionStepInProgress value) inProgress,
    required TResult Function(SincronizacionStepSuccess value) success,
    required TResult Function(SincronizacionStepFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SincronizacionStepInitial value)? initial,
    TResult Function(SincronizacionStepInProgress value)? inProgress,
    TResult Function(SincronizacionStepSuccess value)? success,
    TResult Function(SincronizacionStepFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SincronizacionStepInitial value)? initial,
    TResult Function(SincronizacionStepInProgress value)? inProgress,
    TResult Function(SincronizacionStepSuccess value)? success,
    TResult Function(SincronizacionStepFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class SincronizacionStepInitial implements SincronizacionStepState {
  const factory SincronizacionStepInitial([path.String log]) =
      _$SincronizacionStepInitial;

  @override
  path.String get log => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $SincronizacionStepInitialCopyWith<SincronizacionStepInitial> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SincronizacionStepInProgressCopyWith<$Res>
    implements $SincronizacionStepStateCopyWith<$Res> {
  factory $SincronizacionStepInProgressCopyWith(
          SincronizacionStepInProgress value,
          $Res Function(SincronizacionStepInProgress) then) =
      _$SincronizacionStepInProgressCopyWithImpl<$Res>;
  @override
  $Res call({path.int progress, path.String log});
}

/// @nodoc
class _$SincronizacionStepInProgressCopyWithImpl<$Res>
    extends _$SincronizacionStepStateCopyWithImpl<$Res>
    implements $SincronizacionStepInProgressCopyWith<$Res> {
  _$SincronizacionStepInProgressCopyWithImpl(
      SincronizacionStepInProgress _value,
      $Res Function(SincronizacionStepInProgress) _then)
      : super(_value, (v) => _then(v as SincronizacionStepInProgress));

  @override
  SincronizacionStepInProgress get _value =>
      super._value as SincronizacionStepInProgress;

  @override
  $Res call({
    Object? progress = freezed,
    Object? log = freezed,
  }) {
    return _then(SincronizacionStepInProgress(
      progress == freezed
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as path.int,
      log == freezed
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as path.String,
    ));
  }
}

/// @nodoc

class _$SincronizacionStepInProgress
    with DiagnosticableTreeMixin
    implements SincronizacionStepInProgress {
  const _$SincronizacionStepInProgress(this.progress, [this.log = ""]);

  @override
  final path.int progress;
  @JsonKey(defaultValue: "")
  @override
  final path.String log;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionStepState.inProgress(progress: $progress, log: $log)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionStepState.inProgress'))
      ..add(DiagnosticsProperty('progress', progress))
      ..add(DiagnosticsProperty('log', log));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SincronizacionStepInProgress &&
            (identical(other.progress, progress) ||
                const DeepCollectionEquality()
                    .equals(other.progress, progress)) &&
            (identical(other.log, log) ||
                const DeepCollectionEquality().equals(other.log, log)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(progress) ^
      const DeepCollectionEquality().hash(log);

  @JsonKey(ignore: true)
  @override
  $SincronizacionStepInProgressCopyWith<SincronizacionStepInProgress>
      get copyWith => _$SincronizacionStepInProgressCopyWithImpl<
          SincronizacionStepInProgress>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(path.String log) initial,
    required TResult Function(path.int progress, path.String log) inProgress,
    required TResult Function(path.String log) success,
    required TResult Function(path.String log) failure,
  }) {
    return inProgress(progress, log);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(path.String log)? initial,
    TResult Function(path.int progress, path.String log)? inProgress,
    TResult Function(path.String log)? success,
    TResult Function(path.String log)? failure,
  }) {
    return inProgress?.call(progress, log);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(path.String log)? initial,
    TResult Function(path.int progress, path.String log)? inProgress,
    TResult Function(path.String log)? success,
    TResult Function(path.String log)? failure,
    required TResult orElse(),
  }) {
    if (inProgress != null) {
      return inProgress(progress, log);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SincronizacionStepInitial value) initial,
    required TResult Function(SincronizacionStepInProgress value) inProgress,
    required TResult Function(SincronizacionStepSuccess value) success,
    required TResult Function(SincronizacionStepFailure value) failure,
  }) {
    return inProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SincronizacionStepInitial value)? initial,
    TResult Function(SincronizacionStepInProgress value)? inProgress,
    TResult Function(SincronizacionStepSuccess value)? success,
    TResult Function(SincronizacionStepFailure value)? failure,
  }) {
    return inProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SincronizacionStepInitial value)? initial,
    TResult Function(SincronizacionStepInProgress value)? inProgress,
    TResult Function(SincronizacionStepSuccess value)? success,
    TResult Function(SincronizacionStepFailure value)? failure,
    required TResult orElse(),
  }) {
    if (inProgress != null) {
      return inProgress(this);
    }
    return orElse();
  }
}

abstract class SincronizacionStepInProgress implements SincronizacionStepState {
  const factory SincronizacionStepInProgress(path.int progress,
      [path.String log]) = _$SincronizacionStepInProgress;

  path.int get progress => throw _privateConstructorUsedError;
  @override
  path.String get log => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $SincronizacionStepInProgressCopyWith<SincronizacionStepInProgress>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SincronizacionStepSuccessCopyWith<$Res>
    implements $SincronizacionStepStateCopyWith<$Res> {
  factory $SincronizacionStepSuccessCopyWith(SincronizacionStepSuccess value,
          $Res Function(SincronizacionStepSuccess) then) =
      _$SincronizacionStepSuccessCopyWithImpl<$Res>;
  @override
  $Res call({path.String log});
}

/// @nodoc
class _$SincronizacionStepSuccessCopyWithImpl<$Res>
    extends _$SincronizacionStepStateCopyWithImpl<$Res>
    implements $SincronizacionStepSuccessCopyWith<$Res> {
  _$SincronizacionStepSuccessCopyWithImpl(SincronizacionStepSuccess _value,
      $Res Function(SincronizacionStepSuccess) _then)
      : super(_value, (v) => _then(v as SincronizacionStepSuccess));

  @override
  SincronizacionStepSuccess get _value =>
      super._value as SincronizacionStepSuccess;

  @override
  $Res call({
    Object? log = freezed,
  }) {
    return _then(SincronizacionStepSuccess(
      log == freezed
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as path.String,
    ));
  }
}

/// @nodoc

class _$SincronizacionStepSuccess
    with DiagnosticableTreeMixin
    implements SincronizacionStepSuccess {
  const _$SincronizacionStepSuccess([this.log = ""]);

  @JsonKey(defaultValue: "")
  @override
  final path.String log;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionStepState.success(log: $log)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionStepState.success'))
      ..add(DiagnosticsProperty('log', log));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SincronizacionStepSuccess &&
            (identical(other.log, log) ||
                const DeepCollectionEquality().equals(other.log, log)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(log);

  @JsonKey(ignore: true)
  @override
  $SincronizacionStepSuccessCopyWith<SincronizacionStepSuccess> get copyWith =>
      _$SincronizacionStepSuccessCopyWithImpl<SincronizacionStepSuccess>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(path.String log) initial,
    required TResult Function(path.int progress, path.String log) inProgress,
    required TResult Function(path.String log) success,
    required TResult Function(path.String log) failure,
  }) {
    return success(log);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(path.String log)? initial,
    TResult Function(path.int progress, path.String log)? inProgress,
    TResult Function(path.String log)? success,
    TResult Function(path.String log)? failure,
  }) {
    return success?.call(log);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(path.String log)? initial,
    TResult Function(path.int progress, path.String log)? inProgress,
    TResult Function(path.String log)? success,
    TResult Function(path.String log)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(log);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SincronizacionStepInitial value) initial,
    required TResult Function(SincronizacionStepInProgress value) inProgress,
    required TResult Function(SincronizacionStepSuccess value) success,
    required TResult Function(SincronizacionStepFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SincronizacionStepInitial value)? initial,
    TResult Function(SincronizacionStepInProgress value)? inProgress,
    TResult Function(SincronizacionStepSuccess value)? success,
    TResult Function(SincronizacionStepFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SincronizacionStepInitial value)? initial,
    TResult Function(SincronizacionStepInProgress value)? inProgress,
    TResult Function(SincronizacionStepSuccess value)? success,
    TResult Function(SincronizacionStepFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SincronizacionStepSuccess implements SincronizacionStepState {
  const factory SincronizacionStepSuccess([path.String log]) =
      _$SincronizacionStepSuccess;

  @override
  path.String get log => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $SincronizacionStepSuccessCopyWith<SincronizacionStepSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SincronizacionStepFailureCopyWith<$Res>
    implements $SincronizacionStepStateCopyWith<$Res> {
  factory $SincronizacionStepFailureCopyWith(SincronizacionStepFailure value,
          $Res Function(SincronizacionStepFailure) then) =
      _$SincronizacionStepFailureCopyWithImpl<$Res>;
  @override
  $Res call({path.String log});
}

/// @nodoc
class _$SincronizacionStepFailureCopyWithImpl<$Res>
    extends _$SincronizacionStepStateCopyWithImpl<$Res>
    implements $SincronizacionStepFailureCopyWith<$Res> {
  _$SincronizacionStepFailureCopyWithImpl(SincronizacionStepFailure _value,
      $Res Function(SincronizacionStepFailure) _then)
      : super(_value, (v) => _then(v as SincronizacionStepFailure));

  @override
  SincronizacionStepFailure get _value =>
      super._value as SincronizacionStepFailure;

  @override
  $Res call({
    Object? log = freezed,
  }) {
    return _then(SincronizacionStepFailure(
      log == freezed
          ? _value.log
          : log // ignore: cast_nullable_to_non_nullable
              as path.String,
    ));
  }
}

/// @nodoc

class _$SincronizacionStepFailure
    with DiagnosticableTreeMixin
    implements SincronizacionStepFailure {
  const _$SincronizacionStepFailure([this.log = ""]);

  @JsonKey(defaultValue: "")
  @override
  final path.String log;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionStepState.failure(log: $log)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionStepState.failure'))
      ..add(DiagnosticsProperty('log', log));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is SincronizacionStepFailure &&
            (identical(other.log, log) ||
                const DeepCollectionEquality().equals(other.log, log)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(log);

  @JsonKey(ignore: true)
  @override
  $SincronizacionStepFailureCopyWith<SincronizacionStepFailure> get copyWith =>
      _$SincronizacionStepFailureCopyWithImpl<SincronizacionStepFailure>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(path.String log) initial,
    required TResult Function(path.int progress, path.String log) inProgress,
    required TResult Function(path.String log) success,
    required TResult Function(path.String log) failure,
  }) {
    return failure(log);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(path.String log)? initial,
    TResult Function(path.int progress, path.String log)? inProgress,
    TResult Function(path.String log)? success,
    TResult Function(path.String log)? failure,
  }) {
    return failure?.call(log);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(path.String log)? initial,
    TResult Function(path.int progress, path.String log)? inProgress,
    TResult Function(path.String log)? success,
    TResult Function(path.String log)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(log);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SincronizacionStepInitial value) initial,
    required TResult Function(SincronizacionStepInProgress value) inProgress,
    required TResult Function(SincronizacionStepSuccess value) success,
    required TResult Function(SincronizacionStepFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SincronizacionStepInitial value)? initial,
    TResult Function(SincronizacionStepInProgress value)? inProgress,
    TResult Function(SincronizacionStepSuccess value)? success,
    TResult Function(SincronizacionStepFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SincronizacionStepInitial value)? initial,
    TResult Function(SincronizacionStepInProgress value)? inProgress,
    TResult Function(SincronizacionStepSuccess value)? success,
    TResult Function(SincronizacionStepFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class SincronizacionStepFailure implements SincronizacionStepState {
  const factory SincronizacionStepFailure([path.String log]) =
      _$SincronizacionStepFailure;

  @override
  path.String get log => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $SincronizacionStepFailureCopyWith<SincronizacionStepFailure> get copyWith =>
      throw _privateConstructorUsedError;
}
