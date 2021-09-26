import 'package:flutter_test/flutter_test.dart';
import 'package:inspecciones/infrastructure/datasources/remote_datasource.dart';

void main() {
  test('se puede instanciar LoginDjangoJsonAPI', () {
    final myAPIUri = Uri();
    final LoginDjangoJsonAPI datasource = LoginDjangoJsonAPI(myAPIUri);
  });
  test('se puede instanciar LogedInDjangoJsonAPI', () {
    final myAPIUri = Uri();
    final LogedInDjangoJsonAPI datasource =
        LogedInDjangoJsonAPI(myAPIUri, user);
  });
}
