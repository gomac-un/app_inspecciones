import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/core/error/errors.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:inspecciones/utils/iterable_x.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'creacion_controls.dart';
import 'creacion_validators.dart';
import 'tablas_unidas.dart';

final cuestionarioIdProvider = Provider<String?>((ref) => throw Exception(
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
        loading: () => throw Exception(
            "creacionFormControllerFutureProvider no se ha cargado"),
        error: (e, s) => throw e,
      ),
  dependencies: [creacionFormControllerFutureProvider],
);

class CreacionFormController {
  final CuestionariosRepository repository;

  ///constantes
  static const otroTipoDeInspeccion = "Otra";

  /// información usada para inicializar los campos en caso de que sea una edición
  final CuestionarioConEtiquetasCompanion datosIniciales;

  /// inicialización de los campos del cuestionario usando los valores guardados
  /// en caso de que sea una edicion. si es uno nuevo se definen valores por defecto
  late final tipoDeInspeccionControl = fb.control<String?>(
    datosIniciales.cuestionario.tipoDeInspeccion.valueOrDefault(""),
    [Validators.required],
  );
  late final nuevoTipoDeInspeccionControl = fb.control<String?>(null);

  late final periodicidadControl = fb.control<int>(
    datosIniciales.cuestionario.periodicidadDias.valueOrDefault(1),
    [Validators.required],
  );

  late final etiquetasControl = fb.control<Set<String>>(
    datosIniciales.etiquetas.map((e) => '${e.clave}:${e.valor}').toSet(),
    [Validators.minLength(1)],
  );

  /// controllers que tienen asociado cada uno de los bloques del formulario
  final List<CreacionController> controllersBloques;

  /// FormArray con todos los bloques (preguntas,cuadriculas y titulos) que se agregan al cuestionario
  late final FormArray<Map<String, Object?>> bloquesControl;

  /// Formgroup que agrupa todos los controles del formulario
  late final FormGroup control;

  /// Informacion traida desde la base de datos

  final List<String> todosLosTiposDeInspeccion;
  final List<EtiquetaDeActivo> todasLasEtiquetas;

  /// Se modifica cuando se copia un bloque desde creacion_controls.dart
  CreacionController? bloqueCopiado;

  /// static factory que instancia un [CreacionFormController] de manera asíncrona
  /// ya que tiene que cargar información desde la base de datos
  static Future<CreacionFormController> create(
    CuestionariosRepository repository,
    String? cuestionarioId,
  ) async {
    final todosLosTiposDeInspeccion = await repository.getTiposDeInspecciones();

    /// Sirve para activar otro campo en el formulario, si se selecciona
    todosLosTiposDeInspeccion.add(otroTipoDeInspeccion);

    final todasLasEtiquetas = await repository.getEtiquetas();

    if (cuestionarioId == null) {
      return CreacionFormController._(
        repository,
        todasLasEtiquetas,
        todosLosTiposDeInspeccion,
        (await _cargarBloques(repository, null, null)).toList(),
        // para que retorne un bloque por defecto ya que es nuevo cuestionario
      );
    }

    /// Dereferenciadores del cuestionarioId, en caso de que llegue
    final datosIniciales =
        await repository.getCuestionarioYEtiquetas(cuestionarioId);

    final bloquesBD = await repository.cargarCuestionario(cuestionarioId);

    final controllersBloques = await _cargarBloques(
        repository, datosIniciales.cuestionario, bloquesBD);

    return CreacionFormController._(
      repository,
      todasLasEtiquetas,
      todosLosTiposDeInspeccion,
      controllersBloques.toList(),
      datosIniciales:
          CuestionarioConEtiquetasCompanion.fromDataClass(datosIniciales),
    );
  }

  /// TODO: reducir el numero de parámetros agrupandolos de alguna manera
  CreacionFormController._(
    this.repository,
    this.todasLasEtiquetas,
    this.todosLosTiposDeInspeccion,
    this.controllersBloques, {
    this.datosIniciales = const CuestionarioConEtiquetasCompanion.vacio(),
  }) {
    bloquesControl =
        FormArray(controllersBloques.map((e) => e.control).toList());
    control = FormGroup(
      {
        'tipoDeInspeccion': tipoDeInspeccionControl,
        'nuevoTipoDeInspeccion': nuevoTipoDeInspeccionControl,
        'periodicidad': periodicidadControl,
        'modelos': etiquetasControl,
        'bloques': bloquesControl,
      },
      asyncValidators: [
        /*cuestionariosExistentes(
          datosIniciales.cuestionario.id.present
              ? datosIniciales.cuestionario.id.value
              : null,
          tipoDeInspeccionControl,
          etiquetasControl,
          repository,
        )*/
      ],
      validators: [
        nuevoTipoDeInspeccionValidator(
            tipoDeInspeccionControl, nuevoTipoDeInspeccionControl)
      ],
    );
    if (datosIniciales.cuestionario.estado
            .valueOrDefault(EstadoDeCuestionario.borrador) ==
        EstadoDeCuestionario.finalizado) {
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
      List<Object>? bloquesBD) async {
    if (cuestionario == null || bloquesBD == null) {
      /// Si se está creando el cuestionario, se agrega un titulo por defecto como bloque inicial
      return [CreadorTituloController()];
    }

    /// Si es un cuestionario que ya existía y se va a editar
    ///Ordenamiento y creacion de los controles dependiendo del tipo de elemento
    return bloquesBD.asyncMap<CreacionController>((e) async {
      if (e is Titulo) {
        return CreadorTituloController(e.toCompanion(true));
      }
      if (e is PreguntaConOpcionesDeRespuesta) {
        return CreadorPreguntaController(
          repository,
          datosIniciales:
              PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(e),
        );
      }
      if (e is PreguntaNumerica) {
        return CreadorPreguntaNumericaController(
          repository,
          datosIniciales: PreguntaNumericaCompanion.fromDataClass(e),
        );
      }
      if (e is CuadriculaConPreguntasYConOpcionesDeRespuesta) {
        return CreadorPreguntaCuadriculaController(
          repository,
          datosIniciales: CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion
              .fromDataClass(CuadriculaConPreguntasYConOpcionesDeRespuesta(
            e.cuadricula,
            e.preguntas,
          )),
        );
      }
      throw TaggedUnionError(e);
    });
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
    final String tipoDeInspeccion = tipoDeInspeccionControl.value != null &&
            tipoDeInspeccionControl.value == otroTipoDeInspeccion
        ? nuevoTipoDeInspeccionControl.value!
        : tipoDeInspeccionControl.value!;

    final CuestionariosCompanion cuestionario =
        datosIniciales.cuestionario.copyWith(
      tipoDeInspeccion: Value(tipoDeInspeccion),
      version: Value(datosIniciales.cuestionario.version.valueOrDefault(0) + 1),
      periodicidadDias: Value(periodicidadControl.value!),
      estado: Value(estado),
      subido: const Value(false),
    );

    final List<EtiquetasDeActivoCompanion> etiquetas = etiquetasControl.value!
        .map((e) => EtiquetasDeActivoCompanion.insert(
            clave: e.split(":").first, valor: e.split(":").last))
        .toList();

    final bloquesForm = controllersBloques.map((e) => e.toDB()).toList();

    // TODO: si se vuelve muy lento, usar un bloc y/o un isolate
    await repository.guardarCuestionario(cuestionario, etiquetas, bloquesForm);
  }
}
