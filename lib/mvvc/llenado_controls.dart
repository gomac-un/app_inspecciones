import 'dart:ffi';
import 'dart:io';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/daos/llenado_dao.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:kt_dart/kt.dart';
import 'package:reactive_forms/reactive_forms.dart';

//TODO: implementar estos controles como sealed classes
class RespuestaSeleccionSimpleFormGroup extends FormGroup
    implements BloqueDeFormulario {
  final PreguntaConOpcionesDeRespuesta pregunta;
  final RespuestaConOpcionesDeRespuesta respuesta;
  DateTime _momentoRespuesta;

  factory RespuestaSeleccionSimpleFormGroup(
      PreguntaConOpcionesDeRespuesta pregunta,
      RespuestaConOpcionesDeRespuesta respuesta) {
    // La idea era que los companions devolvieran los valores por defecto pero no es asi
    // https://github.com/simolus3/moor/issues/960
    // entonces aca se asignan definen nuevo los valores por defecto que son usados
    // cuando se inicia una nueva inspeccion
    respuesta.respuesta ??= crearRespuestaPorDefecto(pregunta.pregunta.id);

    FormControl respuestas;
    //TODO: hacer un switch para pregunta.pregunta.tipo
    if (pregunta.pregunta.tipo == TipoDePregunta.multipleRespuesta) {
      respuestas = FormControl<List<OpcionDeRespuesta>>(
        value: pregunta.opcionesDeRespuesta
            .where(
              (opcion) =>
                  respuesta.opcionesDeRespuesta?.any((res) => res == opcion) ??
                  false,
            )
            .toList(),
        validators: [Validators.minLength(1)],
      );
    }
    if (pregunta.pregunta.tipo == TipoDePregunta.unicaRespuesta ||
        pregunta.pregunta.tipo == TipoDePregunta.parteDeCuadriculaUnica) {
      respuestas = FormControl<OpcionDeRespuesta>(
        value: pregunta.opcionesDeRespuesta.firstWhere(
          (e) => respuesta.opcionesDeRespuesta?.first == e,
          orElse: () => null,
        ),
        validators: [Validators.required],
      );
    }
    if (respuestas == null) {
      throw Exception("Este form group no puede manejar este tipo de pregunta");
    }

    final Map<String, AbstractControl<dynamic>> controles = {
      'respuestas': respuestas,
      'observacion': fb.control<String>(respuesta.respuesta.observacion.value),
      'fotosBase': fb.array<File>(
        respuesta.respuesta.fotosBase.value
            .map((e) => FormControl(value: File(e)))
            .iter
            .toList(),
      ),
      'reparado': fb.control<bool>(respuesta.respuesta.reparado.value),
      'observacionReparacion':
          fb.control<String>(respuesta.respuesta.observacionReparacion.value),
      'fotosReparacion': fb.array<File>(
        respuesta.respuesta.fotosReparacion.value
            .map((e) => FormControl(value: File(e)))
            .iter
            .toList(),
      ),
    };

    return RespuestaSeleccionSimpleFormGroup._(
      controles,
      pregunta,
      respuesta,
    );
  }
  //constructor que le envia los controles a la clase padre
  RespuestaSeleccionSimpleFormGroup._(
      Map<String, AbstractControl> controles, this.pregunta, this.respuesta)
      : super(controles) {
    valueChanges.listen((_) => _momentoRespuesta =
        DateTime.now()); //guarda el momento de la ultima edicion
  }

  @override
  int get criticidad {
    /*TODO: calcular la criticidad de las multiples con las reglas de
      * Sebastian o hacerlo en la bd dejando esta criticidad como axiliar 
      * solo para la pantalla de arreglos
      */
    int sumres;

    switch (pregunta.pregunta.tipo) {
      case TipoDePregunta.multipleRespuesta:
        sumres = (control('respuestas') as FormControl<List<OpcionDeRespuesta>>)
            .value
            .fold(0, (p, c) => p + c.criticidad);
        break;
      case TipoDePregunta.unicaRespuesta:
        sumres = (control('respuestas') as FormControl<OpcionDeRespuesta>)
            .value
            .criticidad;
        break;
      case TipoDePregunta.parteDeCuadriculaUnica:
        sumres = (control('respuestas') as FormControl<OpcionDeRespuesta>)
            .value
            .criticidad;
        break;
      default:
        throw Exception("tipo de pregunta no esperado");
    }

    return pregunta.pregunta.criticidad * sumres;
  }

  RespuestaConOpcionesDeRespuesta toDB() {
    List<OpcionDeRespuesta> respuestas;
    switch (pregunta.pregunta.tipo) {
      case TipoDePregunta.multipleRespuesta:
        respuestas = control('respuestas').value as List<OpcionDeRespuesta>;
        break;
      case TipoDePregunta.unicaRespuesta:
        respuestas = [control('respuestas').value as OpcionDeRespuesta];
        break;
      case TipoDePregunta.parteDeCuadriculaUnica:
        respuestas = [control('respuestas').value as OpcionDeRespuesta];
        break;
      default:
        throw Exception("tipo de pregunta no esperado");
    }

    return RespuestaConOpcionesDeRespuesta(
      respuesta.respuesta.copyWith(
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
        momentoRespuesta: Value(_momentoRespuesta),
      ),
      respuestas,
    );
  }
}

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

    if (respuesta.preguntaId == null) {
      respuesta = crearRespuestaPorDefecto(pregunta.id);
    }

    final FormControl respuestas = FormControl<OpcionesDeRespuesta>();
    print('Hola otra vez');
    print(criticidades);

    //TODO: hacer un switch para pregunta.pregunta.tipo
    final Map<String, AbstractControl<dynamic>> controles = {
      'respuesta': respuestas,
      'valor': fb.control<double>(respuesta.valor.value, [Validators.required]),
      'observacion': fb.control<String>(respuesta.observacion.value),
      'fotosBase': fb.array<File>(
        respuesta.fotosBase.value
            .map((e) => FormControl(value: File(e)))
            .iter
            .toList(),
      ),
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

  int lulu(
    double respuesta,
    CriticidadesNumerica criticidades,
  ) {
    if (respuesta > criticidades.valorMinimo &&
        respuesta < criticidades.valorMaximo) {
      return criticidades.criticidad;
    }
    return 0;
  }

  @override
  int get criticidad {
    /*TODO: calcular la criticidad de las multiples con las reglas de
      * Sebastian o hacerlo en la bd dejando esta criticidad como axiliar 
      * solo para la pantalla de arreglos
      */
    final double respuesta = (control('valor') as FormControl<double>).value;

    final int criRes =
        criticidades?.map((cri) => lulu(respuesta, cri))?.toList()[0];

    return pregunta.criticidad * criRes;
  }

  RespuestaConOpcionesDeRespuesta toDB() {
    List<OpcionDeRespuesta> respuestas;
    respuestas = [control('respuesta').value as OpcionDeRespuesta];
    final double campo = control('valor').value as double;
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
        momentoRespuesta: Value(_momentoRespuesta),
      ),
      respuestas,
    );
  }
}

class RespuestaCuadriculaFormArray extends FormArray
    implements BloqueDeFormulario {
  final CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula;
  final List<PreguntaConRespuestaConOpcionesDeRespuesta> preguntasRespondidas;

  factory RespuestaCuadriculaFormArray(
    CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula,
    List<PreguntaConRespuestaConOpcionesDeRespuesta> preguntasRespondidas,
  ) {
    for (final e in preguntasRespondidas) {
      e.respuesta.respuesta ??= crearRespuestaPorDefecto(e.pregunta.id);
    }

    final List<RespuestaSeleccionSimpleFormGroup> controles =
        preguntasRespondidas
            .map((e) => RespuestaSeleccionSimpleFormGroup(
                PreguntaConOpcionesDeRespuesta(
                  e.pregunta,
                  cuadricula.opcionesDeRespuesta,
                ),
                e.respuesta))
            .toList(); //TODO: seleccion multiple

    return RespuestaCuadriculaFormArray._(
      controles,
      cuadricula,
      preguntasRespondidas,
    );
  }
  RespuestaCuadriculaFormArray._(List<AbstractControl> controles,
      this.cuadricula, this.preguntasRespondidas)
      : super(controles);

  List<RespuestaConOpcionesDeRespuesta> toDB([int inspeccionId]) {
    return controls.map((d) {
      final e = d as RespuestaSeleccionSimpleFormGroup;
      return e.toDB();
    }).toList();
  }

  @override
  int get criticidad {
    /*TODO: calcular la criticidad de las multiples con las reglas de
      * Sebastian o hacerlo en la bd dejando esta criticidad como axiliar 
      * solo para la pantalla de arreglos
      */

    return controls.map((d) {
      final e = d as RespuestaSeleccionSimpleFormGroup;
      final ctrlPregunta =
          e.control('respuestas') as FormControl<OpcionDeRespuesta>;
      return e.pregunta.pregunta.criticidad * ctrlPregunta.value.criticidad;
    }).fold(0, (p, c) => p + c);

    //return pregunta.pregunta.criticidad * sumres;
  }
}

class TituloFormGroup extends FormGroup implements BloqueDeFormulario {
  final Titulo titulo;

  TituloFormGroup(this.titulo) : super({});

  @override
  int get criticidad => 0;
}

RespuestasCompanion crearRespuestaPorDefecto(int preguntaId) =>
    RespuestasCompanion.insert(
      inspeccionId: null, //! agregar la inspeccion en el guardado de la db
      preguntaId: preguntaId,
      observacion: const Value(' '),
      fotosBase: Value(listOf()),
      reparado: const Value(false),
      observacionReparacion: const Value(" "),
      fotosReparacion: Value(listOf()),
    );

abstract class BloqueDeFormulario {
  int get criticidad;
}
