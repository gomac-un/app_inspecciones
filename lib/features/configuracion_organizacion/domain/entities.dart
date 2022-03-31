import 'dart:convert';

class UsuarioEnLista {
  final int id;
  final String nombre;
  final String fotoUrl;
  final String rol;

  UsuarioEnLista(this.id, this.nombre, this.fotoUrl, this.rol);

  factory UsuarioEnLista.fromMap(Map<String, dynamic> map) =>
      UsuarioEnLista(map["id"], map["nombre"], map["foto"], map["rol"]);
}

class Organizacion {
  final int id;
  final String nombre;
  final String logo;
  final String link;
  final String acerca;

  Organizacion(this.id, this.nombre, this.logo, this.link, this.acerca);

  factory Organizacion.fromMap(Map<String, dynamic> map) {
    return Organizacion(
      map['id'],
      map['nombre'],
      map['logo'],
      map['link'],
      map['acerca'],
    );
  }
}

class ActivoEnLista {
  final String id;
  final String identificador;
  final List<Etiqueta> etiquetas;

  ActivoEnLista(
    this.id,
    this.identificador,
    this.etiquetas,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'identificador': identificador,
      'etiquetas': etiquetas.map((x) => x.toMap()).toList(),
    };
  }

  factory ActivoEnLista.fromMap(Map<String, dynamic> map) {
    return ActivoEnLista(
      map['id'],
      map['identificador'],
      (map['etiquetas'] as List).map((x) => Etiqueta.fromMap(x)).toList(),
    );
  }
}

class Etiqueta {
  final String clave;
  final String valor;

  Etiqueta(
    this.clave,
    this.valor,
  );

  @override
  String toString() {
    return "$clave:$valor";
  }

  Etiqueta copyWith({
    String? clave,
    String? valor,
  }) {
    return Etiqueta(
      clave ?? this.clave,
      valor ?? this.valor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clave': clave,
      'valor': valor,
    };
  }

  factory Etiqueta.fromMap(Map<String, dynamic> map) {
    return Etiqueta(
      map['clave'],
      map['valor'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Etiqueta.fromJson(String source) =>
      Etiqueta.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Etiqueta && other.clave == clave && other.valor == valor;
  }

  @override
  int get hashCode => clave.hashCode ^ valor.hashCode;
}

class EtiquetaEnJerarquia {
  final String valor;
  final List<EtiquetaEnJerarquia> children;

  EtiquetaEnJerarquia(this.valor, [this.children = const []]);

  EtiquetaEnJerarquia copyWith({
    String? valor,
    List<EtiquetaEnJerarquia>? children,
  }) {
    return EtiquetaEnJerarquia(
      valor ?? this.valor,
      children ?? this.children,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'children': children.map((x) => x.toMap()).toList(),
    };
  }

  factory EtiquetaEnJerarquia.fromMap(Map<String, dynamic> map) {
    return EtiquetaEnJerarquia(
      map['valor'],
      List<EtiquetaEnJerarquia>.from(
          map['children'].map((x) => EtiquetaEnJerarquia.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory EtiquetaEnJerarquia.fromJson(String source) =>
      EtiquetaEnJerarquia.fromMap(json.decode(source));
}

class Jerarquia {
  final List<String> niveles;
  final List<EtiquetaEnJerarquia> arbol;
  final bool esLocal;

  Jerarquia(
      {required this.niveles, required this.arbol, required this.esLocal});
/*
  Jerarquia.etiqueta({
    required String clave,
    required String valor,
  })  : niveles = [clave],
        arbol = [EtiquetaEnJerarquia(valor, [])];

  Jerarquia.plana({
    required String clave,
    required List<String> valores,
  })  : niveles = [clave],
        arbol = valores.map((v) => EtiquetaEnJerarquia(v, [])).toList();*/

  List<Etiqueta> getEtiquetasDeNivel(String nivel, List<String> ruta) {
    var subArbol = arbol;
    for (final valor in ruta) {
      subArbol = subArbol.firstWhere((e) => e.valor == valor).children;
    }
    return subArbol.map((e) => Etiqueta(nivel, e.valor)).toList();
  }

  List<Etiqueta> getTodasLasEtiquetas() {
    return _recorrerJerarquia(arbol, 0).toList();
  }

  Iterable<Etiqueta> _recorrerJerarquia(
      List<EtiquetaEnJerarquia> subArbol, int nivel) sync* {
    for (var etiqueta in subArbol) {
      yield (Etiqueta(niveles[nivel], etiqueta.valor));
      yield* _recorrerJerarquia(etiqueta.children, nivel + 1);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'niveles': niveles,
      'arbol': arbol.map((x) => x.toMap()).toList(),
    };
  }

  factory Jerarquia.fromMap(Map<String, dynamic> map, {required bool esLocal}) {
    return Jerarquia(
      niveles: List<String>.from(map['niveles']),
      arbol: List<EtiquetaEnJerarquia>.from(
          map['arbol'].map((x) => EtiquetaEnJerarquia.fromMap(x))),
      esLocal: esLocal,
    );
  }

  String toJson() => json.encode(toMap());
}
