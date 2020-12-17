import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_model.freezed.dart';
part 'api_model.g.dart';

@freezed
abstract class UserLogin implements _$UserLogin {
  factory UserLogin({
    String documento,
    String password,
  }) = _UserLogin;

  const UserLogin._();

  factory UserLogin.fromJson(Map<String, dynamic> json) =>
      _$UserLoginFromJson(json);

  Map<String, dynamic> toDatabaseJson() =>
      {"username": documento, "password": password};
}
