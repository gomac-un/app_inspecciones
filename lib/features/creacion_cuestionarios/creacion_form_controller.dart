import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/core/error/errors.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/infrastructure/repositories/organizacion_repository.dart';
import 'package:inspecciones/infrastructure/repositories/providers.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'creacion_controls.dart';
import 'creacion_validators.dart';
import 'tablas_unidas.dart';

final cuestionarioIdProvider = Provider<String?>((ref) => throw Exception(
    "se debe definir cuestionarioId dentro de la pagina de creacion"));

final creacionFormControllerFutureProvider =
    FutureProvider.autoDispose.family<CreacionFormController, String?>(
  (ref, cuestionarioId) async {
    final res = await CreacionFormController.create(
      ref.watch(cuestionariosRepositoryProvider),
      ref.watch(organizacionRepositoryProvider),
      cuestionarioId,
    );
    ref.onDispose(res.dispose);
    return res;
  },
);

final creacionFormControllerProvider =
    Provider.autoDispose.family<CreacionFormController, String?>(
  (ref, cuestionarioId) =>
      ref.watch(creacionFormControllerFutureProvider(cuestionarioId)).when(
            data: id,
            loading: () => throw Exception(
                "creacionFormControllerFutureProvider no se ha cargado"),
            error: (e, s) => throw e,
          ),
);

class CreacionFormController {
  final CuestionariosRepository repository;
  final OrganizacionRepository organizacionRepository;

  ///constantes
  static const otroTipoDeInspeccion = "Otra";

  /// información usada para inicializar los campos en caso de que sea una edición
  final CuestionarioCompletoCompanion datosIniciales;

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

  late final etiquetasControl = fb.control<Set<Etiqueta>>(
    datosIniciales.etiquetas
        .map((e) => Etiqueta(e.clave.value, e.valor.value))
        .toSet(),
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

  List<Etiqueta> getTodasLasEtiquetas(List<Jerarquia> todasLasJerarquias) =>
      todasLasJerarquias
          .expand((e) => e.getTodasLasEtiquetas())
          .where((e) => !etiquetasControl.value!.contains(e))
          .toList();

  /// static factory que instancia un [CreacionFormController] de manera asíncrona
  /// ya que tiene que cargar información desde la base de datos
  static Future<CreacionFormController> create(
    CuestionariosRepository repository,
    OrganizacionRepository organizacionRepository,
    String? cuestionarioId,
  ) async {
    final todosLosTiposDeInspeccion = await repository.getTiposDeInspecciones();

    /// Sirve para activar otro campo en el formulario, si se selecciona
    todosLosTiposDeInspeccion.add(otroTipoDeInspeccion);

    final todasLasEtiquetas = await repository.getEtiquetas();

    if (cuestionarioId == null) {
      return CreacionFormController._(
        repository,
        organizacionRepository,
        todasLasEtiquetas,
        todosLosTiposDeInspeccion,
        await _buildControllers(null),
      );
    }

    /// Dereferenciadores del cuestionarioId, en caso de que llegue
    final datosIniciales =
        (await repository.getCuestionarioCompleto(cuestionarioId))
            .toCompanion();

    final controllersBloques = await _buildControllers(datosIniciales.bloques);

    return CreacionFormController._(
      repository,
      organizacionRepository,
      todasLasEtiquetas,
      todosLosTiposDeInspeccion,
      controllersBloques,
      datosIniciales: datosIniciales,
    );
  }

  /// TODO: reducir el numero de parámetros agrupandolos de alguna manera
  CreacionFormController._(
    this.repository,
    this.organizacionRepository,
    this.todasLasEtiquetas,
    this.todosLosTiposDeInspeccion,
    this.controllersBloques, {
    this.datosIniciales = const CuestionarioCompletoCompanion.vacio(),
  }) {
    bloquesControl =
        FormArray(controllersBloques.map((e) => e.control).toList());
    control = FormGroup(
      {
        'tipoDeInspeccion': tipoDeInspeccionControl,
        'nuevoTipoDeInspeccion': nuevoTipoDeInspeccionControl,
        'periodicidad': periodicidadControl,
        'etiquetas': etiquetasControl,
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

  static Future<List<CreacionController>> _buildControllers(
      List<Companion>? bloques) async {
    if (bloques == null) {
      /// Si se está creando el cuestionario, se agrega un titulo por defecto como bloque inicial
      return [CreadorTituloController()];
    }

    /// Si es un cuestionario que ya existía y se va a editar
    ///Ordenamiento y creacion de los controles dependiendo del tipo de elemento
    return bloques.map<CreacionController>((e) {
      if (e is TituloDCompanion) {
        return CreadorTituloController(e);
      }
      if (e is PreguntaDeSeleccionCompanion) {
        return CreadorPreguntaController(
          datosIniciales: e,
        );
      }
      if (e is PreguntaNumericaCompanion) {
        return CreadorPreguntaNumericaController(
          datosIniciales: e,
        );
      }
      if (e is CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion) {
        return CreadorPreguntaCuadriculaController(
          datosIniciales: e,
        );
      }
      throw TaggedUnionError(e);
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
      version: Value(datosIniciales.cuestionario.version.valueOrDefault(1)),
      periodicidadDias: Value(periodicidadControl.value!),
      estado: Value(estado),
      subido: const Value(false),
    );

    final List<EtiquetasDeActivoCompanion> etiquetas = etiquetasControl.value!
        .map((e) =>
            EtiquetasDeActivoCompanion.insert(clave: e.clave, valor: e.valor))
        .toList();

    final bloquesForm = controllersBloques.map((e) => e.toDB()).toList();

    // TODO: si se vuelve muy lento, usar un bloc y/o un isolate
    await repository.guardarCuestionario(
        CuestionarioCompletoCompanion(cuestionario, etiquetas, bloquesForm));
  }
}
