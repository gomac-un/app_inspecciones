import 'package:dartz/dartz.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:moor/moor.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'creacion_controls.dart';
import 'creacion_validators.dart';

final cuestionarioIdProvider = Provider<int?>((ref) => throw Exception(
    "se debe definir cuestionarioId dentro de la pagina de creacion"));

final creacionFormControllerFutureProvider = FutureProvider(
  (ref) => CreacionFormController.create(
    ref.watch(cuestionariosRepositoryProvider),
    ref.watch(cuestionarioIdProvider),
  ),
);

final creacionFormControllerProvider =
    Provider((ref) => ref.watch(creacionFormControllerFutureProvider).when(
          data: id,
          loading: () => throw Exception(
              "creacionFormControllerFutureProvider no se ha cargado"),
          error: (e, s) => throw e,
        ));

class CreacionFormController {
  final CuestionariosRepository repository;

  ///constantes
  static const otroTipoDeInspeccion = "Otra";
  static const todosLosModelosValue = "Todos";

  /// información usada para inicializar los campos en caso de que sea una edición
  final CuestionarioConContratistaYModelosCompanion datosIniciales;

  /// inicialización de los campos del cuestionario usando los valores guardados
  /// en caso de que sea una edicion y si es uno nuevo se definen valores por defecto
  late final tipoDeInspeccionControl = fb.control<String>(
    datosIniciales.cuestionario.tipoDeInspeccion.valueOrDefault(''),
    [Validators.required],
  );
  late final nuevoTipoDeInspeccionControl = fb.control<String>('');
  late final contratistaControl = fb.control<Contratista?>(
    datosIniciales.contratista,
    [Validators.required],
  );
  late final periodicidadControl = fb.control<double>(
    //Test genera error cuando esta lista está vacía.
    datosIniciales.cuestionarioDeModelo.isNotEmpty
        ? datosIniciales.cuestionarioDeModelo.first.periodicidad
            .valueOrDefault(0)
            .toDouble()
        : 0,
    [Validators.required],
  );
  late final modelosControl = fb.control<List<String>>(
    datosIniciales.cuestionarioDeModelo.map((e) {
      if (!e.modelo.present) {
        throw Exception(
            'El cuestionario ${datosIniciales.cuestionario.id} tiene un modelo inválido');
      }
      return e.modelo.value;
    }).toList(),
    [Validators.minLength(1)],
  );

  /// controllers que tienen asociado cada uno de los bloques del formulario
  final List<CreacionController> controllersBloques;

  /// FormArray con todos los bloques (preguntas,cuadriculas y titulos) que se agregan al cuestionario
  late final bloquesControl =
      FormArray(controllersBloques.map((e) => e.control).toList());

  /// Formgroup que agrupa todos los controles del formulario
  late final control = FormGroup(
    {
      'tipoDeInspeccion': tipoDeInspeccionControl,
      'nuevoTipoDeInspeccion': nuevoTipoDeInspeccionControl,
      'contratista': contratistaControl,
      'periodicidad': periodicidadControl,
      'modelos': modelosControl,
      'bloques': bloquesControl,
    },
    asyncValidators: [
      cuestionariosExistentes(
        datosIniciales.cuestionario.id.present
            ? datosIniciales.cuestionario.id.value
            : null,
        tipoDeInspeccionControl,
        modelosControl,
        repository,
      )
    ],
    validators: [
      nuevoTipoDeInspeccionValidator(
          tipoDeInspeccionControl, nuevoTipoDeInspeccionControl)
    ],
  );

  /// Informacion traida desde la base de datos
  final List<Sistema> todosLosSistemas;
  final List<String> todosLosTiposDeInspeccion;
  final List<String> todosLosModelos;
  final List<Contratista> todosLosContratistas;

  /// Si cuestionario es nuevo, se le asigna borrador.
  late final estado = EnumToString.fromString(
      EstadoDeCuestionario.values,
      datosIniciales.cuestionario.tipoDeInspeccion.valueOrDefault(
          EnumToString.convertToString(EstadoDeCuestionario.borrador)));

  /// Se modifica cuando se copia un bloque desde creacion_controls.dart
  CreacionController? bloqueCopiado;

  /// TODO: evitar quemar estos valores
  final ejes = [
    "Primer eje",
    "Segundo eje",
    "Tercer eje",
    "Entre primer y segundo eje",
    "Entre segundo y tercer eje",
    "Adelante",
    "Atrás"
  ];
  final lados = [
    'Izquierda',
    'Centro',
    'Derecha',
  ];
  final posZ = ['Arriba', 'Medio', 'Abajo'];

  /// static factory que instancia un [CreacionFormController] de manera asíncrona
  /// ya que tiene que cargar información desde la base de datos
  static Future<CreacionFormController> create(
    CuestionariosRepository repository,
    int? cuestionarioId,
  ) async {
    final todosLosTiposDeInspeccion = await repository.getTiposDeInspecciones();

    /// Sirve para activar otro campo en el formulario, si se selecciona
    todosLosTiposDeInspeccion.add(otroTipoDeInspeccion);

    final todosLosModelos = await repository.getModelos();

    /// El modelo especial 'Todos' aplica a cualquier modelo
    todosLosModelos.add(todosLosModelosValue);

    final todosLosContratistas = await repository.getContratistas();
    final todosLosSistemas = await repository.getSistemas();

    if (cuestionarioId == null) {
      return CreacionFormController._(
        repository,
        todosLosContratistas,
        todosLosModelos,
        todosLosSistemas,
        todosLosTiposDeInspeccion,
        await _cargarBloques(repository, null, null),
        // para que retorne un bloque por defecto ya que es nuevo cuestionario
      );
    }

    /// Dereferenciadores del cuestionarioId, en caso de que llegue
    final datosIniciales =
        await repository.getModelosYContratista(cuestionarioId);

    final bloquesBD = await repository.cargarCuestionario(cuestionarioId);

    final controllersBloques = await _cargarBloques(
        repository, datosIniciales.cuestionario, bloquesBD);

    return CreacionFormController._(
      repository,
      todosLosContratistas,
      todosLosModelos,
      todosLosSistemas,
      todosLosTiposDeInspeccion,
      controllersBloques,
      datosIniciales: CuestionarioConContratistaYModelosCompanion.fromDataClass(
          datosIniciales),
    );
  }

  /// TODO: reducir el numero de argumentos agrupandolos de alguna manera
  CreacionFormController._(
    this.repository,
    this.todosLosContratistas,
    this.todosLosModelos,
    this.todosLosSistemas,
    this.todosLosTiposDeInspeccion,
    this.controllersBloques, {
    this.datosIniciales =
        const CuestionarioConContratistaYModelosCompanion.vacio(),
  });

  /// Carga los bloques del cuestionario
  ///
  /// El flujo es: desde la Bd se devuelve [bloquesBD] al invocar ([CreacionDao.cargarCuestionario()]),
  /// luego se recorren y dependiendo del tipo especifico de IBloqueOrdenable que sea, se devuelve el control correspondiente
  /// para que [ControlWidget] en creacion_card.dart pueda devolver la card adecuada para cada tipo
  static Future<List<CreacionController>> _cargarBloques(
      CuestionariosRepository repository,
      Cuestionario? cuestionario,
      List<IBloqueOrdenable>? bloquesBD) async {
    if (cuestionario == null || bloquesBD == null) {
      /// Si se está creando el cuestionario, se agrega un titulo por defecto como bloque inicial
      return [CreadorTituloController()];
    }

    /// Si es un cuestionario que ya existía y se va a editar
    ///Ordenamiento y creacion de los controles dependiendo del tipo de elemento
    return Stream.fromIterable((bloquesBD
          ..sort(
            (a, b) => a.nOrden.compareTo(b.nOrden),
          )))
        .asyncMap<CreacionController>((e) async {
      ///! aca pueden haber errores de tiempo de ejecucion si el bloque no tiene al
      ///menos una pregunta o si la primera no tiene sistemaId, aunque
      ///las validaciones de los controles deberían evitar que esto pase
      if (e is BloqueConTitulo) {
        return CreadorTituloController(e.titulo.toCompanion(true));
      }
      if (e is BloqueConPreguntaSimple) {
        return CreadorPreguntaController(
          repository,
          await repository.getSistemaPorId(e.pregunta.pregunta.sistemaId!),
          await repository
              .getSubSistemaPorId(e.pregunta.pregunta.subSistemaId!),
          datosIniciales:
              PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(e.pregunta),
        );
      }
      if (e is BloqueConCuadricula) {
        return CreadorPreguntaCuadriculaController(
          repository,
          await repository
              .getSistemaPorId(e.preguntas.first.pregunta.sistemaId!),
          await repository
              .getSubSistemaPorId(e.preguntas.first.pregunta.subSistemaId!),
          datosIniciales: CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion
              .fromDataClass(CuadriculaConPreguntasYConOpcionesDeRespuesta(
            e.cuadricula.cuadricula,
            e.preguntas,
            e.cuadricula.opcionesDeRespuesta,
          )),
        );
      }
      if (e is BloqueConPreguntaNumerica) {
        return CreadorPreguntaNumericaController(
          repository,
          await repository.getSistemaPorId(e.pregunta.pregunta.sistemaId!),
          await repository
              .getSubSistemaPorId(e.pregunta.pregunta.subSistemaId!),
          datosIniciales: PreguntaNumericaCompanion.fromDataClass(e.pregunta),
        );
      }
      throw UnimplementedError("Tipo de bloque no reconocido");
    }).toList();
  }

  /// Agrega un nuevo bloque despues de [despuesDe]
  void agregarBloqueDespuesDe({
    required CreacionController bloque,
    required CreacionController despuesDe,
  }) {
    final indice = controllersBloques.indexOf(despuesDe) + 1;
    controllersBloques.insert(indice, bloque);
    bloquesControl.insert(indice, bloque.control);
  }

  /// Borra el bloque seleccionado
  void borrarBloque(CreacionController bloque) {
    controllersBloques.remove(bloque);
    bloquesControl.remove(bloque.control);
  }

  /// Cierra todos los streams para evitar fugas de memoria, se suele llamar desde el provider
  void dispose() {
    control.dispose();
  }

  /// Cuando se presiona guardar o finalizar cuestionario.
  /// Se realizan muchas excepciones al null safety pero estas deben ser evitadas
  /// con los validators, si no se hace esta función tirará errores en tiempo
  /// de ejecución
  Future guardarCuestionarioEnLocal(EstadoDeCuestionario estado) async {
    control.markAllAsTouched();

    final int contratistaId =
        contratistaControl.value!.id; // Validado en el control

    final String tipoDeInspeccion =
        tipoDeInspeccionControl.value! == otroTipoDeInspeccion
            ? nuevoTipoDeInspeccionControl.value!
            : tipoDeInspeccionControl.value!;

    final CuestionariosCompanion cuestionario =
        datosIniciales.cuestionario.copyWith(
      tipoDeInspeccion: Value(tipoDeInspeccion),
      estado: Value(estado),
      esLocal: const Value(true),
    );

    final List<CuestionarioDeModelosCompanion> cuestionariosDeModelos =
        modelosControl.value!
            .map((modelo) => CuestionarioDeModelosCompanion(
                  modelo: Value(modelo),
                  periodicidad: Value(periodicidadControl.value!.round()),
                  contratistaId: Value(contratistaId),
                ))
            .toList();

    final bloquesForm = controllersBloques.map((e) => e.toDB()).toList();

    // TODO: si se vuelve muy lento, usar un bloc y/o un isolate
    await repository.guardarCuestionario(
        cuestionario, cuestionariosDeModelos, bloquesForm);
  }
}
