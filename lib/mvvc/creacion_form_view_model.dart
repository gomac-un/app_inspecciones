import 'package:flutter/foundation.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/creacion_controls.dart';
import 'package:inspecciones/mvvc/creacion_validators.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreacionFormViewModel extends FormGroup {
  final _db = getIt<Database>();
  Cuestionario cuestionario;
  final List<IBloqueOrdenable> bloquesBD;
  final sistemas = ValueNotifier<List<Sistema>>([]);
  final tiposDeInspeccion = ValueNotifier<List<String>>([]);
  final modelos = ValueNotifier<List<String>>([]);
  final contratistas = ValueNotifier<List<Contratista>>([]);
  /* final totalBloques = ValueNotifier<List<int>>([]); */
  final CuestionarioConContratista cuestionarioDeModelo;
  final estado = ValueNotifier(EstadoDeCuestionario.borrador);

  Copiable bloqueCopiado;

  CreacionFormViewModel(this.cuestionario, this.cuestionarioDeModelo,
      {this.bloquesBD = const []})
      : super(
          {
            'tipoDeInspeccion': FormControl<String>(
                value: cuestionario?.tipoDeInspeccion ?? '',
                validators: [Validators.required]),
            'nuevoTipoDeInspeccion': FormControl<String>(value: ""),
            'contratista': FormControl<Contratista>(
                value: cuestionarioDeModelo?.contratista,
                validators: [Validators.required]),
            'periodicidad': FormControl<double>(
                value: cuestionarioDeModelo
                        ?.cuestionarioDeModelo?.first?.periodicidad
                        ?.toDouble() ??
                    0,
                validators: [Validators.required]),
            'modelos': FormControl<List<String>>(
                value: cuestionarioDeModelo?.cuestionarioDeModelo
                        ?.map((e) => e.modelo)
                        ?.toList() ??
                    []),
            'bloques': _cargarBloques(cuestionario, bloquesBD),
            //agrega un titulo inicial
          },
          validators: [nuevoTipoDeInspeccion],
          asyncValidators: [cuestionariosExistentes],
        ) {
    cargarDatos();
  }

  Future cargarDatos() async {
    tiposDeInspeccion.value = await _db.creacionDao.getTiposDeInspecciones();
    tiposDeInspeccion.value.add("otra");

    modelos.value = await _db.creacionDao.getModelos();
    modelos.value.add("todos");

    contratistas.value = await _db.creacionDao.getContratistas();
    sistemas.value = await _db.creacionDao.getSistemas();

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

  /// Metodo que funciona sorprendentemente bien con los nulos y los casos extremos
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

  /* void borrarBloque(AbstractControl e) {
    //TODO hacerle dispose si se requiere
    try {
      final bloques = control("bloques") as FormArray;
      final numeroABorrar = bloques.controls.indexOf(e) + 1;
      bloques.remove(e);
      totalBloques.value.remove(numeroABorrar
          /* (bloques.controls.indexOf(e)+1).toString() */);
      totalBloques.value.forEach((e) {
        if (e > numeroABorrar) {
          final x = e - 1;
          totalBloques.value.remove(e);
          totalBloques.value.add(x);
        }
      });
      totalBloques.value.sort((a, b) => a.compareTo(b));
      ; // ignore: empty_catches
      /* numerosAModificar.map((e) => totalBloques.value.add(e-1)); */
    } on FormControlNotFoundException {}
  } */

  /// Cierra todos los streams para evitar fugas de memoria, se suele llamar desde el provider
  @override
  void dispose() {
    tiposDeInspeccion.dispose();
    modelos.dispose();
    contratistas.dispose();
    sistemas.dispose();
    estado.dispose();/* 
    totalBloques.dispose(); */
    super.dispose();
  }

  Future guardarCuestionarioEnLocal(EstadoDeCuestionario estado) async {
    markAllAsTouched();
    final int cuestionarioId = cuestionario?.id;
    final int contratistaId = (control('contratista').value as Contratista)?.id;

    final String tipoDeInspeccion = control("tipoDeInspeccion").value == "otra"
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
        final esCondicional = control.toDB().pregunta.esCondicional;
        if (!esCondicional) {
          return [
            BloqueConPreguntaSimple(
              bloque,
              control.toDB(),
            )
          ];
        } /* else {
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
        if (e is BloqueConCondicional) {
          return CreadorPreguntaFormGroup(defaultValue: e.pregunta);
        }
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
