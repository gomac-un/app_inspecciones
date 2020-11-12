import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

@module
abstract class ThirdPartyInjections {
  http.Client get client => http.Client();
  DataConnectionChecker get dataConnectionChecker => DataConnectionChecker();
}
