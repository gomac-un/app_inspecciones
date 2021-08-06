import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_model.freezed.dart';
part 'api_model.g.dart';

@freezed
class UserLogin implements _$UserLogin {
  factory UserLogin({
    required String username,
    required String password,
    required bool esAdmin,
  }) = _UserLogin;

  const UserLogin._();

  factory UserLogin.fromJson(Map<String, dynamic> json) =>
      _$UserLoginFromJson(json);
}
