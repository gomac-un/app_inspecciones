@Skip('depende de que todos los modulos registrados compilen')

import 'package:inspecciones/injection.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:test/test.dart';

void main() {
  test('getIt debería registrar una dependencia de terceros', () async {
    final getIt = await configureDependencies();
    expect(
        getIt<InternetConnectionChecker>(), isA<InternetConnectionChecker>());
  });
}
