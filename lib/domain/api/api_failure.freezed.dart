// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'api_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$ApiFailureTearOff {
  const _$ApiFailureTearOff();

// ignore: unused_element
  NoHayInternet noHayInternet() {
    return const NoHayInternet();
  }

// ignore: unused_element
  NoHayConexionAlServidor noHayConexionAlServidor() {
    return const NoHayConexionAlServidor();
  }

// ignore: unused_element
  ServerError serverError(String msg) {
    return ServerError(
      msg,
    );
  }

// ignore: unused_element
  CredencialesError credencialesException() {
    return const CredencialesError();
  }

// ignore: unused_element
  PageNotFoundError pageNotFound() {
    return const PageNotFoundError();
  }
}

/// @nodoc
// ignore: unused_element
const $ApiFailure = _$ApiFailureTearOff();

/// @nodoc
mixin _$ApiFailure {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult noHayInternet(),
    @required TResult noHayConexionAlServidor(),
    @required TResult serverError(String msg),
    @required TResult credencialesException(),
    @required TResult pageNotFound(),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult noHayInternet(),
    TResult noHayConexionAlServidor(),
    TResult serverError(String msg),
    TResult credencialesException(),
    TResult pageNotFound(),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult noHayInternet(NoHayInternet value),
    @required TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    @required TResult serverError(ServerError value),
    @required TResult credencialesException(CredencialesError value),
    @required TResult pageNotFound(PageNotFoundError value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult noHayInternet(NoHayInternet value),
    TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    TResult serverError(ServerError value),
    TResult credencialesException(CredencialesError value),
    TResult pageNotFound(PageNotFoundError value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $ApiFailureCopyWith<$Res> {
  factory $ApiFailureCopyWith(
          ApiFailure value, $Res Function(ApiFailure) then) =
      _$ApiFailureCopyWithImpl<$Res>;
}

/// @nodoc
class _$ApiFailureCopyWithImpl<$Res> implements $ApiFailureCopyWith<$Res> {
  _$ApiFailureCopyWithImpl(this._value, this._then);

  final ApiFailure _value;
  // ignore: unused_field
  final $Res Function(ApiFailure) _then;
}

/// @nodoc
abstract class $NoHayInternetCopyWith<$Res> {
  factory $NoHayInternetCopyWith(
          NoHayInternet value, $Res Function(NoHayInternet) then) =
      _$NoHayInternetCopyWithImpl<$Res>;
}

/// @nodoc
class _$NoHayInternetCopyWithImpl<$Res> extends _$ApiFailureCopyWithImpl<$Res>
    implements $NoHayInternetCopyWith<$Res> {
  _$NoHayInternetCopyWithImpl(
      NoHayInternet _value, $Res Function(NoHayInternet) _then)
      : super(_value, (v) => _then(v as NoHayInternet));

  @override
  NoHayInternet get _value => super._value as NoHayInternet;
}

/// @nodoc
class _$NoHayInternet implements NoHayInternet {
  const _$NoHayInternet();

  @override
  String toString() {
    return 'ApiFailure.noHayInternet()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is NoHayInternet);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult noHayInternet(),
    @required TResult noHayConexionAlServidor(),
    @required TResult serverError(String msg),
    @required TResult credencialesException(),
    @required TResult pageNotFound(),
  }) {
    assert(noHayInternet != null);
    assert(noHayConexionAlServidor != null);
    assert(serverError != null);
    assert(credencialesException != null);
    assert(pageNotFound != null);
    return noHayInternet();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult noHayInternet(),
    TResult noHayConexionAlServidor(),
    TResult serverError(String msg),
    TResult credencialesException(),
    TResult pageNotFound(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (noHayInternet != null) {
      return noHayInternet();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult noHayInternet(NoHayInternet value),
    @required TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    @required TResult serverError(ServerError value),
    @required TResult credencialesException(CredencialesError value),
    @required TResult pageNotFound(PageNotFoundError value),
  }) {
    assert(noHayInternet != null);
    assert(noHayConexionAlServidor != null);
    assert(serverError != null);
    assert(credencialesException != null);
    assert(pageNotFound != null);
    return noHayInternet(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult noHayInternet(NoHayInternet value),
    TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    TResult serverError(ServerError value),
    TResult credencialesException(CredencialesError value),
    TResult pageNotFound(PageNotFoundError value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (noHayInternet != null) {
      return noHayInternet(this);
    }
    return orElse();
  }
}

abstract class NoHayInternet implements ApiFailure {
  const factory NoHayInternet() = _$NoHayInternet;
}

/// @nodoc
abstract class $NoHayConexionAlServidorCopyWith<$Res> {
  factory $NoHayConexionAlServidorCopyWith(NoHayConexionAlServidor value,
          $Res Function(NoHayConexionAlServidor) then) =
      _$NoHayConexionAlServidorCopyWithImpl<$Res>;
}

/// @nodoc
class _$NoHayConexionAlServidorCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res>
    implements $NoHayConexionAlServidorCopyWith<$Res> {
  _$NoHayConexionAlServidorCopyWithImpl(NoHayConexionAlServidor _value,
      $Res Function(NoHayConexionAlServidor) _then)
      : super(_value, (v) => _then(v as NoHayConexionAlServidor));

  @override
  NoHayConexionAlServidor get _value => super._value as NoHayConexionAlServidor;
}

/// @nodoc
class _$NoHayConexionAlServidor implements NoHayConexionAlServidor {
  const _$NoHayConexionAlServidor();

  @override
  String toString() {
    return 'ApiFailure.noHayConexionAlServidor()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is NoHayConexionAlServidor);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult noHayInternet(),
    @required TResult noHayConexionAlServidor(),
    @required TResult serverError(String msg),
    @required TResult credencialesException(),
    @required TResult pageNotFound(),
  }) {
    assert(noHayInternet != null);
    assert(noHayConexionAlServidor != null);
    assert(serverError != null);
    assert(credencialesException != null);
    assert(pageNotFound != null);
    return noHayConexionAlServidor();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult noHayInternet(),
    TResult noHayConexionAlServidor(),
    TResult serverError(String msg),
    TResult credencialesException(),
    TResult pageNotFound(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (noHayConexionAlServidor != null) {
      return noHayConexionAlServidor();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult noHayInternet(NoHayInternet value),
    @required TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    @required TResult serverError(ServerError value),
    @required TResult credencialesException(CredencialesError value),
    @required TResult pageNotFound(PageNotFoundError value),
  }) {
    assert(noHayInternet != null);
    assert(noHayConexionAlServidor != null);
    assert(serverError != null);
    assert(credencialesException != null);
    assert(pageNotFound != null);
    return noHayConexionAlServidor(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult noHayInternet(NoHayInternet value),
    TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    TResult serverError(ServerError value),
    TResult credencialesException(CredencialesError value),
    TResult pageNotFound(PageNotFoundError value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (noHayConexionAlServidor != null) {
      return noHayConexionAlServidor(this);
    }
    return orElse();
  }
}

abstract class NoHayConexionAlServidor implements ApiFailure {
  const factory NoHayConexionAlServidor() = _$NoHayConexionAlServidor;
}

/// @nodoc
abstract class $ServerErrorCopyWith<$Res> {
  factory $ServerErrorCopyWith(
          ServerError value, $Res Function(ServerError) then) =
      _$ServerErrorCopyWithImpl<$Res>;
  $Res call({String msg});
}

/// @nodoc
class _$ServerErrorCopyWithImpl<$Res> extends _$ApiFailureCopyWithImpl<$Res>
    implements $ServerErrorCopyWith<$Res> {
  _$ServerErrorCopyWithImpl(
      ServerError _value, $Res Function(ServerError) _then)
      : super(_value, (v) => _then(v as ServerError));

  @override
  ServerError get _value => super._value as ServerError;

  @override
  $Res call({
    Object msg = freezed,
  }) {
    return _then(ServerError(
      msg == freezed ? _value.msg : msg as String,
    ));
  }
}

/// @nodoc
class _$ServerError implements ServerError {
  const _$ServerError(this.msg) : assert(msg != null);

  @override
  final String msg;

  @override
  String toString() {
    return 'ApiFailure.serverError(msg: $msg)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ServerError &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(msg);

  @JsonKey(ignore: true)
  @override
  $ServerErrorCopyWith<ServerError> get copyWith =>
      _$ServerErrorCopyWithImpl<ServerError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult noHayInternet(),
    @required TResult noHayConexionAlServidor(),
    @required TResult serverError(String msg),
    @required TResult credencialesException(),
    @required TResult pageNotFound(),
  }) {
    assert(noHayInternet != null);
    assert(noHayConexionAlServidor != null);
    assert(serverError != null);
    assert(credencialesException != null);
    assert(pageNotFound != null);
    return serverError(msg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult noHayInternet(),
    TResult noHayConexionAlServidor(),
    TResult serverError(String msg),
    TResult credencialesException(),
    TResult pageNotFound(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (serverError != null) {
      return serverError(msg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult noHayInternet(NoHayInternet value),
    @required TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    @required TResult serverError(ServerError value),
    @required TResult credencialesException(CredencialesError value),
    @required TResult pageNotFound(PageNotFoundError value),
  }) {
    assert(noHayInternet != null);
    assert(noHayConexionAlServidor != null);
    assert(serverError != null);
    assert(credencialesException != null);
    assert(pageNotFound != null);
    return serverError(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult noHayInternet(NoHayInternet value),
    TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    TResult serverError(ServerError value),
    TResult credencialesException(CredencialesError value),
    TResult pageNotFound(PageNotFoundError value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (serverError != null) {
      return serverError(this);
    }
    return orElse();
  }
}

abstract class ServerError implements ApiFailure {
  const factory ServerError(String msg) = _$ServerError;

  String get msg;
  @JsonKey(ignore: true)
  $ServerErrorCopyWith<ServerError> get copyWith;
}

/// @nodoc
abstract class $CredencialesErrorCopyWith<$Res> {
  factory $CredencialesErrorCopyWith(
          CredencialesError value, $Res Function(CredencialesError) then) =
      _$CredencialesErrorCopyWithImpl<$Res>;
}

/// @nodoc
class _$CredencialesErrorCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res>
    implements $CredencialesErrorCopyWith<$Res> {
  _$CredencialesErrorCopyWithImpl(
      CredencialesError _value, $Res Function(CredencialesError) _then)
      : super(_value, (v) => _then(v as CredencialesError));

  @override
  CredencialesError get _value => super._value as CredencialesError;
}

/// @nodoc
class _$CredencialesError implements CredencialesError {
  const _$CredencialesError();

  @override
  String toString() {
    return 'ApiFailure.credencialesException()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is CredencialesError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult noHayInternet(),
    @required TResult noHayConexionAlServidor(),
    @required TResult serverError(String msg),
    @required TResult credencialesException(),
    @required TResult pageNotFound(),
  }) {
    assert(noHayInternet != null);
    assert(noHayConexionAlServidor != null);
    assert(serverError != null);
    assert(credencialesException != null);
    assert(pageNotFound != null);
    return credencialesException();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult noHayInternet(),
    TResult noHayConexionAlServidor(),
    TResult serverError(String msg),
    TResult credencialesException(),
    TResult pageNotFound(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (credencialesException != null) {
      return credencialesException();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult noHayInternet(NoHayInternet value),
    @required TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    @required TResult serverError(ServerError value),
    @required TResult credencialesException(CredencialesError value),
    @required TResult pageNotFound(PageNotFoundError value),
  }) {
    assert(noHayInternet != null);
    assert(noHayConexionAlServidor != null);
    assert(serverError != null);
    assert(credencialesException != null);
    assert(pageNotFound != null);
    return credencialesException(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult noHayInternet(NoHayInternet value),
    TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    TResult serverError(ServerError value),
    TResult credencialesException(CredencialesError value),
    TResult pageNotFound(PageNotFoundError value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (credencialesException != null) {
      return credencialesException(this);
    }
    return orElse();
  }
}

abstract class CredencialesError implements ApiFailure {
  const factory CredencialesError() = _$CredencialesError;
}

/// @nodoc
abstract class $PageNotFoundErrorCopyWith<$Res> {
  factory $PageNotFoundErrorCopyWith(
          PageNotFoundError value, $Res Function(PageNotFoundError) then) =
      _$PageNotFoundErrorCopyWithImpl<$Res>;
}

/// @nodoc
class _$PageNotFoundErrorCopyWithImpl<$Res>
    extends _$ApiFailureCopyWithImpl<$Res>
    implements $PageNotFoundErrorCopyWith<$Res> {
  _$PageNotFoundErrorCopyWithImpl(
      PageNotFoundError _value, $Res Function(PageNotFoundError) _then)
      : super(_value, (v) => _then(v as PageNotFoundError));

  @override
  PageNotFoundError get _value => super._value as PageNotFoundError;
}

/// @nodoc
class _$PageNotFoundError implements PageNotFoundError {
  const _$PageNotFoundError();

  @override
  String toString() {
    return 'ApiFailure.pageNotFound()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is PageNotFoundError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult noHayInternet(),
    @required TResult noHayConexionAlServidor(),
    @required TResult serverError(String msg),
    @required TResult credencialesException(),
    @required TResult pageNotFound(),
  }) {
    assert(noHayInternet != null);
    assert(noHayConexionAlServidor != null);
    assert(serverError != null);
    assert(credencialesException != null);
    assert(pageNotFound != null);
    return pageNotFound();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult noHayInternet(),
    TResult noHayConexionAlServidor(),
    TResult serverError(String msg),
    TResult credencialesException(),
    TResult pageNotFound(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (pageNotFound != null) {
      return pageNotFound();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult noHayInternet(NoHayInternet value),
    @required TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    @required TResult serverError(ServerError value),
    @required TResult credencialesException(CredencialesError value),
    @required TResult pageNotFound(PageNotFoundError value),
  }) {
    assert(noHayInternet != null);
    assert(noHayConexionAlServidor != null);
    assert(serverError != null);
    assert(credencialesException != null);
    assert(pageNotFound != null);
    return pageNotFound(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult noHayInternet(NoHayInternet value),
    TResult noHayConexionAlServidor(NoHayConexionAlServidor value),
    TResult serverError(ServerError value),
    TResult credencialesException(CredencialesError value),
    TResult pageNotFound(PageNotFoundError value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (pageNotFound != null) {
      return pageNotFound(this);
    }
    return orElse();
  }
}

abstract class PageNotFoundError implements ApiFailure {
  const factory PageNotFoundError() = _$PageNotFoundError;
}
