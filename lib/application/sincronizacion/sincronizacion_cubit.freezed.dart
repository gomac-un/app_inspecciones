// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'sincronizacion_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$TaskTearOff {
  const _$TaskTearOff();

// ignore: unused_element
  _Task call({String id, DownloadTaskStatus status, int progress}) {
    return _Task(
      id: id,
      status: status,
      progress: progress,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $Task = _$TaskTearOff();

/// @nodoc
mixin _$Task {
  String get id;
  DownloadTaskStatus get status;
  int get progress;

  @JsonKey(ignore: true)
  $TaskCopyWith<Task> get copyWith;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res>;
  $Res call({String id, DownloadTaskStatus status, int progress});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res> implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  final Task _value;
  // ignore: unused_field
  final $Res Function(Task) _then;

  @override
  $Res call({
    Object id = freezed,
    Object status = freezed,
    Object progress = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      status: status == freezed ? _value.status : status as DownloadTaskStatus,
      progress: progress == freezed ? _value.progress : progress as int,
    ));
  }
}

/// @nodoc
abstract class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) then) =
      __$TaskCopyWithImpl<$Res>;
  @override
  $Res call({String id, DownloadTaskStatus status, int progress});
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
    Object id = freezed,
    Object status = freezed,
    Object progress = freezed,
  }) {
    return _then(_Task(
      id: id == freezed ? _value.id : id as String,
      status: status == freezed ? _value.status : status as DownloadTaskStatus,
      progress: progress == freezed ? _value.progress : progress as int,
    ));
  }
}

/// @nodoc
class _$_Task with DiagnosticableTreeMixin implements _Task {
  _$_Task({this.id, this.status, this.progress});

  @override
  final String id;
  @override
  final DownloadTaskStatus status;
  @override
  final int progress;

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
  factory _Task({String id, DownloadTaskStatus status, int progress}) = _$_Task;

  @override
  String get id;
  @override
  DownloadTaskStatus get status;
  @override
  int get progress;
  @override
  @JsonKey(ignore: true)
  _$TaskCopyWith<_Task> get copyWith;
}

/// @nodoc
class _$SincronizacionStateTearOff {
  const _$SincronizacionStateTearOff();

// ignore: unused_element
  _SincronizacionState call({bool cargado = false, Task task, String info}) {
    return _SincronizacionState(
      cargado: cargado,
      task: task,
      info: info,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $SincronizacionState = _$SincronizacionStateTearOff();

/// @nodoc
mixin _$SincronizacionState {
  bool get cargado;
  Task get task;
  String get info;

  @JsonKey(ignore: true)
  $SincronizacionStateCopyWith<SincronizacionState> get copyWith;
}

/// @nodoc
abstract class $SincronizacionStateCopyWith<$Res> {
  factory $SincronizacionStateCopyWith(
          SincronizacionState value, $Res Function(SincronizacionState) then) =
      _$SincronizacionStateCopyWithImpl<$Res>;
  $Res call({bool cargado, Task task, String info});

  $TaskCopyWith<$Res> get task;
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
    Object cargado = freezed,
    Object task = freezed,
    Object info = freezed,
  }) {
    return _then(_value.copyWith(
      cargado: cargado == freezed ? _value.cargado : cargado as bool,
      task: task == freezed ? _value.task : task as Task,
      info: info == freezed ? _value.info : info as String,
    ));
  }

  @override
  $TaskCopyWith<$Res> get task {
    if (_value.task == null) {
      return null;
    }
    return $TaskCopyWith<$Res>(_value.task, (value) {
      return _then(_value.copyWith(task: value));
    });
  }
}

/// @nodoc
abstract class _$SincronizacionStateCopyWith<$Res>
    implements $SincronizacionStateCopyWith<$Res> {
  factory _$SincronizacionStateCopyWith(_SincronizacionState value,
          $Res Function(_SincronizacionState) then) =
      __$SincronizacionStateCopyWithImpl<$Res>;
  @override
  $Res call({bool cargado, Task task, String info});

  @override
  $TaskCopyWith<$Res> get task;
}

/// @nodoc
class __$SincronizacionStateCopyWithImpl<$Res>
    extends _$SincronizacionStateCopyWithImpl<$Res>
    implements _$SincronizacionStateCopyWith<$Res> {
  __$SincronizacionStateCopyWithImpl(
      _SincronizacionState _value, $Res Function(_SincronizacionState) _then)
      : super(_value, (v) => _then(v as _SincronizacionState));

  @override
  _SincronizacionState get _value => super._value as _SincronizacionState;

  @override
  $Res call({
    Object cargado = freezed,
    Object task = freezed,
    Object info = freezed,
  }) {
    return _then(_SincronizacionState(
      cargado: cargado == freezed ? _value.cargado : cargado as bool,
      task: task == freezed ? _value.task : task as Task,
      info: info == freezed ? _value.info : info as String,
    ));
  }
}

/// @nodoc
class _$_SincronizacionState
    with DiagnosticableTreeMixin
    implements _SincronizacionState {
  _$_SincronizacionState({this.cargado = false, this.task, this.info})
      : assert(cargado != null);

  @JsonKey(defaultValue: false)
  @override
  final bool cargado;
  @override
  final Task task;
  @override
  final String info;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionState(cargado: $cargado, task: $task, info: $info)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionState'))
      ..add(DiagnosticsProperty('cargado', cargado))
      ..add(DiagnosticsProperty('task', task))
      ..add(DiagnosticsProperty('info', info));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SincronizacionState &&
            (identical(other.cargado, cargado) ||
                const DeepCollectionEquality()
                    .equals(other.cargado, cargado)) &&
            (identical(other.task, task) ||
                const DeepCollectionEquality().equals(other.task, task)) &&
            (identical(other.info, info) ||
                const DeepCollectionEquality().equals(other.info, info)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(cargado) ^
      const DeepCollectionEquality().hash(task) ^
      const DeepCollectionEquality().hash(info);

  @JsonKey(ignore: true)
  @override
  _$SincronizacionStateCopyWith<_SincronizacionState> get copyWith =>
      __$SincronizacionStateCopyWithImpl<_SincronizacionState>(
          this, _$identity);
}

abstract class _SincronizacionState implements SincronizacionState {
  factory _SincronizacionState({bool cargado, Task task, String info}) =
      _$_SincronizacionState;

  @override
  bool get cargado;
  @override
  Task get task;
  @override
  String get info;
  @override
  @JsonKey(ignore: true)
  _$SincronizacionStateCopyWith<_SincronizacionState> get copyWith;
}
