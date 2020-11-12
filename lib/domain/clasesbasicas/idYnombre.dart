class IdYNombre {
  final int id;
  final String nombre;

  IdYNombre(this.id, this.nombre);

  @override
  String toString() {
    // TODO: implement toString
    return nombre;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
      };
}
/*
class TipoDeInspeccion extends IdYNombre {
  
}

class Modelo extends IdYNombre {

}

class Contratista extends IdYNombre {}

class Sistema extends IdYNombre {}

class Subsistema extends IdYNombre {}
*/
