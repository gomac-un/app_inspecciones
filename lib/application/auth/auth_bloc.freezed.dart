// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$AuthEventTearOff {
  const _$AuthEventTearOff();

// ignore: unused_element
  StartingApp startingApp() {
    return const StartingApp();
  }

// ignore: unused_element
  LoggingIn loggingIn({UserLogin login}) {
    return LoggingIn(
      login: login,
    );
  }

// ignore: unused_element
  LoggingOut loggingOut() {
    return const LoggingOut();
  }
}

/// @nodoc
// ignore: unused_element
const $AuthEvent = _$AuthEventTearOff();

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult startingApp(),
    @required TResult loggingIn(UserLogin login),
    @required TResult loggingOut(),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult startingApp(),
    TResult loggingIn(UserLogin login),
    TResult loggingOut(),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult startingApp(StartingApp value),
    @required TResult loggingIn(LoggingIn value),
    @required TResult loggingOut(LoggingOut value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult startingApp(StartingApp value),
    TResult loggingIn(LoggingIn value),
    TResult loggingOut(LoggingOut value),
    @required TResult orElse(),
  });
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
  TResult when<TResult extends Object>({
    @required TResult startingApp(),
    @required TResult loggingIn(UserLogin login),
    @required TResult loggingOut(),
  }) {
    assert(startingApp != null);
    assert(loggingIn != null);
    assert(loggingOut != null);
    return startingApp();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult startingApp(),
    TResult loggingIn(UserLogin login),
    TResult loggingOut(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (startingApp != null) {
      return startingApp();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult startingApp(StartingApp value),
    @required TResult loggingIn(LoggingIn value),
    @required TResult loggingOut(LoggingOut value),
  }) {
    assert(startingApp != null);
    assert(loggingIn != null);
    assert(loggingOut != null);
    return startingApp(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult startingApp(StartingApp value),
    TResult loggingIn(LoggingIn value),
    TResult loggingOut(LoggingOut value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
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
  $Res call({UserLogin login});

  $UserLoginCopyWith<$Res> get login;
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
    Object login = freezed,
  }) {
    return _then(LoggingIn(
      login: login == freezed ? _value.login : login as UserLogin,
    ));
  }

  @override
  $UserLoginCopyWith<$Res> get login {
    if (_value.login == null) {
      return null;
    }
    return $UserLoginCopyWith<$Res>(_value.login, (value) {
      return _then(_value.copyWith(login: value));
    });
  }
}

/// @nodoc
class _$LoggingIn implements LoggingIn {
  const _$LoggingIn({this.login});

  @override
  final UserLogin login;

  @override
  String toString() {
    return 'AuthEvent.loggingIn(login: $login)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is LoggingIn &&
            (identical(other.login, login) ||
                const DeepCollectionEquality().equals(other.login, login)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(login);

  @override
  $LoggingInCopyWith<LoggingIn> get copyWith =>
      _$LoggingInCopyWithImpl<LoggingIn>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult startingApp(),
    @required TResult loggingIn(UserLogin login),
    @required TResult loggingOut(),
  }) {
    assert(startingApp != null);
    assert(loggingIn != null);
    assert(loggingOut != null);
    return loggingIn(login);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult startingApp(),
    TResult loggingIn(UserLogin login),
    TResult loggingOut(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loggingIn != null) {
      return loggingIn(login);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult startingApp(StartingApp value),
    @required TResult loggingIn(LoggingIn value),
    @required TResult loggingOut(LoggingOut value),
  }) {
    assert(startingApp != null);
    assert(loggingIn != null);
    assert(loggingOut != null);
    return loggingIn(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult startingApp(StartingApp value),
    TResult loggingIn(LoggingIn value),
    TResult loggingOut(LoggingOut value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loggingIn != null) {
      return loggingIn(this);
    }
    return orElse();
  }
}

abstract class LoggingIn implements AuthEvent {
  const factory LoggingIn({UserLogin login}) = _$LoggingIn;

  UserLogin get login;
  $LoggingInCopyWith<LoggingIn> get copyWith;
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
  TResult when<TResult extends Object>({
    @required TResult startingApp(),
    @required TResult loggingIn(UserLogin login),
    @required TResult loggingOut(),
  }) {
    assert(startingApp != null);
    assert(loggingIn != null);
    assert(loggingOut != null);
    return loggingOut();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult startingApp(),
    TResult loggingIn(UserLogin login),
    TResult loggingOut(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loggingOut != null) {
      return loggingOut();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult startingApp(StartingApp value),
    @required TResult loggingIn(LoggingIn value),
    @required TResult loggingOut(LoggingOut value),
  }) {
    assert(startingApp != null);
    assert(loggingIn != null);
    assert(loggingOut != null);
    return loggingOut(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult startingApp(StartingApp value),
    TResult loggingIn(LoggingIn value),
    TResult loggingOut(LoggingOut value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
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

// ignore: unused_element
  Initial initial() {
    return const Initial();
  }

// ignore: unused_element
  Authenticated authenticated({Usuario usuario}) {
    return Authenticated(
      usuario: usuario,
    );
  }

// ignore: unused_element
  Unauthenticated unauthenticated() {
    return const Unauthenticated();
  }

// ignore: unused_element
  Loading loading() {
    return const Loading();
  }
}

/// @nodoc
// ignore: unused_element
const $AuthState = _$AuthStateTearOff();

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult authenticated(Usuario usuario),
    @required TResult unauthenticated(),
    @required TResult loading(),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult authenticated(Usuario usuario),
    TResult unauthenticated(),
    TResult loading(),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(Initial value),
    @required TResult authenticated(Authenticated value),
    @required TResult unauthenticated(Unauthenticated value),
    @required TResult loading(Loading value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(Initial value),
    TResult authenticated(Authenticated value),
    TResult unauthenticated(Unauthenticated value),
    TResult loading(Loading value),
    @required TResult orElse(),
  });
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
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult authenticated(Usuario usuario),
    @required TResult unauthenticated(),
    @required TResult loading(),
  }) {
    assert(initial != null);
    assert(authenticated != null);
    assert(unauthenticated != null);
    assert(loading != null);
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult authenticated(Usuario usuario),
    TResult unauthenticated(),
    TResult loading(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(Initial value),
    @required TResult authenticated(Authenticated value),
    @required TResult unauthenticated(Unauthenticated value),
    @required TResult loading(Loading value),
  }) {
    assert(initial != null);
    assert(authenticated != null);
    assert(unauthenticated != null);
    assert(loading != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(Initial value),
    TResult authenticated(Authenticated value),
    TResult unauthenticated(Unauthenticated value),
    TResult loading(Loading value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
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
  $Res call({Usuario usuario});

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
    Object usuario = freezed,
  }) {
    return _then(Authenticated(
      usuario: usuario == freezed ? _value.usuario : usuario as Usuario,
    ));
  }

  @override
  $UsuarioCopyWith<$Res> get usuario {
    if (_value.usuario == null) {
      return null;
    }
    return $UsuarioCopyWith<$Res>(_value.usuario, (value) {
      return _then(_value.copyWith(usuario: value));
    });
  }
}

/// @nodoc
class _$Authenticated implements Authenticated {
  const _$Authenticated({this.usuario});

  @override
  final Usuario usuario;

  @override
  String toString() {
    return 'AuthState.authenticated(usuario: $usuario)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Authenticated &&
            (identical(other.usuario, usuario) ||
                const DeepCollectionEquality().equals(other.usuario, usuario)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(usuario);

  @override
  $AuthenticatedCopyWith<Authenticated> get copyWith =>
      _$AuthenticatedCopyWithImpl<Authenticated>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult authenticated(Usuario usuario),
    @required TResult unauthenticated(),
    @required TResult loading(),
  }) {
    assert(initial != null);
    assert(authenticated != null);
    assert(unauthenticated != null);
    assert(loading != null);
    return authenticated(usuario);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult authenticated(Usuario usuario),
    TResult unauthenticated(),
    TResult loading(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (authenticated != null) {
      return authenticated(usuario);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(Initial value),
    @required TResult authenticated(Authenticated value),
    @required TResult unauthenticated(Unauthenticated value),
    @required TResult loading(Loading value),
  }) {
    assert(initial != null);
    assert(authenticated != null);
    assert(unauthenticated != null);
    assert(loading != null);
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(Initial value),
    TResult authenticated(Authenticated value),
    TResult unauthenticated(Unauthenticated value),
    TResult loading(Loading value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class Authenticated implements AuthState {
  const factory Authenticated({Usuario usuario}) = _$Authenticated;

  Usuario get usuario;
  $AuthenticatedCopyWith<Authenticated> get copyWith;
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
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult authenticated(Usuario usuario),
    @required TResult unauthenticated(),
    @required TResult loading(),
  }) {
    assert(initial != null);
    assert(authenticated != null);
    assert(unauthenticated != null);
    assert(loading != null);
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult authenticated(Usuario usuario),
    TResult unauthenticated(),
    TResult loading(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(Initial value),
    @required TResult authenticated(Authenticated value),
    @required TResult unauthenticated(Unauthenticated value),
    @required TResult loading(Loading value),
  }) {
    assert(initial != null);
    assert(authenticated != null);
    assert(unauthenticated != null);
    assert(loading != null);
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(Initial value),
    TResult authenticated(Authenticated value),
    TResult unauthenticated(Unauthenticated value),
    TResult loading(Loading value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
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
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult authenticated(Usuario usuario),
    @required TResult unauthenticated(),
    @required TResult loading(),
  }) {
    assert(initial != null);
    assert(authenticated != null);
    assert(unauthenticated != null);
    assert(loading != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult authenticated(Usuario usuario),
    TResult unauthenticated(),
    TResult loading(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(Initial value),
    @required TResult authenticated(Authenticated value),
    @required TResult unauthenticated(Unauthenticated value),
    @required TResult loading(Loading value),
  }) {
    assert(initial != null);
    assert(authenticated != null);
    assert(unauthenticated != null);
    assert(loading != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(Initial value),
    TResult authenticated(Authenticated value),
    TResult unauthenticated(Unauthenticated value),
    TResult loading(Loading value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements AuthState {
  const factory Loading() = _$Loading;
}
