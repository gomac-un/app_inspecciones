import 'package:drift/drift.dart';
import 'package:inspecciones/features/creacion_cuestionarios/creacion_controls.dart';
import 'package:inspecciones/features/creacion_cuestionarios/creacion_form_controller.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:test/test.dart';

import 'creacion_form_controller_test.mocks.dart';

bool hasErrorRequired(
  FormControl control,
  dynamic valor,
) {
  control.value = valor;
  return control.hasError(ValidationMessage.required);
}

bool agregarBloque(
    CreacionFormController controller, CreacionController nuevoBloque) {
  controller.agregarBloqueDespuesDe(
      bloque: nuevoBloque, despuesDe: controller.controllersBloques.last);

  return controller.controllersBloques.contains(nuevoBloque);
}

void expectEsIgual(
    PreguntasCompanion datosIniciales, PreguntasCompanion pregunta) {
  expect(pregunta.titulo.value, datosIniciales.titulo.value);
  expect(pregunta.criticidad.value, datosIniciales.criticidad.value);
}

void expectAgregar(
  CreacionController bloque,
  List<CreacionController> controllers,
  FormArray<Map<String, dynamic>> control,
) {
  expect(controllers.isEmpty, isFalse);
  expect(control.value!.first, controllers.first.control.value);
}

void expectBorrar(
    CreacionController bloqueBorrado,
    List<CreacionController> controllers,
    FormArray<Map<String, dynamic>> control) {
  expect(controllers.contains(bloqueBorrado), isFalse);
  expect(control.value!.contains(bloqueBorrado.control.value), isFalse);
}

void main() {
  late MockCuestionariosRepository repository;
  late List<Sistema> sistemas;
  late List<SubSistema> subSistemas;
  late CreacionFormController controller;
  late PreguntasCompanion datosIniciales;

  setUp(() async {
    repository = MockCuestionariosRepository();
    /* controller = await CreacionFormController.create(repository, null); */
    final lista = [1, 2, 3];
    sistemas = lista
        .map((element) => Sistema(id: element, nombre: 'Sistema $element'))
        .toList();
    subSistemas = [1, 1, 2, 3]
        .map((element) => SubSistema(
            id: element, nombre: 'subsistema $element', sistemaId: element))
        .toList();
    when(repository.getTiposDeInspecciones()).thenAnswer((_) async => []);
    when(repository.getModelos()).thenAnswer((_) async => ['mod 1', 'mod 2']);
    when(repository.getContratistas()).thenAnswer((_) async => []);
    when(repository.getSistemas()).thenAnswer((_) async => []);
    when(repository.getSubSistemas(sistemas[0])).thenAnswer((_) async =>
        subSistemas.where((element) => element.sistemaId == 1).toList());

    controller = await CreacionFormController.create(repository, null);
    datosIniciales = const PreguntasCompanion(
      id: Value(1),
      titulo: Value('pregunta 1'),
      criticidad: Value(0),
    );
  });

  group('Validators de los campos generales a todas las preguntas:', () {
    late CamposGeneralesPreguntaController camposGenerales;
    CamposGeneralesPreguntaController obtenerPregunta(
      bool parteDeCuadricula,
    ) =>
        CamposGeneralesPreguntaController(
          repository,
          null,
          null,
          tituloInicial: datosIniciales.titulo,
          descripcionInicial: datosIniciales.descripcion,
          ejeInicial: datosIniciales.eje,
          ladoInicial: datosIniciales.lado,
          posicionZInicial: datosIniciales.posicionZ,
          tipoIncial: datosIniciales.tipo,
          parteDeCuadricula: parteDeCuadricula,
        );
    setUp(() {
      camposGenerales = obtenerPregunta(false);
    });
    test('titulo de pregunta requerido', () {
      expect(hasErrorRequired(camposGenerales.tituloControl, ''), isTrue);
    });

    test('descripción de la pregunta no es requerido', () {
      expect(hasErrorRequired(camposGenerales.descripcionControl, ''), isFalse);
    });

    test('eje de la pregunta es requerido', () {
      expect(hasErrorRequired(camposGenerales.ejeControl, ''), isTrue);
    });
    test('lado de la pregunta es requerido', () {
      expect(hasErrorRequired(camposGenerales.ladoControl, ''), isTrue);
    });
    test('posicionZ de la pregunta es requerida', () {
      expect(hasErrorRequired(camposGenerales.posicionZControl, ''), isTrue);
    });
    test('campo tipo de pregunta requerida para las preguntas de selección',
        () {
      expect(hasErrorRequired(camposGenerales.tipoDePreguntaControl, null),
          isTrue);
    });
    test('campo tipo de pregunta NO requerida para las preguntas de cuadricula',
        () {
      final camposGenerales = obtenerPregunta(true);
      expect(hasErrorRequired(camposGenerales.tipoDePreguntaControl, null),
          isFalse);
    });
    test('campo sistema de la pregunta es requerido', () {
      expect(hasErrorRequired(camposGenerales.sistemaControl, null), isTrue);
    });

    test('campo subsistema de la pregunta es requerido', () {
      final camposGenerales = obtenerPregunta(true);
      expect(hasErrorRequired(camposGenerales.subSistemaControl, null), isTrue);
    });

    test('subsistemas cargan de acuerdo al sistema elegido', () async {
      camposGenerales.sistemaControl.value = sistemas[0];

      final subSistemasDisponibles = [1, 1]
          .map((element) => SubSistema(
              id: element, nombre: 'subsistema $element', sistemaId: element))
          .toList();
      // Se debe agregar porque no se estaba esperando el futuro de getSubsistemas,
      await Future.delayed(const Duration(milliseconds: 600));
      expect(
          camposGenerales.subSistemasDisponibles.value, subSistemasDisponibles);
    });
  });
  group('opciones de respuesta', () {
    late CreadorRespuestaController respuesta;
    setUp(() {
      respuesta = CreadorRespuestaController();
    });
    test('texto de la respuesta es obligatorio', () {
      expect(hasErrorRequired(respuesta.textoControl, ''), isTrue);
    });
    test(
        'copy devuelve otro CreadorRespuestaController con los mismos datos de la original sin referencias unicas',
        () {
      respuesta.textoControl.value = 'Hola';
      final respuestaCopiada = respuesta.copy();
      expect(respuestaCopiada.textoControl.value, respuesta.textoControl.value);
      expect(respuestaCopiada, isA<CreadorRespuestaController>());
    });

    test(
        'toDb devuelve otro OpcionesDeRespuestaCompanion con los datos introducidos en el form',
        () {
      respuesta.textoControl.value = 'Hola';
      final toDb = respuesta.toDB();
      expect(toDb.texto.value, respuesta.textoControl.value);
      expect(toDb, isA<OpcionesDeRespuestaCompanion>());
    });
  });
  group('Preguntas de selección', () {
    late CreadorPreguntaController pregunta;
    setUp(() {
      pregunta = CreadorPreguntaController(repository, null, null);
    });
    test(
        'se puede agregar una nueva pregunta de selección a los bloques del cuestionario',
        () {
      expect(agregarBloque(controller, pregunta), isTrue);
    });
    test('se puede agregar una pregunta de selección con datos iniciales', () {
      final pregunta = CreadorPreguntaController(repository, null, null,
          datosIniciales: PreguntaConOpcionesDeRespuestaCompanion(
              datosIniciales, const []));
      expect(
          pregunta.datosIniciales.pregunta.id.value, datosIniciales.id.value);
      expectEsIgual(datosIniciales, pregunta.datosIniciales.pregunta);
    });
    test(
        'agregarRespuesta debería agregar un CreadorRespuestaController a los controllersRespuestas de la pregunta',
        () {
      pregunta.agregarRespuesta();
      expectAgregar(
          pregunta, pregunta.controllersRespuestas, pregunta.respuestasControl);
      expect(pregunta.controllersRespuestas.first,
          isA<CreadorRespuestaController>());
    });
    test(
        'borrarRespuesta(c) debería eliminar c de [controllersRespuestas] y [respuestasControl] de la pregunta',
        () {
      pregunta.agregarRespuesta();
      // La que se acaba de agragar.
      final respuestaABorrar = pregunta.controllersRespuestas.last;
      pregunta.borrarRespuesta(respuestaABorrar);
      expectBorrar(respuestaABorrar, pregunta.controllersRespuestas,
          pregunta.respuestasControl);
    });
    test(
        'copy devuelve un creadorPreguntaController con datos ya introducidos y sin referencias únicas (id,bloqueId)',
        () {
      pregunta = CreadorPreguntaController(repository, null, null,
          datosIniciales: PreguntaConOpcionesDeRespuestaCompanion(
              datosIniciales, const []));
      final preguntaCopiada = pregunta.copy();
      //en datosIniciales, la pregunta tiene id, al copiarla no debe tenerlo.
      expect(preguntaCopiada.datosIniciales.pregunta.id, const Value.absent());
      //Los datos de la primera pregunta son iguales a la de la copiada.
      expectEsIgual(pregunta.datosIniciales.pregunta,
          preguntaCopiada.datosIniciales.pregunta);
    });
    test(
        'toDB() devuelve PreguntaConOpcionesDeRespuestaCompanion con datos introducidos',
        () {
      pregunta.controllerCamposGenerales.tituloControl.value = 'Titulo 1';
      final toDB = pregunta.toDB();
      expect(pregunta.controllerCamposGenerales.tituloControl.value!,
          toDB.pregunta.titulo.value);
      expect(toDB, isA<PreguntaConOpcionesDeRespuestaCompanion>());
    });
  });
  group('criticidades numericas', () {
    late CreadorCriticidadesNumericasController criticidad;
    setUp(() {
      criticidad = CreadorCriticidadesNumericasController();
    });
    test('valor minimo es obligatorio', () {
      expect(hasErrorRequired(criticidad.minimoControl, null), isTrue);
    });
    test('valor maximo es obligatorio', () {
      expect(hasErrorRequired(criticidad.maximoControl, null), isTrue);
    });
    test(
        'maximoControl tiene error "verificarRango" cuando su valor es menor que el valor de minimoControl',
        () {
      criticidad.minimoControl.value = 10;
      criticidad.maximoControl.value = 5;
      expect(criticidad.maximoControl.hasError('verificarRango'), isTrue);
    });
  });
  group('Preguntas numéricas', () {
    late CreadorPreguntaNumericaController pregunta;
    setUp(() async {
      pregunta = CreadorPreguntaNumericaController(repository, null, null);
    });
    test(
        'se puede agregar nueva pregunta numérica a los bloques del cuestionario',
        () {
      expect(agregarBloque(controller, pregunta), isTrue);
    });
    test('se puede agregar una pregunta de selección con datos iniciales', () {
      final pregunta = CreadorPreguntaNumericaController(repository, null, null,
          datosIniciales: PreguntaNumericaCompanion(datosIniciales, const []));
      expect(
          pregunta.datosIniciales.pregunta.id.value, datosIniciales.id.value);
      expectEsIgual(datosIniciales, pregunta.datosIniciales.pregunta);
    });
    test(
        'agregarCriticidad debería agregar un CreadorCriticidadesNumericasController a los controles de criticidad de la pregunta',
        () {
      pregunta.agregarCriticidad();
      expectAgregar(pregunta, pregunta.controllersCriticidades,
          pregunta.criticidadesControl);
      expect(pregunta.controllersCriticidades.first,
          isA<CreadorCriticidadesNumericasController>());
    });
    test(
        'borrarCriticidad(c) debería eliminar c de los controles de criticidad de la pregunta',
        () {
      pregunta.agregarCriticidad();
      final criticidad = pregunta.controllersCriticidades.last;
      pregunta.borrarCriticidad(criticidad);
      expectBorrar(criticidad, pregunta.controllersCriticidades,
          pregunta.criticidadesControl);
    });
    test(
        'copy devuelve un creadorPreguntaNumericaController con datos ya introducidos y sin referencias únicas (id,bloqueId)',
        () {
      final pregunta = CreadorPreguntaNumericaController(repository, null, null,
          datosIniciales: PreguntaNumericaCompanion(datosIniciales, const []));
      final preguntaCopiada = pregunta.copy();
      //en datosIniciales, la pregunta tiene id, al copiarla no debe tenerlo.
      expect(preguntaCopiada.datosIniciales.pregunta.id, const Value.absent());
      //Los datos de la primera pregunta son iguales a la de la copiada.
      expectEsIgual(pregunta.datosIniciales.pregunta,
          preguntaCopiada.datosIniciales.pregunta);
    });
    test('toDB() devuelve PreguntaNumericaCompanion con datos introducidos',
        () {
      pregunta.controllerCamposGenerales.tituloControl.value = 'Titulo 1';
      final toDB = pregunta.toDB();
      expect(pregunta.controllerCamposGenerales.tituloControl.value!,
          toDB.pregunta.titulo.value);
      expect(toDB, isA<PreguntaNumericaCompanion>());
    });
  });

  group('Preguntas de tipo cuadricula', () {
    late CreadorPreguntaCuadriculaController bloque;

    setUp(() {
      //Está fallando porque el constructor accede al primer elemento de las preguntas de los datos iniciales,
      // pero cuando no se le envían o se le envía una lista vacía de preguntas lanza error BadState: no element.
      // ¿Agregar cuadriculas con una pregunta por defecto?
      bloque = CreadorPreguntaCuadriculaController(repository, null, null);
    });
    test('Se puede agregar una nueva cuadricula a los bloques del cuestionario',
        () {
      expect(agregarBloque(controller, bloque), isTrue);
    });
    test('se puede cargar una cuadricula con datos iniciales', () {
      //En este caso los datos iniciales es el titulo de la cuadricula
      const datosIniciales =
          CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
              CuadriculasDePreguntasCompanion(titulo: Value('Cuadricula 1')),
              [],
              []);
      final cuadricula = CreadorPreguntaCuadriculaController(
          repository, null, null,
          datosIniciales: datosIniciales);
      controller.agregarBloqueDespuesDe(
          bloque: cuadricula, despuesDe: controller.controllersBloques.last);
      final cuadriculaAgregada = controller.controllersBloques.last
          as CreadorPreguntaCuadriculaController;
      //assert
      expect(cuadriculaAgregada.datosIniciales.cuadricula.titulo.value,
          datosIniciales.cuadricula.titulo.value);
    });
    test(
        'agregarPregunta debería agregar una pregunta al control pregunta de la cuadricula con el sistema por defecto de la cuadricua',
        () {
      bloque = CreadorPreguntaCuadriculaController(
          repository, sistemas[0], subSistemas[0]);
      bloque.agregarPregunta();
      expectAgregar(
          bloque, bloque.controllersPreguntas, bloque.preguntasControl);
      expect(
          bloque.controllersPreguntas.first, isA<CreadorPreguntaController>());
      expect(
          bloque.controllersPreguntas.first.controllerCamposGenerales
              .sistemaControl.value,
          sistemas[0]);
      expect(
          bloque.controllersPreguntas.first.controllerCamposGenerales
              .subSistemaControl.value,
          subSistemas[0]);
    });
    test(
        'agregarRespuesta debería agregar un CreadorRespuestaController a los controllersRespuestas de la cuadricula',
        () {
      bloque.agregarRespuesta();
      expectAgregar(
          bloque, bloque.controllersRespuestas, bloque.respuestasControl);
      expect(bloque.controllersRespuestas.first,
          isA<CreadorRespuestaController>());
    });
    test(
        'borrarRespuesta(c) debería eliminar c de [controllersRespuestas] y [respuestasControl] de la cuadricula',
        () {
      bloque.agregarRespuesta();
      // La que se acaba de agragar.
      final respuestaABorrar = bloque.controllersRespuestas.last;
      bloque.borrarRespuesta(respuestaABorrar);
      expectBorrar(respuestaABorrar, bloque.controllersRespuestas,
          bloque.respuestasControl);
    });
  });
}
