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
  final List<Etiqueta> etiquetas;

  ActivoEnLista(this.id, this.etiquetas);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'etiquetas': etiquetas.map((x) => x.toMap()).toList(),
    };
  }

  factory ActivoEnLista.fromMap(Map<String, dynamic> map) {
    return ActivoEnLista(
      map['id'],
      (map['etiquetas'] as List).map((x) => Etiqueta.fromMap(x)).toList(),
    );
  }
}

class Etiqueta {
  final String clave;
  final String valor;

  Etiqueta(this.clave, this.valor);

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
}
