import 'package:flutter/foundation.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_validators.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Carga los bloques del cuetionario
///
/// El flujo es: desde la Bd se devuelve [bloquesBD] al invocar ([CreacionDao.cargarCuestionario()]),
/// luego se recorren y dependiendo del tipo especifico de IBloqueOrdenable que sea, se devuelve el control correspondiente
/// para que [ControlWidget] en creacion_card.dart pueda devolver la card adecuada para cada tipo
FormArray _cargarBloques(
    Cuestionario cuestionario, List<IBloqueOrdenable> bloquesBD) {
  /// Si es un cuestionario que ya existía y se va a editar
  if (cuestionario != null) {
    ///Ordenamiento y creacion de los controles dependiendo del tipo de elemento
    final bloques = FormArray(
      (bloquesBD
            ..sort(
              (a, b) => a.nOrden.compareTo(b.bloque.nOrden),
            ))
          .map<AbstractControl>((e) {
        if (e is BloqueConTitulo) return CreadorTituloFormGroup(d: e.titulo);
        /*   if (e is BloqueConCondicional) {
          return CreadorPreguntaFormGroup(defaultValue: e.pregunta);
        } */
        if (e is BloqueConPreguntaSimple) {
          return CreadorPreguntaFormGroup(defaultValue: e.pregunta);
        }
        if (e is BloqueConCuadricula) {
          return CreadorPreguntaCuadriculaFormGroup(
            preguntasDeCuadricula: e.preguntas,
            cuadricula: e.cuadricula,
          );
        }
        if (e is BloqueConPreguntaNumerica) {
          return CreadorPreguntaNumericaFormGroup(defaultValue: e.pregunta);
        }
        throw Exception("Tipo de bloque no reconocido");
      }).toList(),
    );

    return bloques;
  } else {
    /// Si se está creando el cuestionario, se agrega un titulo por defecto como bloque inicial
    final bloques = FormArray([CreadorTituloFormGroup()]);
    return bloques;
  }
}

/// FormGroup para los campos base de la creación de cuestionario
class CreacionFormViewModel extends FormGroup {
  final _db = getIt<Database>();

  /// Estos ValueNotifier comienzan vacíos y se llenan con la funcion [cargarDatos()]
  /// [sistemas] lista de todos los sistemas disponibles, se usan para elegir el sistema en cada pregunta.
  final sistemas = ValueNotifier<List<Sistema>>([]);
  final tiposDeInspeccion = ValueNotifier<List<String>>([]);
  final modelos = ValueNotifier<List<String>>([]);
  final contratistas = ValueNotifier<List<Contratista>>([]);

  /// El estado inicial es borrador.
  final estado = ValueNotifier(EstadoDeCuestionario.borrador);

  /// [cuestionario], [cuestionarioDeModelo] y [bloquesBD] No son null cuando es para edición.
  Cuestionario cuestionario;
  final CuestionarioConContratista cuestionarioDeModelo;
  final List<IBloqueOrdenable> bloquesBD;

  /// Se modifica cuando se copia un bloque desde creacion_controls.dart
  Copiable bloqueCopiado;
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

  factory CreacionFormViewModel({
    CuestionarioConContratista cuestionarioDeModelo,
    Cuestionario cuestionario,
    List<IBloqueOrdenable> bloquesBD,
  }) {
    final modelo = cuestionarioDeModelo;
    final cuesti = cuestionario;

    /// Estos bloques se envían cuando se hace clic en crear nuevo cuestionario
    ///
    /// La cosa es que eso ralentiza la UI, porque hace la consulta de los bloques antes de cargar esta pagina,
    /// pero se desarrolló asi, porque el metodo que los carga es Future, y no se puede asignar un tipo Future<FormArray> a los controles
    /// //TODO: Mirar como solucionar esta parte
    final bloques = bloquesBD;

    final Map<String, AbstractControl<dynamic>> controles = {
      'tipoDeInspeccion': FormControl<String>(
          value: cuestionario?.tipoDeInspeccion ?? '',
          validators: [Validators.required]),
      'nuevoTipoDeInspeccion': FormControl<String>(value: ""),
      'contratista': FormControl<Contratista>(
          value: cuestionarioDeModelo?.contratista,
          validators: [Validators.required]),
      'periodicidad': FormControl<double>(
          value: cuestionarioDeModelo?.cuestionarioDeModelo?.first?.periodicidad
                  ?.toDouble() ??
              0,
          validators: [Validators.required]),
      'modelos': FormControl<List<String>>(
          value: cuestionarioDeModelo?.cuestionarioDeModelo
                  ?.map((e) => e.modelo)
                  ?.toList() ??
              [],
          validators: [Validators.minLength(1)]),

      /// FormArray con todos los bloques (preguntas,cuadriculas y titulos) que se agregan al cuestionario
      'bloques': _cargarBloques(cuestionario, bloquesBD),
      //agrega un titulo inicial
    };

    return CreacionFormViewModel._(controles, modelo, cuesti, bloques);
  }

  //constructor que le envia los controles a la clase padre
  CreacionFormViewModel._(Map<String, AbstractControl<dynamic>> controles,
      this.cuestionarioDeModelo, this.cuestionario, this.bloquesBD)
      : super(
          controles,
          asyncValidators: [cuestionariosExistentes],
          validators: [nuevoTipoDeInspeccion],
        ) {
    cargarDatos();
    // Machetazo que puede dar resultados inesperados si se utiliza el
    // constructor en codigo sincrono ya que no se está esperando a que termine esta funcion asincrona
  }
  Future cargarDatos() async {
    /// Carga inspecciones existentes
    tiposDeInspeccion.value = await _db.creacionDao.getTiposDeInspecciones();

    /// Sirve para actiar otro campo en el formulario, si se selecciona
    tiposDeInspeccion.value.add("Otra");

    modelos.value = await _db.creacionDao.getModelos();

    /// El modelo especial 'Todos' aplica a cualquier modelo
    modelos.value.add("Todos");

    contratistas.value = await _db.creacionDao.getContratistas();
    sistemas.value = await _db.creacionDao.getSistemas();

    /// Si cuestionario es nuevo, se le asigna borrador.
    estado.value = cuestionario?.estado ?? EstadoDeCuestionario.borrador;

    /* if (cuestionario != null) {
      bloquesBD.forEach(
        (u) => {
          if (!totalBloques.value.contains(u.bloque.nOrden + 1))
            {totalBloques.value.add(u.bloque.nOrden + 1)}
          else
            {totalBloques.value.add(totalBloques.value.last + 1)},
        },
      );
      totalBloques.notifyListeners();
    } */
  }

  /// Agrega un nuevo bloque despues de [despuesDe]
  void agregarBloqueDespuesDe(
      {AbstractControl bloque, AbstractControl despuesDe}) {
    final bloques = control("bloques") as FormArray;
    bloques.insert(bloques.controls.indexOf(despuesDe) + 1, bloque);
  }

  /// Borra el bloque seleccionado
  void borrarBloque(AbstractControl e) {
    // En este momento se hace, aún no sabemos si es necesario
    try {
      (control("bloques") as FormArray).remove(e);
      e.dispose();
      // ignore: empty_catches
    } on FormControlNotFoundException {}
  }

  /// Cierra todos los streams para evitar fugas de memoria, se suele llamar desde el provider
  @override
  void dispose() {
    tiposDeInspeccion.dispose();
    modelos.dispose();
    contratistas.dispose();
    sistemas.dispose();
    estado.dispose();
    /* 
    totalBloques.dispose(); */
    super.dispose();
  }

  /// Cuando se presiona guardar o finalizar cuestionario.
  Future guardarCuestionarioEnLocal(EstadoDeCuestionario estado) async {
    markAllAsTouched();

    /// Queda null si es un cuestionario nuevo.
    final int cuestionarioId = cuestionario?.id;
    final int contratistaId = (control('contratista').value as Contratista)?.id;

    final String tipoDeInspeccion = control("tipoDeInspeccion").value == "Otra"
        ? control("nuevoTipoDeInspeccion").value as String
        : control("tipoDeInspeccion").value as String;

    final Cuestionario nuevoCuestionario = Cuestionario(
      tipoDeInspeccion: tipoDeInspeccion,
      esLocal: null,
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
        /* else {
          return [
            BloqueConCondicional(
              bloque,
              control.toDB(),/* 
              control.condicionesToDB(), */
            ),
          ];
        } */
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
      throw Exception("Tipo de control no reconocido");
    }).toList();

    await _db.creacionDao.guardarCuestionario(
        nuevoCuestionario, nuevoscuestionariosDeModelos, bloquesAGuardar, this);
  }
}
