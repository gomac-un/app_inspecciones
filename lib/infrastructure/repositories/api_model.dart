import 'dart:convert';

class UserLogin {
  String username;
  String password;

  UserLogin({this.username, this.password});

  Map<String, dynamic> toDatabaseJson() =>
      {"username": this.username, "password": this.password};
}

class Token {
  String token;

  Token({
    this.token,
  });

  factory Token.fromServerJson(Map<String, dynamic> json) {
    return Token(token: json['token']);
  }
  // codigo generado

  Token copyWith({
    String token,
  }) {
    return Token(
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
    };
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Token(
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Token.fromJson(String source) => Token.fromMap(json.decode(source));

  @override
  String toString() => 'Token(token: $token)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Token && o.token == token;
  }

  @override
  int get hashCode => token.hashCode;
}
