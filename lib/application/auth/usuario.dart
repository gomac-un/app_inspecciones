import 'dart:convert';

import 'package:inspecciones/infrastructure/repositories/api_model.dart';

class Usuario {
  final String documento;
  final String contrasena;
  final bool esAdministrador;
  final Token token;
  const Usuario(
      this.documento, this.contrasena, this.esAdministrador, this.token);

  static List getUsers() {
    return [
      Usuario('1000', 'inspec', false, null),
      Usuario('1013', 'admin', true, null)
    ];
  }

// Todo este codigo es generado para que usuario sea una dataclass

  Usuario copyWith({
    String documento,
    String contrasena,
    bool esAdministrador,
    Token token,
  }) {
    return Usuario(
      documento ?? this.documento,
      contrasena ?? this.contrasena,
      esAdministrador ?? this.esAdministrador,
      token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documento': documento,
      'contrasena': contrasena,
      'esAdministrador': esAdministrador,
      'token': token?.toMap(),
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Usuario(
      map['documento'],
      map['contrasena'],
      map['esAdministrador'],
      Token.fromMap(map['token']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Usuario(documento: $documento, contrasena: $contrasena, esAdministrador: $esAdministrador, token: $token)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Usuario &&
        o.documento == documento &&
        o.contrasena == contrasena &&
        o.esAdministrador == esAdministrador &&
        o.token == token;
  }

  @override
  int get hashCode {
    return documento.hashCode ^
        contrasena.hashCode ^
        esAdministrador.hashCode ^
        token.hashCode;
  }
}
