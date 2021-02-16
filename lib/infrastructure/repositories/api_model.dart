import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_model.freezed.dart';
part 'api_model.g.dart';

@freezed
abstract class UserLogin implements _$UserLogin {
  factory UserLogin({
    String username,
    String password,
    bool esdAdmin,
  }) = _UserLogin;

  const UserLogin._();

  factory UserLogin.fromJson(Map<String, dynamic> json) =>
      _$UserLoginFromJson(json);
}
