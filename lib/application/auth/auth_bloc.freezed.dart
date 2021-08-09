// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AuthEventTearOff {
  const _$AuthEventTearOff();

  StartingApp startingApp() {
    return const StartingApp();
  }

  LoggingIn loggingIn({required UserLogin usuario}) {
    return LoggingIn(
      usuario: usuario,
    );
  }

  LoggingOut loggingOut() {
    return const LoggingOut();
  }
}

/// @nodoc
const $AuthEvent = _$AuthEventTearOff();

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startingApp,
    required TResult Function(UserLogin usuario) loggingIn,
    required TResult Function() loggingOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? startingApp,
    TResult Function(UserLogin usuario)? loggingIn,
    TResult Function()? loggingOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startingApp,
    TResult Function(UserLogin usuario)? loggingIn,
    TResult Function()? loggingOut,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StartingApp value) startingApp,
    required TResult Function(LoggingIn value) loggingIn,
    required TResult Function(LoggingOut value) loggingOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StartingApp value)? startingApp,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StartingApp value)? startingApp,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res> implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  final AuthEvent _value;
  // ignore: unused_field
  final $Res Function(AuthEvent) _then;
}

/// @nodoc
abstract class $StartingAppCopyWith<$Res> {
  factory $StartingAppCopyWith(
          StartingApp value, $Res Function(StartingApp) then) =
      _$StartingAppCopyWithImpl<$Res>;
}

/// @nodoc
class _$StartingAppCopyWithImpl<$Res> extends _$AuthEventCopyWithImpl<$Res>
    implements $StartingAppCopyWith<$Res> {
  _$StartingAppCopyWithImpl(
      StartingApp _value, $Res Function(StartingApp) _then)
      : super(_value, (v) => _then(v as StartingApp));

  @override
  StartingApp get _value => super._value as StartingApp;
}

/// @nodoc

class _$StartingApp implements StartingApp {
  const _$StartingApp();

  @override
  String toString() {
    return 'AuthEvent.startingApp()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is StartingApp);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startingApp,
    required TResult Function(UserLogin usuario) loggingIn,
    required TResult Function() loggingOut,
  }) {
    return startingApp();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? startingApp,
    TResult Function(UserLogin usuario)? loggingIn,
    TResult Function()? loggingOut,
  }) {
    return startingApp?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startingApp,
    TResult Function(UserLogin usuario)? loggingIn,
    TResult Function()? loggingOut,
    required TResult orElse(),
  }) {
    if (startingApp != null) {
      return startingApp();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StartingApp value) startingApp,
    required TResult Function(LoggingIn value) loggingIn,
    required TResult Function(LoggingOut value) loggingOut,
  }) {
    return startingApp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StartingApp value)? startingApp,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
  }) {
    return startingApp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StartingApp value)? startingApp,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
    required TResult orElse(),
  }) {
    if (startingApp != null) {
      return startingApp(this);
    }
    return orElse();
  }
}

abstract class StartingApp implements AuthEvent {
  const factory StartingApp() = _$StartingApp;
}

/// @nodoc
abstract class $LoggingInCopyWith<$Res> {
  factory $LoggingInCopyWith(LoggingIn value, $Res Function(LoggingIn) then) =
      _$LoggingInCopyWithImpl<$Res>;
  $Res call({UserLogin usuario});

  $UserLoginCopyWith<$Res> get usuario;
}

/// @nodoc
class _$LoggingInCopyWithImpl<$Res> extends _$AuthEventCopyWithImpl<$Res>
    implements $LoggingInCopyWith<$Res> {
  _$LoggingInCopyWithImpl(LoggingIn _value, $Res Function(LoggingIn) _then)
      : super(_value, (v) => _then(v as LoggingIn));

  @override
  LoggingIn get _value => super._value as LoggingIn;

  @override
  $Res call({
    Object? usuario = freezed,
  }) {
    return _then(LoggingIn(
      usuario: usuario == freezed
          ? _value.usuario
          : usuario // ignore: cast_nullable_to_non_nullable
              as UserLogin,
    ));
  }

  @override
  $UserLoginCopyWith<$Res> get usuario {
    return $UserLoginCopyWith<$Res>(_value.usuario, (value) {
      return _then(_value.copyWith(usuario: value));
    });
  }
}

/// @nodoc

class _$LoggingIn implements LoggingIn {
  const _$LoggingIn({required this.usuario});

  @override
  final UserLogin usuario;

  @override
  String toString() {
    return 'AuthEvent.loggingIn(usuario: $usuario)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is LoggingIn &&
            (identical(other.usuario, usuario) ||
                const DeepCollectionEquality().equals(other.usuario, usuario)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(usuario);

  @JsonKey(ignore: true)
  @override
  $LoggingInCopyWith<LoggingIn> get copyWith =>
      _$LoggingInCopyWithImpl<LoggingIn>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startingApp,
    required TResult Function(UserLogin usuario) loggingIn,
    required TResult Function() loggingOut,
  }) {
    return loggingIn(usuario);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? startingApp,
    TResult Function(UserLogin usuario)? loggingIn,
    TResult Function()? loggingOut,
  }) {
    return loggingIn?.call(usuario);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startingApp,
    TResult Function(UserLogin usuario)? loggingIn,
    TResult Function()? loggingOut,
    required TResult orElse(),
  }) {
    if (loggingIn != null) {
      return loggingIn(usuario);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StartingApp value) startingApp,
    required TResult Function(LoggingIn value) loggingIn,
    required TResult Function(LoggingOut value) loggingOut,
  }) {
    return loggingIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StartingApp value)? startingApp,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
  }) {
    return loggingIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StartingApp value)? startingApp,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
    required TResult orElse(),
  }) {
    if (loggingIn != null) {
      return loggingIn(this);
    }
    return orElse();
  }
}

abstract class LoggingIn implements AuthEvent {
  const factory LoggingIn({required UserLogin usuario}) = _$LoggingIn;

  UserLogin get usuario => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LoggingInCopyWith<LoggingIn> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoggingOutCopyWith<$Res> {
  factory $LoggingOutCopyWith(
          LoggingOut value, $Res Function(LoggingOut) then) =
      _$LoggingOutCopyWithImpl<$Res>;
}

/// @nodoc
class _$LoggingOutCopyWithImpl<$Res> extends _$AuthEventCopyWithImpl<$Res>
    implements $LoggingOutCopyWith<$Res> {
  _$LoggingOutCopyWithImpl(LoggingOut _value, $Res Function(LoggingOut) _then)
      : super(_value, (v) => _then(v as LoggingOut));

  @override
  LoggingOut get _value => super._value as LoggingOut;
}

/// @nodoc

class _$LoggingOut implements LoggingOut {
  const _$LoggingOut();

  @override
  String toString() {
    return 'AuthEvent.loggingOut()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is LoggingOut);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() startingApp,
    required TResult Function(UserLogin usuario) loggingIn,
    required TResult Function() loggingOut,
  }) {
    return loggingOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? startingApp,
    TResult Function(UserLogin usuario)? loggingIn,
    TResult Function()? loggingOut,
  }) {
    return loggingOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? startingApp,
    TResult Function(UserLogin usuario)? loggingIn,
    TResult Function()? loggingOut,
    required TResult orElse(),
  }) {
    if (loggingOut != null) {
      return loggingOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StartingApp value) startingApp,
    required TResult Function(LoggingIn value) loggingIn,
    required TResult Function(LoggingOut value) loggingOut,
  }) {
    return loggingOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(StartingApp value)? startingApp,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
  }) {
    return loggingOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StartingApp value)? startingApp,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
    required TResult orElse(),
  }) {
    if (loggingOut != null) {
      return loggingOut(this);
    }
    return orElse();
  }
}

abstract class LoggingOut implements AuthEvent {
  const factory LoggingOut() = _$LoggingOut;
}

/// @nodoc
class _$AuthStateTearOff {
  const _$AuthStateTearOff();

  Initial initial() {
    return const Initial();
  }

  Authenticated authenticated(
      {required Usuario usuario, required DateTime sincronizado}) {
    return Authenticated(
      usuario: usuario,
      sincronizado: sincronizado,
    );
  }

  Unauthenticated unauthenticated() {
    return const Unauthenticated();
  }

  Loading loading() {
    return const Loading();
  }
}

/// @nodoc
const $AuthState = _$AuthStateTearOff();

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Usuario usuario, DateTime sincronizado)
        authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Usuario usuario, DateTime sincronizado)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Usuario usuario, DateTime sincronizado)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(Loading value) loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Loading value)? loading,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Loading value)? loading,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res> implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  final AuthState _value;
  // ignore: unused_field
  final $Res Function(AuthState) _then;
}

/// @nodoc
abstract class $InitialCopyWith<$Res> {
  factory $InitialCopyWith(Initial value, $Res Function(Initial) then) =
      _$InitialCopyWithImpl<$Res>;
}

/// @nodoc
class _$InitialCopyWithImpl<$Res> extends _$AuthStateCopyWithImpl<$Res>
    implements $InitialCopyWith<$Res> {
  _$InitialCopyWithImpl(Initial _value, $Res Function(Initial) _then)
      : super(_value, (v) => _then(v as Initial));

  @override
  Initial get _value => super._value as Initial;
}

/// @nodoc

class _$Initial implements Initial {
  const _$Initial();

  @override
  String toString() {
    return 'AuthState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Initial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Usuario usuario, DateTime sincronizado)
        authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() loading,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Usuario usuario, DateTime sincronizado)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Usuario usuario, DateTime sincronizado)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(Loading value) loading,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Loading value)? loading,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Loading value)? loading,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial implements AuthState {
  const factory Initial() = _$Initial;
}

/// @nodoc
abstract class $AuthenticatedCopyWith<$Res> {
  factory $AuthenticatedCopyWith(
          Authenticated value, $Res Function(Authenticated) then) =
      _$AuthenticatedCopyWithImpl<$Res>;
  $Res call({Usuario usuario, DateTime sincronizado});

  $UsuarioCopyWith<$Res> get usuario;
}

/// @nodoc
class _$AuthenticatedCopyWithImpl<$Res> extends _$AuthStateCopyWithImpl<$Res>
    implements $AuthenticatedCopyWith<$Res> {
  _$AuthenticatedCopyWithImpl(
      Authenticated _value, $Res Function(Authenticated) _then)
      : super(_value, (v) => _then(v as Authenticated));

  @override
  Authenticated get _value => super._value as Authenticated;

  @override
  $Res call({
    Object? usuario = freezed,
    Object? sincronizado = freezed,
  }) {
    return _then(Authenticated(
      usuario: usuario == freezed
          ? _value.usuario
          : usuario // ignore: cast_nullable_to_non_nullable
              as Usuario,
      sincronizado: sincronizado == freezed
          ? _value.sincronizado
          : sincronizado // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  @override
  $UsuarioCopyWith<$Res> get usuario {
    return $UsuarioCopyWith<$Res>(_value.usuario, (value) {
      return _then(_value.copyWith(usuario: value));
    });
  }
}

/// @nodoc

class _$Authenticated implements Authenticated {
  const _$Authenticated({required this.usuario, required this.sincronizado});

  @override
  final Usuario usuario;
  @override
  final DateTime sincronizado;

  @override
  String toString() {
    return 'AuthState.authenticated(usuario: $usuario, sincronizado: $sincronizado)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Authenticated &&
            (identical(other.usuario, usuario) ||
                const DeepCollectionEquality()
                    .equals(other.usuario, usuario)) &&
            (identical(other.sincronizado, sincronizado) ||
                const DeepCollectionEquality()
                    .equals(other.sincronizado, sincronizado)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(usuario) ^
      const DeepCollectionEquality().hash(sincronizado);

  @JsonKey(ignore: true)
  @override
  $AuthenticatedCopyWith<Authenticated> get copyWith =>
      _$AuthenticatedCopyWithImpl<Authenticated>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Usuario usuario, DateTime sincronizado)
        authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() loading,
  }) {
    return authenticated(usuario, sincronizado);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Usuario usuario, DateTime sincronizado)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
  }) {
    return authenticated?.call(usuario, sincronizado);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Usuario usuario, DateTime sincronizado)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(usuario, sincronizado);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(Loading value) loading,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Loading value)? loading,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Loading value)? loading,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class Authenticated implements AuthState {
  const factory Authenticated(
      {required Usuario usuario,
      required DateTime sincronizado}) = _$Authenticated;

  Usuario get usuario => throw _privateConstructorUsedError;
  DateTime get sincronizado => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthenticatedCopyWith<Authenticated> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnauthenticatedCopyWith<$Res> {
  factory $UnauthenticatedCopyWith(
          Unauthenticated value, $Res Function(Unauthenticated) then) =
      _$UnauthenticatedCopyWithImpl<$Res>;
}

/// @nodoc
class _$UnauthenticatedCopyWithImpl<$Res> extends _$AuthStateCopyWithImpl<$Res>
    implements $UnauthenticatedCopyWith<$Res> {
  _$UnauthenticatedCopyWithImpl(
      Unauthenticated _value, $Res Function(Unauthenticated) _then)
      : super(_value, (v) => _then(v as Unauthenticated));

  @override
  Unauthenticated get _value => super._value as Unauthenticated;
}

/// @nodoc

class _$Unauthenticated implements Unauthenticated {
  const _$Unauthenticated();

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Unauthenticated);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Usuario usuario, DateTime sincronizado)
        authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() loading,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Usuario usuario, DateTime sincronizado)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Usuario usuario, DateTime sincronizado)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(Loading value) loading,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Loading value)? loading,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Loading value)? loading,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class Unauthenticated implements AuthState {
  const factory Unauthenticated() = _$Unauthenticated;
}

/// @nodoc
abstract class $LoadingCopyWith<$Res> {
  factory $LoadingCopyWith(Loading value, $Res Function(Loading) then) =
      _$LoadingCopyWithImpl<$Res>;
}

/// @nodoc
class _$LoadingCopyWithImpl<$Res> extends _$AuthStateCopyWithImpl<$Res>
    implements $LoadingCopyWith<$Res> {
  _$LoadingCopyWithImpl(Loading _value, $Res Function(Loading) _then)
      : super(_value, (v) => _then(v as Loading));

  @override
  Loading get _value => super._value as Loading;
}

/// @nodoc

class _$Loading implements Loading {
  const _$Loading();

  @override
  String toString() {
    return 'AuthState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Usuario usuario, DateTime sincronizado)
        authenticated,
    required TResult Function() unauthenticated,
    required TResult Function() loading,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Usuario usuario, DateTime sincronizado)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Usuario usuario, DateTime sincronizado)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function()? loading,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(Loading value) loading,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Loading value)? loading,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(Loading value)? loading,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements AuthState {
  const factory Loading() = _$Loading;
}
