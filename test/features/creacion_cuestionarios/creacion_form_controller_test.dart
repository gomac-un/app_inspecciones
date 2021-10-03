import 'package:inspecciones/features/creacion_cuestionarios/creacion_controls.dart';
import 'package:inspecciones/features/creacion_cuestionarios/creacion_form_controller.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'creacion_form_controller_test.mocks.dart';

@GenerateMocks(
  [CuestionariosRepository],
)
void main() {
  late MockCuestionariosRepository repository;
  late CreacionFormController controller;

  setUp(() async {
    repository = MockCuestionariosRepository();
    final lista = [1, 2, 3];
    final sistemas = lista
        .map((element) => Sistema(id: element, nombre: 'Sistema $element'))
        .toList();
    when(repository.getTiposDeInspecciones()).thenAnswer((_) async => []);
    when(repository.getModelos()).thenAnswer((_) async => ['mod 1', 'mod 2']);
    when(repository.getContratistas()).thenAnswer((_) async => []);
    when(repository.getSistemas()).thenAnswer((_) async => []);
    when(repository.getSubSistemas(sistemas[0])).thenAnswer((_) async => []);
    controller = await CreacionFormController.create(repository, null);
  });

  test('can create a creacion_form_controller', () {
    //assert
    expect(controller, isA<CreacionFormController>());
  });
  test(
      'cuando es cuestionario nuevo el formulario se deberia cargar con 1 solo CreadorTituloController',
      () async {
    //act
    final bloques = controller.controllersBloques;
    final primerBloque = controller.controllersBloques.first;
    //assert
    expect(bloques.length, 1);
    expect(primerBloque, isA<CreadorTituloController>());
  });

  test(
      'agregarBloqueDespuesDe debe agregar un control nuevo a los bloques del CreacionFormController después del bloque indicado',
      () async {
    //arrange
    final lengthInitial = controller.controllersBloques.length;
    final despuesDe = controller.controllersBloques.last;
    final despuesDeIndex = controller.controllersBloques.indexOf(despuesDe);
    final nuevoBloque = CreadorPreguntaController(repository, null, null);
    //act
    controller.agregarBloqueDespuesDe(
        bloque: nuevoBloque, despuesDe: despuesDe);

    //assert
    //Agregó el nuevo bloque
    expect(controller.controllersBloques.length, lengthInitial + 1);
    // Lo agregó después del indicado.
    expect(
        controller.controllersBloques.indexOf(nuevoBloque), despuesDeIndex + 1);
  });
  // Esto solo ocurre cuando se crea el cuestionario y el único bloque que hay es el inicial.
  //Si se agrega un bloque, permite borrarlo, pero este caso no se da porque desde la interfaz se maneja que el primer
  //bloque no se pueda borrar.
  test(
      'borrarBloque(bloque) puede eliminar el primer bloque aunque en la UI no se permita',
      () async {
    final bloqDelete = controller.controllersBloques.first;
    //act
    controller.borrarBloque(bloqDelete);
    //assert
    /* expect(borrarBloque, throwsException); */
  });
  test(
      'borrarBloque(bloque) elimina bloque de CreacionFormController.controllerBloques',
      () {
    // Se agrega un bloque porque no permite eliminar el inicial
    final despuesDe = controller.controllersBloques.last;
    final nuevoBloque = CreadorPreguntaController(repository, null, null);
    controller.agregarBloqueDespuesDe(
        bloque: nuevoBloque, despuesDe: despuesDe);
    expect(controller.controllersBloques.contains(nuevoBloque), isTrue);
    //act
    controller.borrarBloque(nuevoBloque);
    //assert
    expect(controller.controllersBloques.contains(nuevoBloque), isFalse);
  });

  test('campo tipoDeInspeccion es obligatorio', () {
    controller.tipoDeInspeccionControl.value = null;
    expect(controller.tipoDeInspeccionControl.valid, isFalse);
  });

  test('lista de modelos del cuestionario no puede estar vacía', () {
    controller.modelosControl.value = [];
    expect(controller.modelosControl.hasError('minLength'), isTrue);
  });
  test(
      'cuando se selecciona "Otra" en tipo de inspección el campo "nuevo tipo de inspección es obligatorio',
      () async {
    final controller = await CreacionFormController.create(repository, null);
    controller.tipoDeInspeccionControl.value =
        CreacionFormController.otroTipoDeInspeccion;
    controller.nuevoTipoDeInspeccionControl.value = '';
    expect(controller.nuevoTipoDeInspeccionControl.valid, isFalse);
  });
}
