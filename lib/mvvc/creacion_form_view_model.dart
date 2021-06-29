import 'package:flutter/foundation.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_validators.dart';
import 'package:reactive_forms/reactive_forms.dart';

FormArray _cargarBloques(
    Cuestionario cuestionario, List<IBloqueOrdenable> bloquesBD) {
  if (cuestionario != null) {
    //ordenamiento y creacion de los controles dependiendo del tipo de elemento
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
              preguntas: e.preguntasRespondidas);
        }
        if (e is BloqueConPreguntaNumerica) {
          return CreadorPreguntaNumericaFormGroup(defaultValue: e.pregunta);
        }
        throw Exception("Tipo de bloque no reconocido");
      }).toList(),
    );

    return bloques;
  } else {
    final bloques = FormArray([CreadorTituloFormGroup()]);
    return bloques;
  }
}

class CreacionFormViewModel extends FormGroup {
  final _db = getIt<Database>();
  final sistemas = ValueNotifier<List<Sistema>>([]);
  final tiposDeInspeccion = ValueNotifier<List<String>>([]);
  final modelos = ValueNotifier<List<String>>([]);
  final contratistas = ValueNotifier<List<Contratista>>([]);
  final estado = ValueNotifier(EstadoDeCuestionario.borrador);
  final ValueNotifier<List<SubSistema>> subSistemas;
  Cuestionario cuestionario;
  final CuestionarioConContratista cuestionarioDeModelo;
  final List<IBloqueOrdenable> bloquesBD;
  Copiable bloqueCopiado;

  factory CreacionFormViewModel({
    CuestionarioConContratista cuestionarioDeModelo,
    Cuestionario cuestionario,
    List<IBloqueOrdenable> bloquesBD,
  }) {
    final modelo = cuestionarioDeModelo;
    final cuesti = cuestionario;
    final bloques = bloquesBD;
    final sistema = fb.control<Sistema>(null, [Validators.required]);
    final subSistemas = ValueNotifier<List<SubSistema>>([]);

    sistema.valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemas.value =
          await getIt<Database>().creacionDao.getSubSistemas(sistema);
    });

    final Map<String, AbstractControl<dynamic>> controles = {
      'tipoDeInspeccion': FormControl<String>(
          value: cuestionario?.tipoDeInspeccion ?? '',
          validators: [Validators.required]),
      'sistema': sistema,
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
              [],validators: [Validators.minLength(1)]),
      'bloques': _cargarBloques(cuestionario, bloquesBD),
      //agrega un titulo inicial
    };

    return CreacionFormViewModel._(
        controles, subSistemas, modelo, cuesti, bloques);
  }

  //constructor que le envia los controles a la clase padre
  CreacionFormViewModel._(
      Map<String, AbstractControl<dynamic>> controles,
      this.subSistemas,
      this.cuestionarioDeModelo,
      this.cuestionario,
      this.bloquesBD)
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
    tiposDeInspeccion.value = await _db.creacionDao.getTiposDeInspecciones();
    tiposDeInspeccion.value.add("Otra");

    modelos.value = await _db.creacionDao.getModelos();
    modelos.value.add("Todos");

    contratistas.value = await _db.creacionDao.getContratistas();
    sistemas.value = await _db.creacionDao.getSistemas();

    estado.value = cuestionario?.estado ?? EstadoDeCuestionario.borrador;

    controls['sistema'].value =
        await getIt<Database>().getSistemaPorId(cuestionario?.sistemaId);

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

  void agregarBloqueDespuesDe(
      {AbstractControl bloque, AbstractControl despuesDe}) {
    final bloques = control("bloques") as FormArray;
    bloques.insert(bloques.controls.indexOf(despuesDe) + 1, bloque);
    /* if (!totalBloques.value.contains(bloques.controls.indexOf(bloque) + 1)) {
      totalBloques.value.add(bloques.controls.indexOf(bloque) + 1);
    } else {
      totalBloques.value.add((totalBloques.value.last) + 1);
    } */
  }

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

  Future guardarCuestionarioEnLocal(EstadoDeCuestionario estado) async {
    markAllAsTouched();
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
      sistemaId: (control('sistema').value as Sistema)?.id,
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

    final x = (control('bloques') as FormArray).controls.asMap().entries;

    final bloquesAGuardar = x.expand<IBloqueOrdenable>((e) {
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
        return [
          BloqueConCuadricula(
              bloque,
              CuadriculaDePreguntasConOpcionesDeRespuesta(
                control.toDB().cuadricula,
                control.toDB().opcionesDeRespuesta,
              ),
              preguntas: control.toDB().preguntas)
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
