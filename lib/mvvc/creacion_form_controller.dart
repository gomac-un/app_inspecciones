import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_validators.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CuestionarioConContratistaYModelosCompanion {
  final CuestionariosCompanion cuestionario;
  final List<CuestionarioDeModelosCompanion> cuestionarioDeModelo;
  final Contratista? contratista;

  CuestionarioConContratistaYModelosCompanion(
    this.cuestionario,
    this.cuestionarioDeModelo,
    this.contratista,
  );
  CuestionarioConContratistaYModelosCompanion.fromDataClass(
      CuestionarioConContratistaYModelos e)
      : cuestionario = e.cuestionario.toCompanion(true),
        cuestionarioDeModelo =
            e.cuestionarioDeModelo.map((o) => o.toCompanion(true)).toList(),
        contratista = e.contratista;
  const CuestionarioConContratistaYModelosCompanion.vacio()
      : cuestionario = const CuestionariosCompanion(),
        cuestionarioDeModelo = const [],
        contratista = null;

  CuestionarioConContratistaYModelosCompanion copyWith({
    CuestionariosCompanion? cuestionario,
    List<CuestionarioDeModelosCompanion>? cuestionarioDeModelo,
    Contratista? contratista,
  }) =>
      CuestionarioConContratistaYModelosCompanion(
        cuestionario ?? this.cuestionario,
        cuestionarioDeModelo ?? this.cuestionarioDeModelo,
        contratista ?? this.contratista,
      );
}

@injectable
class CreacionFormController {
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
    datosIniciales.cuestionarioDeModelo.first.periodicidad
        .valueOrDefault(0)
        .toDouble(),
    [Validators.required],
  );
  late final modelosControl = fb.control<List<String>>(
    datosIniciales.cuestionarioDeModelo
        .map((e) => e.modelo.valueOrDefault('ERROR'))
        .toList(),
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
    asyncValidators: [cuestionariosExistentes],
    validators: [nuevoTipoDeInspeccionValidator],
  );

  /// Informacion traida desde la base de datos
  final List<Sistema> todosLosSistemas;
  final List<String> todosLosTiposDeInspeccion;
  final List<String> todosLosModelos;
  final List<Contratista> todosLosContratistas;

  /// Si cuestionario es nuevo, se le asigna borrador.
  late final estado = datosIniciales.cuestionario.tipoDeInspeccion
      .valueOrDefault(
          EnumToString.convertToString(EstadoDeCuestionario.borrador));

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
  @factoryMethod
  static Future<CreacionFormController> create(
    CuestionariosRepository repository,
    @factoryParam int? cuestionarioId,
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
    if (!(cuestionario != null && bloquesBD != null)) {
      /// Si se está creando el cuestionario, se agrega un titulo por defecto como bloque inicial
      return [CreadorTituloController()];
    }

    /// Si es un cuestionario que ya existía y se va a editar
    ///Ordenamiento y creacion de los controles dependiendo del tipo de elemento
    return Stream.fromIterable((bloquesBD
          ..sort(
            (a, b) => a.nOrden.compareTo(b.bloque.nOrden),
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
          preguntaDesdeDB:
              PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(e.pregunta),
        );
      }
      if (e is BloqueConCuadricula) {
        return CreadorPreguntaCuadriculaController(
          repository,
          await repository
              .getSistemaPorId(e.preguntas!.first.pregunta.sistemaId!),
          await repository
              .getSubSistemaPorId(e.preguntas!.first.pregunta.subSistemaId!),
          datosIniciales: CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion
              .fromDataClass(CuadriculaConPreguntasYConOpcionesDeRespuesta(
            e.cuadricula.cuadricula,
            e.preguntas!,
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
  Future guardarCuestionarioEnLocal(EstadoDeCuestionario estado) async {
    control.markAllAsTouched();

    final int contratistaId =
        contratistaControl.value!.id; // Validado en el control

    final String tipoDeInspeccion =
        control("tipoDeInspeccion").value == otroTipoDeInspeccion
            ? control("nuevoTipoDeInspeccion").value as String
            : control("tipoDeInspeccion").value as String;

    final CuestionariosCompanion nuevoCuestionario =
        CuestionariosCompanion.insert(
      tipoDeInspeccion: tipoDeInspeccion,
      id: cuestionarioId,
      estado: estado,
    );

    final List<CuestionarioDeModelo> nuevoscuestionariosDeModelos =
        (control('modelos').value as List<String>)
            .map((String modelo) => CuestionarioDeModelo(
                modelo: modelo,
                periodicidad: (control('periodicidad').value as double).round(),
                contratistaId: contratistaId,
                cuestionarioId: cuestionarioId,
                id: null))
            .toList();

    final bloques = (control('bloques') as FormArray).controls.asMap().entries;

    /// Procesamiento de todos los FormGroup en el FormArray 'bloques'.
    final bloquesAGuardar = bloques.expand<IBloqueOrdenable>((e) {
      final i = e.key;
      final control = e.value;
      final bloque =
          Bloque(cuestionarioId: cuestionarioId, id: null, nOrden: i);
      if (control is CreadorTituloFormGroup) {
        return [
          BloqueConTitulo(
            bloque,
            control.toDB(),
          )
        ];
      }
      if (control is CreadorPreguntaFormGroup) {
        return [
          BloqueConPreguntaSimple(
            bloque,
            control.toDB(),
          )
        ];
      }
      if (control is CreadorPreguntaCuadriculaFormGroup) {
        final cuadriculaBd = control.toDB();
        return [
          BloqueConCuadricula(
              bloque,
              CuadriculaDePreguntasConOpcionesDeRespuesta(
                cuadriculaBd.cuadricula,
                cuadriculaBd.opcionesDeRespuesta,
              ),
              preguntas: cuadriculaBd.preguntas)
        ];
      }
      if (control is CreadorPreguntaNumericaFormGroup) {
        return [
          BloqueConPreguntaNumerica(
            bloque,
            control.toDB(),
          )
        ];
      }
      throw UnimplementedError("Tipo de control no reconocido");
    }).toList();

    await _db.creacionDao.guardarCuestionario(
        nuevoCuestionario, nuevoscuestionariosDeModelos, bloquesAGuardar, this);
  }
}
