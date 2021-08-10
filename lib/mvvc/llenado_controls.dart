import 'dart:io';
import 'dart:math';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/mvvc/llenado_validators.dart';
import 'package:kt_dart/kt.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// FormGroup para la respuesta de preguntas multiples.
class LlenadoOpcionFormGroup extends FormGroup {
  /// Informacion de la respuesta.
  final RespuestasCompanion respuesta;

  /// Opción elegida.
  final OpcionDeRespuesta opcion;
  factory LlenadoOpcionFormGroup(
      {RespuestasCompanion respuesta, OpcionDeRespuesta opcion}) {
    final resp = respuesta;

    final Map<String, AbstractControl<dynamic>> controles = {
      'calificacion':
          fb.control<double>(respuesta?.calificacion?.value?.toDouble() ?? 1),
      'respuesta': fb.control<OpcionDeRespuesta>(opcion, [Validators.required]),
      'fotosBase': fb.array<File>(
          respuesta?.fotosBase?.value
                  ?.map((e) => FormControl(value: File(e)))
                  ?.iter
                  ?.toList() ??
              [],
          [Validators.minLength(1)]),
      'fotosReparacion': fb.array<File>(
        respuesta?.fotosReparacion?.value
                ?.map((e) => FormControl(value: File(e)))
                ?.iter
                ?.toList() ??
            [],
      ),
      'reparado': fb.control<bool>(respuesta?.reparado?.value ?? false),
      'observacion': fb.control<String>(respuesta?.observacion?.value ?? ''),
      'observacionReparacion': fb.control<String>(
        respuesta?.observacionReparacion?.value ?? '',
      ),
      'calificable': fb.control<bool>(opcion?.calificable ?? false),
    };

    return LlenadoOpcionFormGroup._(controles, resp, opcion);
  }

  //constructor que le envia los controles a la clase padre
  LlenadoOpcionFormGroup._(Map<String, AbstractControl<dynamic>> controles,
      this.respuesta, this.opcion)
      : super(controles, validators: [reparacion]);

  /// Toma los valores introducidos en el formulario y devuelve [RespuestaConOpcionesDeRespuesta]
  RespuestaConOpcionesDeRespuesta toDB(DateTime momentoRespuesta) =>
      RespuestaConOpcionesDeRespuesta(
        respuesta?.copyWith(
            calificacion: Value(opcion.calificable
                ? (value['calificacion'] as double)?.round()
                : null),
            opcionDeRespuestaId:
                Value((control('respuesta').value as OpcionDeRespuesta).id),
            fotosBase: Value((control('fotosBase') as FormArray<File>)
                .value
                .map((e) => e.path)
                .toImmutableList()),
            fotosReparacion: Value(
                (control('fotosReparacion') as FormArray<File>)
                    .value
                    .map((e) => e.path)
                    .toImmutableList()),
            observacion: Value(control('observacion').value as String),
            reparado: Value(control('reparado').value as bool),
            observacionReparacion:
                Value(control('observacionReparacion').value as String),
            momentoRespuesta: momentoRespuesta != null
                ? Value(momentoRespuesta)
                : respuesta?.momentoRespuesta),
        control('respuesta').value as OpcionDeRespuesta,
      );
}

//TODO: implementar estos controles como sealed classes
/// FormGroup de respuestas de selección.
class RespuestaSeleccionSimpleFormGroup extends FormGroup
    implements BloqueDeFormulario {
  final Bloque bloque;
  final PreguntaConOpcionesDeRespuesta pregunta;
  final List<RespuestaConOpcionesDeRespuesta> respuesta;
  DateTime _momentoRespuesta;

  factory RespuestaSeleccionSimpleFormGroup(
    PreguntaConOpcionesDeRespuesta pregunta,
    List<RespuestaConOpcionesDeRespuesta> respuesta, {
    Bloque bloque,
  }) {
    // La idea era que los companions devolvieran los valores por defecto pero no es asi
    // https://github.com/simolus3/moor/issues/960
    // entonces aca se asignan definen nuevo los valores por defecto que son usados
    // cuando se inicia una nueva inspeccion
    respuesta.forEach((resp) =>
        resp.respuesta ??= crearRespuestaPorDefecto(pregunta.pregunta.id));
    FormControl respuestas;
    FormArray respuestaMultiple;

    ///
    if (pregunta.pregunta.tipo == TipoDePregunta.multipleRespuesta ||
        pregunta.pregunta.tipo == TipoDePregunta.parteDeCuadriculaMultiple) {
      /// Se busca entre las opciones de la [pregunta] cualquiera que sea igual a las opciones de [respuesta]
      final opcionesElegidas = respuesta
          .where(
            (opcion) =>
                pregunta.opcionesDeRespuesta
                    ?.any((res) => res == opcion.opcionesDeRespuesta) ??
                false,
          )
          .toList();

      /// Este es el FormControl usado en 'respuestas', para mostrar en los Chip de ReactiveDropDown
      respuestas = FormControl<List<OpcionDeRespuesta>>(
        value: opcionesElegidas.map((e) => e.opcionesDeRespuesta).toList(),
        validators: [
          ///TODO: mirar como hacer para que las cuadriculas multiples no permitan finalizar un cuestionario sin responderlas.
          if (!(pregunta.pregunta.tipo ==
              TipoDePregunta.parteDeCuadriculaMultiple))
            Validators.minLength(1)
        ],
      );

      /// Este es un FormArray que se usa para permitir que cada opción elegida pueda ser un propio FormGroup
      /// con sus respectivos controles.
      respuestaMultiple = fb.array<Map<String, dynamic>>(opcionesElegidas
          .map((e) => LlenadoOpcionFormGroup(
              opcion: e.opcionesDeRespuesta, respuesta: e.respuesta))
          .toList());
    }
    if (pregunta.pregunta.tipo == TipoDePregunta.unicaRespuesta ||
        pregunta.pregunta.tipo == TipoDePregunta.parteDeCuadriculaUnica) {
      /// Se busca la primera opcion de la [pregunta] que sea igual a [respuesta]
      ///
      /// [respuesta.first] porque al ser unica solo va a existir una opción.
      respuestas = FormControl<OpcionDeRespuesta>(
        value: pregunta.opcionesDeRespuesta.firstWhere(
          (e) => respuesta.first.opcionesDeRespuesta == e,
          orElse: () => null,
        ),
        validators: [Validators.required],
      );
      respuestaMultiple = fb.array<Map<String, dynamic>>([]);
    }

    if (respuestas == null) {
      throw Exception("Este form group no puede manejar este tipo de pregunta");
    }

    /// Escucha cambios en [respuestas].
    ///
    /// Es como que [respuestas] son las elegidas en el DropDown y [respuestaMultiple]
    /// agrega controles para poder darle a cada uno observación y fotos.
    respuestas?.valueChanges?.asBroadcastStream()?.listen((resp) {
      if (pregunta.pregunta.tipo == TipoDePregunta.multipleRespuesta ||
          pregunta.pregunta.tipo == TipoDePregunta.parteDeCuadriculaMultiple) {
        final respue = respuestaMultiple.controls
            .map((e) => (e as LlenadoOpcionFormGroup).control('respuesta').value
                as OpcionDeRespuesta)
            .toList();

        // Se añaden las que no estaban antes
        respuestaMultiple.addAll((resp as List<OpcionDeRespuesta>)
            ?.where((x) => !respue.contains(x))
            ?.map(
              (e) => LlenadoOpcionFormGroup(
                opcion: e,
                respuesta: respuesta
                    ?.firstWhere((x) => x.opcionesDeRespuesta == e,
                        orElse: () => RespuestaConOpcionesDeRespuesta(
                            crearRespuestaPorDefecto(pregunta.pregunta.id),
                            null))
                    ?.respuesta,
              ),
            )
            ?.toList());
        // Estas son las que estaban antes y ahora no
        final respuestaABorrar = respuestaMultiple.controls
            .where((e) => !(resp as List<OpcionDeRespuesta>).contains(
                (e as LlenadoOpcionFormGroup).control('respuesta').value
                    as OpcionDeRespuesta))
            .toList();
        // Se eliminan las que no son nuevas
        respuestaABorrar.forEach((e) => respuestaMultiple.remove(e));
      }
    });

    final Map<String, AbstractControl<dynamic>> controles = {
      'respuestas': respuestas,
      'calificacion': fb.control<double>(
          respuesta?.first?.respuesta?.calificacion?.value?.toDouble() ?? 1),
      'respMultiple': respuestaMultiple,
      'fotosBase': fb.array<File>(
          respuesta?.first?.respuesta?.fotosBase?.value
                  ?.map((e) => FormControl(value: File(e)))
                  ?.iter
                  ?.toList() ??
              [],
          [
            if (pregunta.pregunta.tipo == TipoDePregunta.unicaRespuesta ||
                pregunta.pregunta.tipo == TipoDePregunta.parteDeCuadriculaUnica)
              Validators.minLength(1)
          ]),
      'fotosReparacion': fb.array<File>(
        respuesta?.first?.respuesta?.fotosReparacion?.value
                ?.map((e) => FormControl(value: File(e)))
                ?.iter
                ?.toList() ??
            [],
      ),
      'observacion': fb.control<String>(
          respuesta?.first?.respuesta?.observacion?.value ?? ''),
      'reparado': fb
          .control<bool>(respuesta?.first?.respuesta?.reparado?.value ?? false),
      'observacionReparacion': fb.control<String>(
        respuesta?.first?.respuesta?.observacionReparacion?.value ?? '',
      ),
    };

    return RespuestaSeleccionSimpleFormGroup._(
      controles,
      pregunta,
      respuesta,
      bloque: bloque,
    );
  }
  //constructor que le envia los controles a la clase padre
  RespuestaSeleccionSimpleFormGroup._(
    Map<String, AbstractControl> controles,
    this.pregunta,
    this.respuesta, {
    this.bloque,
  }) : super(controles, validators: [reparacion]) {
    valueChanges.listen((_) {
      _momentoRespuesta = DateTime.now();
    }); //guarda el momento de la ultima edicion
  }

  /// Devuelve el porcentaje que representa la calificación dada por el inspector.
  double _getPorcentaje(double calificacion) {
    double porcentaje = 1;
    switch (calificacion.round()) {
      case 1:
        porcentaje = 0.55;
        break;
      case 2:
        porcentaje = 0.70;
        break;
      case 3:
        porcentaje = 0.85;
        break;
      case 4:
        porcentaje = 1;
        break;
    }
    return porcentaje;
  }

  /// Devuelve la criticidad total de la pregunta sin reparación. criticidad pregunta * criticidad respuesta.
  @override
  double get criticidad {
    /*TODO: calcular la criticidad de las multiples con las reglas de
      * Sebastian o hacerlo en la bd dejando esta criticidad como axiliar 
      * solo para la pantalla de arreglos
      */
    /// Suma de la criticidad de las respuestas, incluye la dada por el creador del cuestionario
    /// más la calificación del inspector.

    double sumres;

    switch (pregunta.pregunta.tipo) {
      case TipoDePregunta.multipleRespuesta:

        /// Si han elegido alguna respuesta.
        if ((control('respuestas') as FormControl<List<OpcionDeRespuesta>>)
                .value !=
            null) {
          sumres = (control('respMultiple') as FormArray<Map<String, dynamic>>)
              .controls
              .fold(
                  0,
                  (p, c) => (c as LlenadoOpcionFormGroup).opcion.calificable
                      ? p +
                          ((c as LlenadoOpcionFormGroup).opcion.criticidad *
                              _getPorcentaje((c as LlenadoOpcionFormGroup)
                                  .control('calificacion')
                                  .value as double))
                      : p + (c as LlenadoOpcionFormGroup).opcion.criticidad);
        } else {
          sumres = 0;
        }
        break;
      case TipoDePregunta.unicaRespuesta:
        if ((control('respuestas') as FormControl<OpcionDeRespuesta>).value !=
            null) {
          sumres = (control('respuestas') as AbstractControl<OpcionDeRespuesta>)
                  .value
                  .calificable
              ? (control('respuestas') as FormControl<OpcionDeRespuesta>)
                      .value
                      .criticidad *
                  _getPorcentaje(control('calificacion').value as double)
              : (control('respuestas') as FormControl<OpcionDeRespuesta>)
                  .value
                  .criticidad
                  .toDouble();
        } else {
          sumres = 0;
        }
        break;
      case TipoDePregunta.parteDeCuadriculaUnica:
        if ((control('respuestas') as FormControl<OpcionDeRespuesta>).value !=
            null) {
          sumres = (control('respuestas') as AbstractControl<OpcionDeRespuesta>)
                  .value
                  .calificable
              ? (control('respuestas') as FormControl<OpcionDeRespuesta>)
                      .value
                      .criticidad *
                  _getPorcentaje(control('calificacion').value as double)
              : (control('respuestas') as FormControl<OpcionDeRespuesta>)
                  .value
                  .criticidad
                  .toDouble();
        } else {
          sumres = 0;
        }
        break;
      case TipoDePregunta.parteDeCuadriculaMultiple:
        if ((control('respuestas') as FormControl<List<OpcionDeRespuesta>>)
                .value !=
            null) {
          sumres = (control('respMultiple') as FormArray<Map<String, dynamic>>)
              .controls
              .fold(
                  0,
                  (p, c) => (c as LlenadoOpcionFormGroup).opcion.calificable
                      ? p +
                          ((c as LlenadoOpcionFormGroup).opcion.criticidad *
                              _getPorcentaje((c as LlenadoOpcionFormGroup)
                                  .control('calificacion')
                                  .value as double))
                      : p + (c as LlenadoOpcionFormGroup).opcion.criticidad);
        } else {
          sumres = 0;
        }

        break;
      default:
        throw Exception("tipo de pregunta no esperado");
    }

    /// Redondea la criticidad
    final mod = pow(10.0, 1);
    return (pregunta.pregunta.criticidad * sumres * mod).round().toDouble() /
        mod;
  }

  /// Devuelve la criticidad después de la reparación. Si fue reparado es 0.
  @override
  double get criticidadReparacion {
    if (control('reparado').value as bool) {
      return 0;
    } else {
      return criticidad;
    }
  }

  /// Devuelve la lista de todas las respuestas seleccionadas.
  List<RespuestaConOpcionesDeRespuesta> toDB() {
    if (pregunta.pregunta.tipo == TipoDePregunta.multipleRespuesta ||
        pregunta.pregunta.tipo == TipoDePregunta.parteDeCuadriculaMultiple) {
      return (control('respMultiple') as FormArray)
          .controls
          .map((e) => (e as LlenadoOpcionFormGroup).toDB(_momentoRespuesta))
          .toList();
    } else {
      if ((control('respuestas').value as OpcionDeRespuesta) != null) {
        final calificacion =
            (control('respuestas').value as OpcionDeRespuesta).calificable
                ? (value['calificacion'] as double)?.round()
                : null;
        return [
          RespuestaConOpcionesDeRespuesta(
            respuesta?.first?.respuesta?.copyWith(
                opcionDeRespuestaId: Value(
                    (control('respuestas').value as OpcionDeRespuesta).id),
                fotosBase: Value((control('fotosBase') as FormArray<File>)
                    .value
                    .map((e) => e.path)
                    .toImmutableList()),
                fotosReparacion: Value(
                    (control('fotosReparacion') as FormArray<File>)
                        .value
                        .map((e) => e.path)
                        .toImmutableList()),
                observacion: Value(control('observacion').value as String),
                reparado: Value(control('reparado').value as bool),
                observacionReparacion:
                    Value(control('observacionReparacion').value as String),
                momentoRespuesta: _momentoRespuesta != null
                    ? Value(_momentoRespuesta)
                    : respuesta?.first?.respuesta?.momentoRespuesta,
                calificacion: Value(calificacion)),
            control('respuestas').value as OpcionDeRespuesta,
          )
        ];
      }
      return [];
    }
  }
}

/// Form Group llenado de preguntas numericas.
class RespuestaNumericaFormGroup extends FormGroup
    implements BloqueDeFormulario {
  final Pregunta pregunta;
  RespuestasCompanion respuesta;
  List<CriticidadesNumerica> criticidades;
  DateTime _momentoRespuesta;

  factory RespuestaNumericaFormGroup(Pregunta pregunta,
      RespuestasCompanion respuesta, List<CriticidadesNumerica> criticidades) {
    // La idea era que los companions devolvieran los valores por defecto pero no es asi
    // https://github.com/simolus3/moor/issues/960
    // entonces aca se asignan definen nuevo los valores por defecto que son usados
    // cuando se inicia una nueva inspeccion

    if (respuesta?.preguntaId == null) {
      respuesta = crearRespuestaPorDefecto(pregunta.id);
    }

    final FormControl respuestas = FormControl<OpcionesDeRespuesta>();

    final Map<String, AbstractControl<dynamic>> controles = {
      'respuesta': respuestas,
      'valor': fb.control<double>(respuesta.valor.value, [Validators.required]),
      'observacion': fb.control<String>(respuesta.observacion.value),
      'fotosBase': fb.array<File>(
          respuesta.fotosBase.value
              .map((e) => FormControl(value: File(e)))
              .iter
              .toList(),
          [Validators.minLength(1)]),
      'reparado': fb.control<bool>(respuesta.reparado.value),
      'observacionReparacion':
          fb.control<String>(respuesta.observacionReparacion.value),
      'fotosReparacion': fb.array<File>(
        respuesta.fotosReparacion.value
            .map((e) => FormControl(value: File(e)))
            .iter
            .toList(),
      ),
    };

    return RespuestaNumericaFormGroup._(
      controles,
      pregunta,
      respuesta,
      criticidades,
    );
  }
  //constructor que le envia los controles a la clase padre
  RespuestaNumericaFormGroup._(Map<String, AbstractControl> controles,
      this.pregunta, this.respuesta, this.criticidades)
      : super(controles) {
    valueChanges.listen((_) => _momentoRespuesta =
        DateTime.now()); //guarda el momento de la ultima edicion
  }

  /// Devuelve la criticidad de la pregunta dependiendo del valor introducido en el TextField
  @override
  double get criticidad {
    final double respuesta = (control('valor') as FormControl<double>).value;
    final criRes = respuesta != null
        ? criticidades?.firstWhere(
            (x) => respuesta >= x.valorMinimo && respuesta < x.valorMaximo,
            orElse: () {
            return CriticidadesNumerica(criticidad: 0);
          })
        : CriticidadesNumerica(criticidad: 0);

    return (pregunta.criticidad * criRes.criticidad).toDouble();
  }

  /// Devuelve [RespuestaConOpcionesDeRespuesta]  porque así lo requiere el metodo [LlenadoFormViewModel.guardarInspeccionEnLocal()]
  /// Pero en realidad no tiene Opciones de respuesta.
  RespuestaConOpcionesDeRespuesta toDB() {
    final OpcionDeRespuesta respuestas =
        control('respuesta').value as OpcionDeRespuesta;
    final double campo = value['valor'] as double;
    final momento = _momentoRespuesta ?? respuesta.momentoRespuesta.value;

    /// Campo tenía que ser diferente de null porque aunque no se hubiese contestado,, se estaba guardando en la bd
    if (campo != null) {
      return RespuestaConOpcionesDeRespuesta(
        respuesta.copyWith(
          valor: Value(campo),
          fotosBase: Value((control('fotosBase') as FormArray<File>)
              .value
              .map((e) => e.path)
              .toImmutableList()),
          fotosReparacion: Value((control('fotosReparacion') as FormArray<File>)
              .value
              .map((e) => e.path)
              .toImmutableList()),
          observacion: Value(control('observacion').value as String),
          reparado: Value(control('reparado').value as bool),
          observacionReparacion:
              Value(control('observacionReparacion').value as String),
          momentoRespuesta: Value(momento),
        ),
        respuestas,
      );
    }
  }

  /// Devuelve criticidad despues de reparacion.
  /// Es cero si fue reparado.
  @override
  double get criticidadReparacion {
    if (control('reparado').value as bool) {
      return 0;
    } else {
      return criticidad;
    }
  }
}

/// FormGroup que maneja las preguntas de tipo cuadricula.
class RespuestaCuadriculaFormArray extends FormArray
    implements BloqueDeFormulario {
  final CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula;
  final List<PreguntaConRespuestaConOpcionesDeRespuesta> preguntasRespondidas;

  factory RespuestaCuadriculaFormArray(
    CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula,
    List<PreguntaConRespuestaConOpcionesDeRespuesta> preguntasRespondidas,
  ) {
    for (final e in preguntasRespondidas) {
      e.respuesta.map(
          (resp) => resp.respuesta ??= crearRespuestaPorDefecto(e.pregunta.id));
    }

    final List<RespuestaSeleccionSimpleFormGroup> controles =
        preguntasRespondidas
            .map((e) => RespuestaSeleccionSimpleFormGroup(
                PreguntaConOpcionesDeRespuesta(
                  e.pregunta,
                  cuadricula.opcionesDeRespuesta,
                ),
                e.respuesta))
            .toList();

    return RespuestaCuadriculaFormArray._(
      controles,
      cuadricula,
      preguntasRespondidas,
    );
  }
  RespuestaCuadriculaFormArray._(List<AbstractControl> controles,
      this.cuadricula, this.preguntasRespondidas)
      : super(controles);

  List<List<RespuestaConOpcionesDeRespuesta>> toDB([int inspeccionId]) {
    return controls.map((d) {
      final e = d as RespuestaSeleccionSimpleFormGroup;
      return e.toDB();
    }).toList();
  }

  /// Devuelve la criticidad de la cuadricula.
  /// Es la suma de la criticidad de todas las preguntas.
  @override
  double get criticidad {
    /*TODO: calcular la criticidad de las multiples con las reglas de
      * Sebastian o hacerlo en la bd dejando esta criticidad como axiliar 
      * solo para la pantalla de arreglos
      */
    final double x = controls.map((d) {
      final e = d as RespuestaSeleccionSimpleFormGroup;
      if (e.pregunta.pregunta.tipo == TipoDePregunta.parteDeCuadriculaUnica) {
        final ctrlPregunta =
            e.control('respuestas') as FormControl<OpcionDeRespuesta>;
        return e.pregunta.pregunta.criticidad *
            (ctrlPregunta?.value?.criticidad ?? 0);
      } else {
        final int sumRespuesta =
            (e.control('respuestas') as FormControl<List<OpcionDeRespuesta>>)
                .value
                .fold(0, (p, c) => p + c?.criticidad ?? 0);

        return e.pregunta.pregunta.criticidad * sumRespuesta;
      }
    }).fold(0, (p, c) => p + c);
    return x;

    //return pregunta.pregunta.criticidad * sumres;
  }

  @override
  double get criticidadReparacion {
    final double x = controls.map((d) {
      final e = d as RespuestaSeleccionSimpleFormGroup;
      if (e.control('reparado').value as bool) {
        return 0;
      } else if (e.pregunta.pregunta.tipo ==
          TipoDePregunta.parteDeCuadriculaUnica) {
        final ctrlPregunta =
            e.control('respuestas') as FormControl<OpcionDeRespuesta>;
        return e.pregunta.pregunta.criticidad *
            (ctrlPregunta?.value?.criticidad ?? 0);
      } else {
        final int sumRespuesta =
            (e.control('respuestas') as FormControl<List<OpcionDeRespuesta>>)
                .value
                .fold(0, (p, c) => p + c?.criticidad ?? 0);

        return e.pregunta.pregunta.criticidad * sumRespuesta;
      }
    }).fold(0, (p, c) => p + c);
    return x;
  }
}

/// FormGroup que maneja los titulos.
/// La criticidad es 0
class TituloFormGroup extends FormGroup implements BloqueDeFormulario {
  final Titulo titulo;

  TituloFormGroup(this.titulo) : super({});

  @override
  double get criticidad => 0;

  @override
  double get criticidadReparacion => 0;
}

RespuestasCompanion crearRespuestaPorDefecto(int preguntaId) =>
    RespuestasCompanion.insert(
      inspeccionId: null, //! agregar la inspeccion en el guardado de la db
      preguntaId: preguntaId,
      observacion: const Value(''),
      fotosBase: Value(listOf()),
      reparado: const Value(false),
      observacionReparacion: const Value(""),
      fotosReparacion: Value(listOf()),
    );

abstract class BloqueDeFormulario {
  double get criticidad;
  double get criticidadReparacion;
}
