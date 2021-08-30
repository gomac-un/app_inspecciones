@Skip('depende de cosas que no compilan')

import 'package:inspecciones/features/creacion_cuestionarios/creacion_form_controller.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

import 'creacion_form_controller_test.mocks.dart';

@GenerateMocks([CuestionariosRepository])
void main() {
  test('can create a creacion_form_controller', () async {
    final repository = MockCuestionariosRepository();
    final controller = await CreacionFormController.create(repository, null);
    expect(controller, isA<CreacionFormController>());
  });
}
