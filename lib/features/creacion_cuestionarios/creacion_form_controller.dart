import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/core/error/errors.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/infrastructure/tablas_unidas.dart';
import 'package:inspecciones/infrastructure/utils/iterable_x.dart';
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
  dependencies: [cuestionarioIdProvider, cuestionariosRepositoryProvider],
);

final creacionFormControllerProvider = Provider(
  (ref) => ref.watch(creacionFormControllerFutureProvider).when(
        data: id,
        loading: (previous) => throw Exception(
            "creacionFormControllerFutureProvider no se ha cargado"),
        error: (e, s, previous) => throw e,
      ),
  dependencies: [creacionFormControllerFutureProvider],
);

class CreacionFormController {
  final CuestionariosRepository repository;

  ///constantes
  static const otroTipoDeInspeccion = "Otra";
  static const todosLosModelosValue = "Todos";

  /// información usada para inicializar los campos en caso de que sea una edición
  final CuestionarioConContratistaYModelosCompanion datosIniciales;

  /// inicialización de los campos del cuestionario usando los valores guardados
  /// en caso de que sea una edicion. si es uno nuevo se definen valores por defecto
  late final tipoDeInspeccionControl = fb.control<String?>(
    datosIniciales.cuestionario.tipoDeInspeccion.value,
    [Validators.required],
  );
  late final nuevoTipoDeInspeccionControl = fb.control<String?>(null);
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
  late final FormArray<Map<String, Object?>> bloquesControl;

  /// Formgroup que agrupa todos los controles del formulario
  late final FormGroup control;

  /// Informacion traida desde la base de datos
  final List<Sistema> todosLosSistemas;
  final List<String> todosLosTiposDeInspeccion;
  final List<String> todosLosModelos;
  final List<Contratista> todosLosContratistas;

  /// Si cuestionario es nuevo, se le asigna borrador.
  late final estado = datosIniciales.cuestionario.estado
      .valueOrDefault(EstadoDeCuestionario.borrador);

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
        (await _cargarBloques(repository, null, null)).toList(),
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
      controllersBloques.toList(),
      datosIniciales: CuestionarioConContratistaYModelosCompanion.fromDataClass(
          datosIniciales),
    );
  }

  /// TODO: reducir el numero de parámetros agrupandolos de alguna manera
  CreacionFormController._(
    this.repository,
    this.todosLosContratistas,
    this.todosLosModelos,
    this.todosLosSistemas,
    this.todosLosTiposDeInspeccion,
    this.controllersBloques, {
    this.datosIniciales =
        const CuestionarioConContratistaYModelosCompanion.vacio(),
  }) {
    bloquesControl =
        FormArray(controllersBloques.map((e) => e.control).toList());
    control = FormGroup(
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
    if (datosIniciales.cuestionario.estado.value ==
        EstadoDeCuestionario.finalizada) {
      control.markAsDisabled();
    }
  }

  /// Carga los bloques del cuestionario
  ///
  /// El flujo es: desde la Bd se devuelve [bloquesBD] al invocar ([CreacionDao.cargarCuestionario()]),
  /// luego se recorren y dependiendo del tipo especifico de IBloqueOrdenable que sea, se devuelve el control correspondiente
  /// para que [ControlWidget] en creacion_card.dart pueda devolver la card adecuada para cada tipo
  static Future<Iterable<CreacionController>> _cargarBloques(
      CuestionariosRepository repository,
      Cuestionario? cuestionario,
      List<IBloqueOrdenable>? bloquesBD) async {
    if (cuestionario == null || bloquesBD == null) {
      /// Si se está creando el cuestionario, se agrega un titulo por defecto como bloque inicial
      return [CreadorTituloController()];
    }

    /// Si es un cuestionario que ya existía y se va a editar
    ///Ordenamiento y creacion de los controles dependiendo del tipo de elemento
    return (bloquesBD
          ..sort(
            (a, b) => a.nOrden.compareTo(b.nOrden),
          ))
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
          await _maybeGetSistema(e.pregunta.pregunta.sistemaId, repository),
          await _maybeGetSubSistema(
              e.pregunta.pregunta.subSistemaId, repository),
          datosIniciales:
              PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(e.pregunta),
        );
      }
      if (e is BloqueConCuadricula) {
        return CreadorPreguntaCuadriculaController(
          repository,
          e.preguntas.isEmpty
              ? null
              : await _maybeGetSistema(
                  e.preguntas.first.pregunta.sistemaId, repository),
          e.preguntas.isEmpty
              ? null
              : await _maybeGetSubSistema(
                  e.preguntas.first.pregunta.subSistemaId, repository),
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
          await _maybeGetSistema(e.pregunta.pregunta.sistemaId, repository),
          await _maybeGetSubSistema(
              e.pregunta.pregunta.subSistemaId, repository),
          datosIniciales: PreguntaNumericaCompanion.fromDataClass(e.pregunta),
        );
      }
      throw TaggedUnionError(e);
    });
  }

  static Future<Sistema?> _maybeGetSistema(
      int? sistemaId, CuestionariosRepository repository) async {
    final Sistema? sistema;
    if (sistemaId == null) {
      sistema = null;
    } else {
      sistema = await repository.getSistemaPorId(sistemaId);
    }
    return sistema;
  }

  static Future<SubSistema?> _maybeGetSubSistema(
      int? subSistemaId, CuestionariosRepository repository) async {
    final SubSistema? subSistema;
    if (subSistemaId == null) {
      subSistema = null;
    } else {
      subSistema = await repository.getSubSistemaPorId(subSistemaId);
    }
    return subSistema;
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

  /// Esta función guarda el cuestionario como esté, sin realizar validaciones,
  /// pero si es una finalización, si se deben hacer todas las validaciones previas.
  Future<void> guardarCuestionarioEnLocal(EstadoDeCuestionario estado) async {
    final String? tipoDeInspeccion = tipoDeInspeccionControl.value != null &&
            tipoDeInspeccionControl.value == otroTipoDeInspeccion
        ? nuevoTipoDeInspeccionControl.value
        : tipoDeInspeccionControl.value;

    final int? contratistaId = contratistaControl.value?.id;

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
