import 'package:drift/drift.dart';
import 'package:inspecciones/features/creacion_cuestionarios/creacion_controls.dart';
import 'package:inspecciones/features/creacion_cuestionarios/creacion_form_controller.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:test/test.dart';

import 'creacion_controllers_test.mocks.dart';

bool hasErrorRequired<T>(
  FormControl<T> control,
  T valor,
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

@GenerateMocks(
  [CuestionariosRepository],
)
void main() {
  late CuestionariosRepository repository;
  late CreacionFormController controller;
  late PreguntasCompanion datosIniciales;

  setUp(() async {
    /*container = ProviderContainer(overrides: []);
    repository = CuestionariosRepository(container.read);*/
    //repository = CuestionariosRepositoryMock();

    repository = MockCuestionariosRepository();
    when(repository.getTiposDeInspecciones()).thenAnswer((_) async => []);
    when(repository.getEtiquetas()).thenAnswer(
        (_) async => [EtiquetaDeActivo(id: 1, clave: "clave", valor: "valor")]);

    controller = await CreacionFormController.create(repository, null);
    datosIniciales = const PreguntasCompanion(
      id: Value("1"),
      titulo: Value('pregunta 1'),
      criticidad: Value(0),
      tipoDePregunta: Value(TipoDePregunta.seleccionUnica),
    );
  });

  group('Validators de los campos generales a todas las preguntas:', () {
    late CamposGeneralesPreguntaController camposGenerales;
    final Value<List<EtiquetasDePreguntaCompanion>> etiquetasIniciales = Value(
        [EtiquetasDePreguntaCompanion.insert(clave: "clave", valor: "valor")]);

    CamposGeneralesPreguntaController obtenerPregunta(
      bool parteDeCuadricula,
    ) =>
        CamposGeneralesPreguntaController(
          tituloInicial: datosIniciales.titulo,
          descripcionInicial: datosIniciales.descripcion,
          etiquetasIniciales: etiquetasIniciales,
          tipoInicial: datosIniciales.tipoDePregunta,
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

    test('etiquetas no es requerido', () {
      expect(hasErrorRequired(camposGenerales.etiquetasControl, <String>{}),
          isFalse);
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
    group('opciones de respuesta', () {
      late CreadorRespuestaController controllerRespuesta;
      setUp(() {
        controllerRespuesta = CreadorRespuestaController();
      });
      test('texto de la respuesta es obligatorio', () {
        expect(hasErrorRequired(controllerRespuesta.tituloControl, ''), isTrue);
      });
      test(
          '''copy devuelve otro CreadorRespuestaController con los mismos datos de 
        la original sin referencias unicas''', () {
        controllerRespuesta.tituloControl.value = 'Hola';
        final respuestaCopiada = controllerRespuesta.copy();
        expect(
            respuestaCopiada,
            isA<CreadorRespuestaController>().having(
                (r) => r.tituloControl.value,
                "titulo",
                controllerRespuesta.tituloControl.value));
      });

      test(
          'toDb devuelve otro OpcionesDeRespuestaCompanion con los datos introducidos en el form',
          () {
        controllerRespuesta.tituloControl.value = 'hola';
        controllerRespuesta.descripcionControl.value = 'mundo';

        final toDb = controllerRespuesta.toDB();

        expect(
            toDb,
            isA<OpcionesDeRespuestaCompanion>()
                .having((r) => r.titulo.value, "titulo", 'hola')
                .having((r) => r.descripcion.value, "descripcion", 'mundo'));
      });
    });
    group('Preguntas de selección', () {
      late CreadorPreguntaController pregunta;
      setUp(() {
        pregunta = CreadorPreguntaController(repository);
      });
      test(
          'se puede agregar una nueva pregunta de selección a los bloques del cuestionario',
          () {
        expect(agregarBloque(controller, pregunta), isTrue);
      });
      test('se puede agregar una pregunta de selección con datos iniciales',
          () {
        final pregunta = CreadorPreguntaController(repository,
            datosIniciales: PreguntaConOpcionesDeRespuestaCompanion(
              datosIniciales,
              const [],
              const [],
            ));
        expect(
            pregunta.datosIniciales.pregunta.id.value, datosIniciales.id.value);
        expectEsIgual(datosIniciales, pregunta.datosIniciales.pregunta);
      });
      test('''agregarRespuesta debería agregar un CreadorRespuestaController a 
          los controllersRespuestas de la pregunta''', () {
        pregunta.agregarRespuesta();
        expectAgregar(pregunta, pregunta.controllersRespuestas,
            pregunta.respuestasControl);
        expect(pregunta.controllersRespuestas.first,
            isA<CreadorRespuestaController>());
      });
      test(
          '''borrarRespuesta(c) debería eliminar c de [controllersRespuestas] y 
          [respuestasControl] de la pregunta''', () {
        pregunta.agregarRespuesta();
        // La que se acaba de agragar.
        final respuestaABorrar = pregunta.controllersRespuestas.last;
        pregunta.borrarRespuesta(respuestaABorrar);
        expectBorrar(respuestaABorrar, pregunta.controllersRespuestas,
            pregunta.respuestasControl);
      });
      test('''copy devuelve un creadorPreguntaController con datos ya 
          introducidos y sin referencias únicas (id,bloqueId)''', () {
        pregunta = CreadorPreguntaController(repository,
            datosIniciales: PreguntaConOpcionesDeRespuestaCompanion(
                datosIniciales, const [], const []));
        final preguntaCopiada = pregunta.copy();
        //en datosIniciales, la pregunta tiene id, al copiarla no debe tenerlo.
        expect(
            preguntaCopiada.datosIniciales.pregunta.id, const Value.absent());
        //Los datos de la primera pregunta son iguales a la de la copiada.
        expectEsIgual(pregunta.datosIniciales.pregunta,
            preguntaCopiada.datosIniciales.pregunta);
      });
      test('''toDB() devuelve PreguntaConOpcionesDeRespuestaCompanion con datos 
          introducidos''', () {
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
        pregunta = CreadorPreguntaNumericaController(repository);
      });
      test(
          'se puede agregar nueva pregunta numérica a los bloques del cuestionario',
          () {
        expect(agregarBloque(controller, pregunta), isTrue);
      });
      test('se puede agregar una pregunta de selección con datos iniciales',
          () {
        final pregunta = CreadorPreguntaNumericaController(repository,
            datosIniciales:
                PreguntaNumericaCompanion(datosIniciales, const [], const []));
        expect(
            pregunta.datosIniciales.pregunta.id.value, datosIniciales.id.value);
        expectEsIgual(datosIniciales, pregunta.datosIniciales.pregunta);
      });
      test('''agregarCriticidad debería agregar un 
          CreadorCriticidadesNumericasController a los controles de criticidad 
          de la pregunta''', () {
        pregunta.agregarCriticidad();
        expectAgregar(pregunta, pregunta.controllersCriticidades,
            pregunta.criticidadesControl);
        expect(pregunta.controllersCriticidades.first,
            isA<CreadorCriticidadesNumericasController>());
      });
      test('''borrarCriticidad(c) debería eliminar c de los controles de 
          criticidad de la pregunta''', () {
        pregunta.agregarCriticidad();
        final criticidad = pregunta.controllersCriticidades.last;
        pregunta.borrarCriticidad(criticidad);
        expectBorrar(criticidad, pregunta.controllersCriticidades,
            pregunta.criticidadesControl);
      });
      test('''copy devuelve un creadorPreguntaNumericaController con datos ya 
          introducidos y sin referencias únicas (id,bloqueId)''', () {
        final pregunta = CreadorPreguntaNumericaController(repository,
            datosIniciales:
                PreguntaNumericaCompanion(datosIniciales, const [], const []));
        final preguntaCopiada = pregunta.copy();
        //en datosIniciales, la pregunta tiene id, al copiarla no debe tenerlo.
        expect(
            preguntaCopiada.datosIniciales.pregunta.id, const Value.absent());
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
        bloque = CreadorPreguntaCuadriculaController(repository);
      });
      test(
          'Se puede agregar una nueva cuadricula a los bloques del cuestionario',
          () {
        expect(agregarBloque(controller, bloque), isTrue);
      });
      test('se puede cargar una cuadricula con datos iniciales', () {
        //En este caso los datos iniciales es el titulo de la cuadricula
        final datosIniciales1 =
            CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
                PreguntaConOpcionesDeRespuestaCompanion(
                    datosIniciales, const [], const []),
                const []);
        final cuadricula = CreadorPreguntaCuadriculaController(repository,
            datosIniciales: datosIniciales1);
        controller.agregarBloqueDespuesDe(
            bloque: cuadricula, despuesDe: controller.controllersBloques.last);
        final cuadriculaAgregada = controller.controllersBloques.last
            as CreadorPreguntaCuadriculaController;
        //assert
        expect(
            cuadriculaAgregada.datosIniciales.cuadricula.pregunta.titulo.value,
            datosIniciales.titulo.value);
      });
      test('''agregarRespuesta debería agregar un CreadorRespuestaController a 
          los controllersRespuestas de la cuadricula''', () {
        bloque.agregarRespuesta();
        expectAgregar(
            bloque, bloque.controllersRespuestas, bloque.respuestasControl);
        expect(bloque.controllersRespuestas.first,
            isA<CreadorRespuestaController>());
      });
      test(
          '''borrarRespuesta(c) debería eliminar c de [controllersRespuestas] y 
          [respuestasControl] de la cuadricula''', () {
        bloque.agregarRespuesta();
        // La que se acaba de agragar.
        final respuestaABorrar = bloque.controllersRespuestas.last;
        bloque.borrarRespuesta(respuestaABorrar);
        expectBorrar(respuestaABorrar, bloque.controllersRespuestas,
            bloque.respuestasControl);
      });
    });
  });
}
