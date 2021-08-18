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

  Started started() {
    return const Started();
  }

  LoggingIn loggingIn(
      {required Credenciales credenciales, bool offline = false}) {
    return LoggingIn(
      credenciales: credenciales,
      offline: offline,
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
    required TResult Function() started,
    required TResult Function(Credenciales credenciales, bool offline)
        loggingIn,
    required TResult Function() loggingOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Credenciales credenciales, bool offline)? loggingIn,
    TResult Function()? loggingOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Credenciales credenciales, bool offline)? loggingIn,
    TResult Function()? loggingOut,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Started value) started,
    required TResult Function(LoggingIn value) loggingIn,
    required TResult Function(LoggingOut value) loggingOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Started value)? started,
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
abstract class $StartedCopyWith<$Res> {
  factory $StartedCopyWith(Started value, $Res Function(Started) then) =
      _$StartedCopyWithImpl<$Res>;
}

/// @nodoc
class _$StartedCopyWithImpl<$Res> extends _$AuthEventCopyWithImpl<$Res>
    implements $StartedCopyWith<$Res> {
  _$StartedCopyWithImpl(Started _value, $Res Function(Started) _then)
      : super(_value, (v) => _then(v as Started));

  @override
  Started get _value => super._value as Started;
}

/// @nodoc

class _$Started implements Started {
  const _$Started();

  @override
  String toString() {
    return 'AuthEvent.started()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Started);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Credenciales credenciales, bool offline)
        loggingIn,
    required TResult Function() loggingOut,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Credenciales credenciales, bool offline)? loggingIn,
    TResult Function()? loggingOut,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Credenciales credenciales, bool offline)? loggingIn,
    TResult Function()? loggingOut,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Started value) started,
    required TResult Function(LoggingIn value) loggingIn,
    required TResult Function(LoggingOut value) loggingOut,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class Started implements AuthEvent {
  const factory Started() = _$Started;
}

/// @nodoc
abstract class $LoggingInCopyWith<$Res> {
  factory $LoggingInCopyWith(LoggingIn value, $Res Function(LoggingIn) then) =
      _$LoggingInCopyWithImpl<$Res>;
  $Res call({Credenciales credenciales, bool offline});

  $CredencialesCopyWith<$Res> get credenciales;
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
    Object? credenciales = freezed,
    Object? offline = freezed,
  }) {
    return _then(LoggingIn(
      credenciales: credenciales == freezed
          ? _value.credenciales
          : credenciales // ignore: cast_nullable_to_non_nullable
              as Credenciales,
      offline: offline == freezed
          ? _value.offline
          : offline // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  @override
  $CredencialesCopyWith<$Res> get credenciales {
    return $CredencialesCopyWith<$Res>(_value.credenciales, (value) {
      return _then(_value.copyWith(credenciales: value));
    });
  }
}

/// @nodoc

class _$LoggingIn implements LoggingIn {
  const _$LoggingIn({required this.credenciales, this.offline = false});

  @override
  final Credenciales credenciales;
  @JsonKey(defaultValue: false)
  @override
  final bool offline;

  @override
  String toString() {
    return 'AuthEvent.loggingIn(credenciales: $credenciales, offline: $offline)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is LoggingIn &&
            (identical(other.credenciales, credenciales) ||
                const DeepCollectionEquality()
                    .equals(other.credenciales, credenciales)) &&
            (identical(other.offline, offline) ||
                const DeepCollectionEquality().equals(other.offline, offline)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(credenciales) ^
      const DeepCollectionEquality().hash(offline);

  @JsonKey(ignore: true)
  @override
  $LoggingInCopyWith<LoggingIn> get copyWith =>
      _$LoggingInCopyWithImpl<LoggingIn>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(Credenciales credenciales, bool offline)
        loggingIn,
    required TResult Function() loggingOut,
  }) {
    return loggingIn(credenciales, offline);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Credenciales credenciales, bool offline)? loggingIn,
    TResult Function()? loggingOut,
  }) {
    return loggingIn?.call(credenciales, offline);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Credenciales credenciales, bool offline)? loggingIn,
    TResult Function()? loggingOut,
    required TResult orElse(),
  }) {
    if (loggingIn != null) {
      return loggingIn(credenciales, offline);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Started value) started,
    required TResult Function(LoggingIn value) loggingIn,
    required TResult Function(LoggingOut value) loggingOut,
  }) {
    return loggingIn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
  }) {
    return loggingIn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Started value)? started,
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
  const factory LoggingIn({required Credenciales credenciales, bool offline}) =
      _$LoggingIn;

  Credenciales get credenciales => throw _privateConstructorUsedError;
  bool get offline => throw _privateConstructorUsedError;
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
    required TResult Function() started,
    required TResult Function(Credenciales credenciales, bool offline)
        loggingIn,
    required TResult Function() loggingOut,
  }) {
    return loggingOut();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Credenciales credenciales, bool offline)? loggingIn,
    TResult Function()? loggingOut,
  }) {
    return loggingOut?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(Credenciales credenciales, bool offline)? loggingIn,
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
    required TResult Function(Started value) started,
    required TResult Function(LoggingIn value) loggingIn,
    required TResult Function(LoggingOut value) loggingOut,
  }) {
    return loggingOut(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Started value)? started,
    TResult Function(LoggingIn value)? loggingIn,
    TResult Function(LoggingOut value)? loggingOut,
  }) {
    return loggingOut?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Started value)? started,
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

  Authenticated authenticated(
      {required bool loading,
      required Option<AuthFailure> failure,
      required Usuario usuario,
      required Option<DateTime> sincronizado}) {
    return Authenticated(
      loading: loading,
      failure: failure,
      usuario: usuario,
      sincronizado: sincronizado,
    );
  }

  Unauthenticated unauthenticated(
      {required bool loading, required Option<AuthFailure> failure}) {
    return Unauthenticated(
      loading: loading,
      failure: failure,
    );
  }
}

/// @nodoc
const $AuthState = _$AuthStateTearOff();

/// @nodoc
mixin _$AuthState {
  bool get loading => throw _privateConstructorUsedError;
  Option<AuthFailure> get failure => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool loading, Option<AuthFailure> failure,
            Usuario usuario, Option<DateTime> sincronizado)
        authenticated,
    required TResult Function(bool loading, Option<AuthFailure> failure)
        unauthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(bool loading, Option<AuthFailure> failure, Usuario usuario,
            Option<DateTime> sincronizado)?
        authenticated,
    TResult Function(bool loading, Option<AuthFailure> failure)?
        unauthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool loading, Option<AuthFailure> failure, Usuario usuario,
            Option<DateTime> sincronizado)?
        authenticated,
    TResult Function(bool loading, Option<AuthFailure> failure)?
        unauthenticated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res>;
  $Res call({bool loading, Option<AuthFailure> failure});
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res> implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  final AuthState _value;
  // ignore: unused_field
  final $Res Function(AuthState) _then;

  @override
  $Res call({
    Object? loading = freezed,
    Object? failure = freezed,
  }) {
    return _then(_value.copyWith(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: failure == freezed
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<AuthFailure>,
    ));
  }
}

/// @nodoc
abstract class $AuthenticatedCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory $AuthenticatedCopyWith(
          Authenticated value, $Res Function(Authenticated) then) =
      _$AuthenticatedCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool loading,
      Option<AuthFailure> failure,
      Usuario usuario,
      Option<DateTime> sincronizado});

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
    Object? loading = freezed,
    Object? failure = freezed,
    Object? usuario = freezed,
    Object? sincronizado = freezed,
  }) {
    return _then(Authenticated(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: failure == freezed
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<AuthFailure>,
      usuario: usuario == freezed
          ? _value.usuario
          : usuario // ignore: cast_nullable_to_non_nullable
              as Usuario,
      sincronizado: sincronizado == freezed
          ? _value.sincronizado
          : sincronizado // ignore: cast_nullable_to_non_nullable
              as Option<DateTime>,
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
  const _$Authenticated(
      {required this.loading,
      required this.failure,
      required this.usuario,
      required this.sincronizado});

  @override
  final bool loading;
  @override
  final Option<AuthFailure> failure;
  @override
  final Usuario usuario;
  @override
  final Option<DateTime> sincronizado;

  @override
  String toString() {
    return 'AuthState.authenticated(loading: $loading, failure: $failure, usuario: $usuario, sincronizado: $sincronizado)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Authenticated &&
            (identical(other.loading, loading) ||
                const DeepCollectionEquality()
                    .equals(other.loading, loading)) &&
            (identical(other.failure, failure) ||
                const DeepCollectionEquality()
                    .equals(other.failure, failure)) &&
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
      const DeepCollectionEquality().hash(loading) ^
      const DeepCollectionEquality().hash(failure) ^
      const DeepCollectionEquality().hash(usuario) ^
      const DeepCollectionEquality().hash(sincronizado);

  @JsonKey(ignore: true)
  @override
  $AuthenticatedCopyWith<Authenticated> get copyWith =>
      _$AuthenticatedCopyWithImpl<Authenticated>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool loading, Option<AuthFailure> failure,
            Usuario usuario, Option<DateTime> sincronizado)
        authenticated,
    required TResult Function(bool loading, Option<AuthFailure> failure)
        unauthenticated,
  }) {
    return authenticated(loading, failure, usuario, sincronizado);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(bool loading, Option<AuthFailure> failure, Usuario usuario,
            Option<DateTime> sincronizado)?
        authenticated,
    TResult Function(bool loading, Option<AuthFailure> failure)?
        unauthenticated,
  }) {
    return authenticated?.call(loading, failure, usuario, sincronizado);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool loading, Option<AuthFailure> failure, Usuario usuario,
            Option<DateTime> sincronizado)?
        authenticated,
    TResult Function(bool loading, Option<AuthFailure> failure)?
        unauthenticated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(loading, failure, usuario, sincronizado);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
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
      {required bool loading,
      required Option<AuthFailure> failure,
      required Usuario usuario,
      required Option<DateTime> sincronizado}) = _$Authenticated;

  @override
  bool get loading => throw _privateConstructorUsedError;
  @override
  Option<AuthFailure> get failure => throw _privateConstructorUsedError;
  Usuario get usuario => throw _privateConstructorUsedError;
  Option<DateTime> get sincronizado => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $AuthenticatedCopyWith<Authenticated> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnauthenticatedCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory $UnauthenticatedCopyWith(
          Unauthenticated value, $Res Function(Unauthenticated) then) =
      _$UnauthenticatedCopyWithImpl<$Res>;
  @override
  $Res call({bool loading, Option<AuthFailure> failure});
}

/// @nodoc
class _$UnauthenticatedCopyWithImpl<$Res> extends _$AuthStateCopyWithImpl<$Res>
    implements $UnauthenticatedCopyWith<$Res> {
  _$UnauthenticatedCopyWithImpl(
      Unauthenticated _value, $Res Function(Unauthenticated) _then)
      : super(_value, (v) => _then(v as Unauthenticated));

  @override
  Unauthenticated get _value => super._value as Unauthenticated;

  @override
  $Res call({
    Object? loading = freezed,
    Object? failure = freezed,
  }) {
    return _then(Unauthenticated(
      loading: loading == freezed
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      failure: failure == freezed
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Option<AuthFailure>,
    ));
  }
}

/// @nodoc

class _$Unauthenticated implements Unauthenticated {
  const _$Unauthenticated({required this.loading, required this.failure});

  @override
  final bool loading;
  @override
  final Option<AuthFailure> failure;

  @override
  String toString() {
    return 'AuthState.unauthenticated(loading: $loading, failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Unauthenticated &&
            (identical(other.loading, loading) ||
                const DeepCollectionEquality()
                    .equals(other.loading, loading)) &&
            (identical(other.failure, failure) ||
                const DeepCollectionEquality().equals(other.failure, failure)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(loading) ^
      const DeepCollectionEquality().hash(failure);

  @JsonKey(ignore: true)
  @override
  $UnauthenticatedCopyWith<Unauthenticated> get copyWith =>
      _$UnauthenticatedCopyWithImpl<Unauthenticated>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(bool loading, Option<AuthFailure> failure,
            Usuario usuario, Option<DateTime> sincronizado)
        authenticated,
    required TResult Function(bool loading, Option<AuthFailure> failure)
        unauthenticated,
  }) {
    return unauthenticated(loading, failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(bool loading, Option<AuthFailure> failure, Usuario usuario,
            Option<DateTime> sincronizado)?
        authenticated,
    TResult Function(bool loading, Option<AuthFailure> failure)?
        unauthenticated,
  }) {
    return unauthenticated?.call(loading, failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(bool loading, Option<AuthFailure> failure, Usuario usuario,
            Option<DateTime> sincronizado)?
        authenticated,
    TResult Function(bool loading, Option<AuthFailure> failure)?
        unauthenticated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(loading, failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class Unauthenticated implements AuthState {
  const factory Unauthenticated(
      {required bool loading,
      required Option<AuthFailure> failure}) = _$Unauthenticated;

  @override
  bool get loading => throw _privateConstructorUsedError;
  @override
  Option<AuthFailure> get failure => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  $UnauthenticatedCopyWith<Unauthenticated> get copyWith =>
      throw _privateConstructorUsedError;
}
