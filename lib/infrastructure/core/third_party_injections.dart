import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:inspecciones/application/auth/usuario.dart';

@module
abstract class ThirdPartyInjections {
  http.Client get client => http.Client();
  DataConnectionChecker get dataConnectionChecker => DataConnectionChecker();
}
/*
@module
abstract class UsuarioInjection {

  Usuario get usuario => DataConnectionChecker();
}
*/
