import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'llenado_dao_test.mocks.dart';

@GenerateMocks(
  [Database],
)
void main() {
  setUp(() async {
    MockDatabase db = MockDatabase();
  });

  test('cualquier cosa', () {});
}
