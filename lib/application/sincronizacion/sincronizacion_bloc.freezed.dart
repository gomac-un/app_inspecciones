// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'sincronizacion_bloc.dart';

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
  _$TaskCopyWith<_Task> get copyWith;
}

/// @nodoc
class _$SincronizacionEventTearOff {
  const _$SincronizacionEventTearOff();

// ignore: unused_element
  _Inicializar inicializar() {
    return const _Inicializar();
  }

// ignore: unused_element
  _DescargarServer descargarServer() {
    return const _DescargarServer();
  }

// ignore: unused_element
  _InstalarBD instalarBD() {
    return const _InstalarBD();
  }
}

/// @nodoc
// ignore: unused_element
const $SincronizacionEvent = _$SincronizacionEventTearOff();

/// @nodoc
mixin _$SincronizacionEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult inicializar(),
    @required TResult descargarServer(),
    @required TResult instalarBD(),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult inicializar(),
    TResult descargarServer(),
    TResult instalarBD(),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult inicializar(_Inicializar value),
    @required TResult descargarServer(_DescargarServer value),
    @required TResult instalarBD(_InstalarBD value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult inicializar(_Inicializar value),
    TResult descargarServer(_DescargarServer value),
    TResult instalarBD(_InstalarBD value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $SincronizacionEventCopyWith<$Res> {
  factory $SincronizacionEventCopyWith(
          SincronizacionEvent value, $Res Function(SincronizacionEvent) then) =
      _$SincronizacionEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$SincronizacionEventCopyWithImpl<$Res>
    implements $SincronizacionEventCopyWith<$Res> {
  _$SincronizacionEventCopyWithImpl(this._value, this._then);

  final SincronizacionEvent _value;
  // ignore: unused_field
  final $Res Function(SincronizacionEvent) _then;
}

/// @nodoc
abstract class _$InicializarCopyWith<$Res> {
  factory _$InicializarCopyWith(
          _Inicializar value, $Res Function(_Inicializar) then) =
      __$InicializarCopyWithImpl<$Res>;
}

/// @nodoc
class __$InicializarCopyWithImpl<$Res>
    extends _$SincronizacionEventCopyWithImpl<$Res>
    implements _$InicializarCopyWith<$Res> {
  __$InicializarCopyWithImpl(
      _Inicializar _value, $Res Function(_Inicializar) _then)
      : super(_value, (v) => _then(v as _Inicializar));

  @override
  _Inicializar get _value => super._value as _Inicializar;
}

/// @nodoc
class _$_Inicializar with DiagnosticableTreeMixin implements _Inicializar {
  const _$_Inicializar();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionEvent.inicializar()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionEvent.inicializar'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Inicializar);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult inicializar(),
    @required TResult descargarServer(),
    @required TResult instalarBD(),
  }) {
    assert(inicializar != null);
    assert(descargarServer != null);
    assert(instalarBD != null);
    return inicializar();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult inicializar(),
    TResult descargarServer(),
    TResult instalarBD(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (inicializar != null) {
      return inicializar();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult inicializar(_Inicializar value),
    @required TResult descargarServer(_DescargarServer value),
    @required TResult instalarBD(_InstalarBD value),
  }) {
    assert(inicializar != null);
    assert(descargarServer != null);
    assert(instalarBD != null);
    return inicializar(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult inicializar(_Inicializar value),
    TResult descargarServer(_DescargarServer value),
    TResult instalarBD(_InstalarBD value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (inicializar != null) {
      return inicializar(this);
    }
    return orElse();
  }
}

abstract class _Inicializar implements SincronizacionEvent {
  const factory _Inicializar() = _$_Inicializar;
}

/// @nodoc
abstract class _$DescargarServerCopyWith<$Res> {
  factory _$DescargarServerCopyWith(
          _DescargarServer value, $Res Function(_DescargarServer) then) =
      __$DescargarServerCopyWithImpl<$Res>;
}

/// @nodoc
class __$DescargarServerCopyWithImpl<$Res>
    extends _$SincronizacionEventCopyWithImpl<$Res>
    implements _$DescargarServerCopyWith<$Res> {
  __$DescargarServerCopyWithImpl(
      _DescargarServer _value, $Res Function(_DescargarServer) _then)
      : super(_value, (v) => _then(v as _DescargarServer));

  @override
  _DescargarServer get _value => super._value as _DescargarServer;
}

/// @nodoc
class _$_DescargarServer
    with DiagnosticableTreeMixin
    implements _DescargarServer {
  const _$_DescargarServer();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionEvent.descargarServer()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionEvent.descargarServer'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _DescargarServer);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult inicializar(),
    @required TResult descargarServer(),
    @required TResult instalarBD(),
  }) {
    assert(inicializar != null);
    assert(descargarServer != null);
    assert(instalarBD != null);
    return descargarServer();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult inicializar(),
    TResult descargarServer(),
    TResult instalarBD(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (descargarServer != null) {
      return descargarServer();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult inicializar(_Inicializar value),
    @required TResult descargarServer(_DescargarServer value),
    @required TResult instalarBD(_InstalarBD value),
  }) {
    assert(inicializar != null);
    assert(descargarServer != null);
    assert(instalarBD != null);
    return descargarServer(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult inicializar(_Inicializar value),
    TResult descargarServer(_DescargarServer value),
    TResult instalarBD(_InstalarBD value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (descargarServer != null) {
      return descargarServer(this);
    }
    return orElse();
  }
}

abstract class _DescargarServer implements SincronizacionEvent {
  const factory _DescargarServer() = _$_DescargarServer;
}

/// @nodoc
abstract class _$InstalarBDCopyWith<$Res> {
  factory _$InstalarBDCopyWith(
          _InstalarBD value, $Res Function(_InstalarBD) then) =
      __$InstalarBDCopyWithImpl<$Res>;
}

/// @nodoc
class __$InstalarBDCopyWithImpl<$Res>
    extends _$SincronizacionEventCopyWithImpl<$Res>
    implements _$InstalarBDCopyWith<$Res> {
  __$InstalarBDCopyWithImpl(
      _InstalarBD _value, $Res Function(_InstalarBD) _then)
      : super(_value, (v) => _then(v as _InstalarBD));

  @override
  _InstalarBD get _value => super._value as _InstalarBD;
}

/// @nodoc
class _$_InstalarBD with DiagnosticableTreeMixin implements _InstalarBD {
  const _$_InstalarBD();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionEvent.instalarBD()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionEvent.instalarBD'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _InstalarBD);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult inicializar(),
    @required TResult descargarServer(),
    @required TResult instalarBD(),
  }) {
    assert(inicializar != null);
    assert(descargarServer != null);
    assert(instalarBD != null);
    return instalarBD();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult inicializar(),
    TResult descargarServer(),
    TResult instalarBD(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (instalarBD != null) {
      return instalarBD();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult inicializar(_Inicializar value),
    @required TResult descargarServer(_DescargarServer value),
    @required TResult instalarBD(_InstalarBD value),
  }) {
    assert(inicializar != null);
    assert(descargarServer != null);
    assert(instalarBD != null);
    return instalarBD(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult inicializar(_Inicializar value),
    TResult descargarServer(_DescargarServer value),
    TResult instalarBD(_InstalarBD value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (instalarBD != null) {
      return instalarBD(this);
    }
    return orElse();
  }
}

abstract class _InstalarBD implements SincronizacionEvent {
  const factory _InstalarBD() = _$_InstalarBD;
}

/// @nodoc
class _$SincronizacionStateTearOff {
  const _$SincronizacionStateTearOff();

// ignore: unused_element
  Cargando cargando() {
    return const Cargando();
  }

// ignore: unused_element
  Cargado cargado(DateTime ultimaActualizacion) {
    return Cargado(
      ultimaActualizacion,
    );
  }

// ignore: unused_element
  DescargandoServer descargandoServer(DateTime ultimaActualizacion, Task task) {
    return DescargandoServer(
      ultimaActualizacion,
      task,
    );
  }

// ignore: unused_element
  InstalandoBD instalandoBD() {
    return const InstalandoBD();
  }
}

/// @nodoc
// ignore: unused_element
const $SincronizacionState = _$SincronizacionStateTearOff();

/// @nodoc
mixin _$SincronizacionState {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult cargando(),
    @required TResult cargado(DateTime ultimaActualizacion),
    @required
        TResult descargandoServer(DateTime ultimaActualizacion, Task task),
    @required TResult instalandoBD(),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult cargando(),
    TResult cargado(DateTime ultimaActualizacion),
    TResult descargandoServer(DateTime ultimaActualizacion, Task task),
    TResult instalandoBD(),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult cargando(Cargando value),
    @required TResult cargado(Cargado value),
    @required TResult descargandoServer(DescargandoServer value),
    @required TResult instalandoBD(InstalandoBD value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult cargando(Cargando value),
    TResult cargado(Cargado value),
    TResult descargandoServer(DescargandoServer value),
    TResult instalandoBD(InstalandoBD value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $SincronizacionStateCopyWith<$Res> {
  factory $SincronizacionStateCopyWith(
          SincronizacionState value, $Res Function(SincronizacionState) then) =
      _$SincronizacionStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$SincronizacionStateCopyWithImpl<$Res>
    implements $SincronizacionStateCopyWith<$Res> {
  _$SincronizacionStateCopyWithImpl(this._value, this._then);

  final SincronizacionState _value;
  // ignore: unused_field
  final $Res Function(SincronizacionState) _then;
}

/// @nodoc
abstract class $CargandoCopyWith<$Res> {
  factory $CargandoCopyWith(Cargando value, $Res Function(Cargando) then) =
      _$CargandoCopyWithImpl<$Res>;
}

/// @nodoc
class _$CargandoCopyWithImpl<$Res>
    extends _$SincronizacionStateCopyWithImpl<$Res>
    implements $CargandoCopyWith<$Res> {
  _$CargandoCopyWithImpl(Cargando _value, $Res Function(Cargando) _then)
      : super(_value, (v) => _then(v as Cargando));

  @override
  Cargando get _value => super._value as Cargando;
}

/// @nodoc
class _$Cargando with DiagnosticableTreeMixin implements Cargando {
  const _$Cargando();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionState.cargando()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionState.cargando'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Cargando);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult cargando(),
    @required TResult cargado(DateTime ultimaActualizacion),
    @required
        TResult descargandoServer(DateTime ultimaActualizacion, Task task),
    @required TResult instalandoBD(),
  }) {
    assert(cargando != null);
    assert(cargado != null);
    assert(descargandoServer != null);
    assert(instalandoBD != null);
    return cargando();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult cargando(),
    TResult cargado(DateTime ultimaActualizacion),
    TResult descargandoServer(DateTime ultimaActualizacion, Task task),
    TResult instalandoBD(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (cargando != null) {
      return cargando();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult cargando(Cargando value),
    @required TResult cargado(Cargado value),
    @required TResult descargandoServer(DescargandoServer value),
    @required TResult instalandoBD(InstalandoBD value),
  }) {
    assert(cargando != null);
    assert(cargado != null);
    assert(descargandoServer != null);
    assert(instalandoBD != null);
    return cargando(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult cargando(Cargando value),
    TResult cargado(Cargado value),
    TResult descargandoServer(DescargandoServer value),
    TResult instalandoBD(InstalandoBD value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (cargando != null) {
      return cargando(this);
    }
    return orElse();
  }
}

abstract class Cargando implements SincronizacionState {
  const factory Cargando() = _$Cargando;
}

/// @nodoc
abstract class $CargadoCopyWith<$Res> {
  factory $CargadoCopyWith(Cargado value, $Res Function(Cargado) then) =
      _$CargadoCopyWithImpl<$Res>;
  $Res call({DateTime ultimaActualizacion});
}

/// @nodoc
class _$CargadoCopyWithImpl<$Res>
    extends _$SincronizacionStateCopyWithImpl<$Res>
    implements $CargadoCopyWith<$Res> {
  _$CargadoCopyWithImpl(Cargado _value, $Res Function(Cargado) _then)
      : super(_value, (v) => _then(v as Cargado));

  @override
  Cargado get _value => super._value as Cargado;

  @override
  $Res call({
    Object ultimaActualizacion = freezed,
  }) {
    return _then(Cargado(
      ultimaActualizacion == freezed
          ? _value.ultimaActualizacion
          : ultimaActualizacion as DateTime,
    ));
  }
}

/// @nodoc
class _$Cargado with DiagnosticableTreeMixin implements Cargado {
  const _$Cargado(this.ultimaActualizacion)
      : assert(ultimaActualizacion != null);

  @override
  final DateTime ultimaActualizacion;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionState.cargado(ultimaActualizacion: $ultimaActualizacion)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionState.cargado'))
      ..add(DiagnosticsProperty('ultimaActualizacion', ultimaActualizacion));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Cargado &&
            (identical(other.ultimaActualizacion, ultimaActualizacion) ||
                const DeepCollectionEquality()
                    .equals(other.ultimaActualizacion, ultimaActualizacion)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(ultimaActualizacion);

  @override
  $CargadoCopyWith<Cargado> get copyWith =>
      _$CargadoCopyWithImpl<Cargado>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult cargando(),
    @required TResult cargado(DateTime ultimaActualizacion),
    @required
        TResult descargandoServer(DateTime ultimaActualizacion, Task task),
    @required TResult instalandoBD(),
  }) {
    assert(cargando != null);
    assert(cargado != null);
    assert(descargandoServer != null);
    assert(instalandoBD != null);
    return cargado(ultimaActualizacion);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult cargando(),
    TResult cargado(DateTime ultimaActualizacion),
    TResult descargandoServer(DateTime ultimaActualizacion, Task task),
    TResult instalandoBD(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (cargado != null) {
      return cargado(ultimaActualizacion);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult cargando(Cargando value),
    @required TResult cargado(Cargado value),
    @required TResult descargandoServer(DescargandoServer value),
    @required TResult instalandoBD(InstalandoBD value),
  }) {
    assert(cargando != null);
    assert(cargado != null);
    assert(descargandoServer != null);
    assert(instalandoBD != null);
    return cargado(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult cargando(Cargando value),
    TResult cargado(Cargado value),
    TResult descargandoServer(DescargandoServer value),
    TResult instalandoBD(InstalandoBD value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (cargado != null) {
      return cargado(this);
    }
    return orElse();
  }
}

abstract class Cargado implements SincronizacionState {
  const factory Cargado(DateTime ultimaActualizacion) = _$Cargado;

  DateTime get ultimaActualizacion;
  $CargadoCopyWith<Cargado> get copyWith;
}

/// @nodoc
abstract class $DescargandoServerCopyWith<$Res> {
  factory $DescargandoServerCopyWith(
          DescargandoServer value, $Res Function(DescargandoServer) then) =
      _$DescargandoServerCopyWithImpl<$Res>;
  $Res call({DateTime ultimaActualizacion, Task task});

  $TaskCopyWith<$Res> get task;
}

/// @nodoc
class _$DescargandoServerCopyWithImpl<$Res>
    extends _$SincronizacionStateCopyWithImpl<$Res>
    implements $DescargandoServerCopyWith<$Res> {
  _$DescargandoServerCopyWithImpl(
      DescargandoServer _value, $Res Function(DescargandoServer) _then)
      : super(_value, (v) => _then(v as DescargandoServer));

  @override
  DescargandoServer get _value => super._value as DescargandoServer;

  @override
  $Res call({
    Object ultimaActualizacion = freezed,
    Object task = freezed,
  }) {
    return _then(DescargandoServer(
      ultimaActualizacion == freezed
          ? _value.ultimaActualizacion
          : ultimaActualizacion as DateTime,
      task == freezed ? _value.task : task as Task,
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
class _$DescargandoServer
    with DiagnosticableTreeMixin
    implements DescargandoServer {
  const _$DescargandoServer(this.ultimaActualizacion, this.task)
      : assert(ultimaActualizacion != null),
        assert(task != null);

  @override
  final DateTime ultimaActualizacion;
  @override
  final Task task;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionState.descargandoServer(ultimaActualizacion: $ultimaActualizacion, task: $task)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
          DiagnosticsProperty('type', 'SincronizacionState.descargandoServer'))
      ..add(DiagnosticsProperty('ultimaActualizacion', ultimaActualizacion))
      ..add(DiagnosticsProperty('task', task));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is DescargandoServer &&
            (identical(other.ultimaActualizacion, ultimaActualizacion) ||
                const DeepCollectionEquality()
                    .equals(other.ultimaActualizacion, ultimaActualizacion)) &&
            (identical(other.task, task) ||
                const DeepCollectionEquality().equals(other.task, task)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(ultimaActualizacion) ^
      const DeepCollectionEquality().hash(task);

  @override
  $DescargandoServerCopyWith<DescargandoServer> get copyWith =>
      _$DescargandoServerCopyWithImpl<DescargandoServer>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult cargando(),
    @required TResult cargado(DateTime ultimaActualizacion),
    @required
        TResult descargandoServer(DateTime ultimaActualizacion, Task task),
    @required TResult instalandoBD(),
  }) {
    assert(cargando != null);
    assert(cargado != null);
    assert(descargandoServer != null);
    assert(instalandoBD != null);
    return descargandoServer(ultimaActualizacion, task);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult cargando(),
    TResult cargado(DateTime ultimaActualizacion),
    TResult descargandoServer(DateTime ultimaActualizacion, Task task),
    TResult instalandoBD(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (descargandoServer != null) {
      return descargandoServer(ultimaActualizacion, task);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult cargando(Cargando value),
    @required TResult cargado(Cargado value),
    @required TResult descargandoServer(DescargandoServer value),
    @required TResult instalandoBD(InstalandoBD value),
  }) {
    assert(cargando != null);
    assert(cargado != null);
    assert(descargandoServer != null);
    assert(instalandoBD != null);
    return descargandoServer(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult cargando(Cargando value),
    TResult cargado(Cargado value),
    TResult descargandoServer(DescargandoServer value),
    TResult instalandoBD(InstalandoBD value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (descargandoServer != null) {
      return descargandoServer(this);
    }
    return orElse();
  }
}

abstract class DescargandoServer implements SincronizacionState {
  const factory DescargandoServer(DateTime ultimaActualizacion, Task task) =
      _$DescargandoServer;

  DateTime get ultimaActualizacion;
  Task get task;
  $DescargandoServerCopyWith<DescargandoServer> get copyWith;
}

/// @nodoc
abstract class $InstalandoBDCopyWith<$Res> {
  factory $InstalandoBDCopyWith(
          InstalandoBD value, $Res Function(InstalandoBD) then) =
      _$InstalandoBDCopyWithImpl<$Res>;
}

/// @nodoc
class _$InstalandoBDCopyWithImpl<$Res>
    extends _$SincronizacionStateCopyWithImpl<$Res>
    implements $InstalandoBDCopyWith<$Res> {
  _$InstalandoBDCopyWithImpl(
      InstalandoBD _value, $Res Function(InstalandoBD) _then)
      : super(_value, (v) => _then(v as InstalandoBD));

  @override
  InstalandoBD get _value => super._value as InstalandoBD;
}

/// @nodoc
class _$InstalandoBD with DiagnosticableTreeMixin implements InstalandoBD {
  const _$InstalandoBD();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SincronizacionState.instalandoBD()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SincronizacionState.instalandoBD'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is InstalandoBD);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult cargando(),
    @required TResult cargado(DateTime ultimaActualizacion),
    @required
        TResult descargandoServer(DateTime ultimaActualizacion, Task task),
    @required TResult instalandoBD(),
  }) {
    assert(cargando != null);
    assert(cargado != null);
    assert(descargandoServer != null);
    assert(instalandoBD != null);
    return instalandoBD();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult cargando(),
    TResult cargado(DateTime ultimaActualizacion),
    TResult descargandoServer(DateTime ultimaActualizacion, Task task),
    TResult instalandoBD(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (instalandoBD != null) {
      return instalandoBD();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult cargando(Cargando value),
    @required TResult cargado(Cargado value),
    @required TResult descargandoServer(DescargandoServer value),
    @required TResult instalandoBD(InstalandoBD value),
  }) {
    assert(cargando != null);
    assert(cargado != null);
    assert(descargandoServer != null);
    assert(instalandoBD != null);
    return instalandoBD(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult cargando(Cargando value),
    TResult cargado(Cargado value),
    TResult descargandoServer(DescargandoServer value),
    TResult instalandoBD(InstalandoBD value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (instalandoBD != null) {
      return instalandoBD(this);
    }
    return orElse();
  }
}

abstract class InstalandoBD implements SincronizacionState {
  const factory InstalandoBD() = _$InstalandoBD;
}
