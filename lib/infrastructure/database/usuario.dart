class Usuario {
  String documento;
  var contrasena;
  var isContratista;
  Usuario(this.documento, this.contrasena, this.isContratista);

  static List getUsers(){
    return [Usuario('1000','inspec',false),Usuario('1013','admin',true)];
  }
}




