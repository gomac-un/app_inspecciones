import 'dart:io';
import 'package:collection/collection.dart';
import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:kt_dart/kt.dart';
import 'package:reactive_forms/reactive_forms.dart';

//TODO: agregarle todas las validaciones necesarias a los campos
//TODO: implementar estos controles como sealed classes
class RespuestaSeleccionSimpleFormGroup extends FormGroup
    implements BloqueDeFormulario {
  final PreguntaConOpcionesDeRespuesta pregunta;
  final RespuestaConOpcionesDeRespuesta respuesta;
  DateTime _momentoRespuesta;

  //constructor que le envia los controles a la clase padre
  RespuestaSeleccionSimpleFormGroup._(controles, this.pregunta, this.respuesta)
      : super(controles) {
    this.valueChanges.listen((_) => _momentoRespuesta =
        DateTime.now()); //guarda el momento de la ultima edicion
  }

  factory RespuestaSeleccionSimpleFormGroup(
      PreguntaConOpcionesDeRespuesta pregunta,
      RespuestaConOpcionesDeRespuesta respuesta) {
    // La idea era que los companions devolvieran los valores por defecto pero no es asi
    // https://github.com/simolus3/moor/issues/960
    // entonces aca se asignan definen nuevo los valores por defecto que son usados
    // cuando se inicia una nueva inspeccion
    respuesta.respuesta ??= respuestaPorDefectoBuilder(pregunta.pregunta.id);

    FormControl respuestas;

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
    if (pregunta.pregunta.tipo == TipoDePregunta.unicaRespuesta) {
      respuestas = FormControl<OpcionDeRespuesta>(
        value: pregunta.opcionesDeRespuesta.firstWhere(
          (e) => respuesta.opcionesDeRespuesta?.first == e,
          orElse: () => null,
        ),
        validators: [Validators.required],
      );
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

  @override
  get criticidad {
    /*TODO: calcular la criticidad de las multiples con las reglas de
      * Sebastian o hacerlo en la bd dejando esta criticidad como axiliar 
      * solo para la pantalla de arreglos
      */
    int sumres;
    if (pregunta.pregunta.tipo == TipoDePregunta.multipleRespuesta) {
      sumres = (control('respuestas') as FormControl<List<OpcionDeRespuesta>>)
          .value
          .fold(0, (p, c) => p + c.criticidad);
    }
    if (pregunta.pregunta.tipo == TipoDePregunta.unicaRespuesta) {
      sumres = (control('respuestas') as FormControl<OpcionDeRespuesta>)
          .value
          .criticidad;
    }

    return pregunta.pregunta.criticidad * sumres;
  }

  RespuestaConOpcionesDeRespuesta toDB() {
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
        observacion: Value(control('observacion').value),
        reparado: Value(control('reparado').value),
        observacionReparacion: Value(control('observacionReparacion').value),
        momentoRespuesta: Value(_momentoRespuesta),
      ),
      [
        if (pregunta.pregunta.tipo == TipoDePregunta.multipleRespuesta)
          ...control('respuestas').value,
        if (pregunta.pregunta.tipo == TipoDePregunta.unicaRespuesta)
          control('respuestas').value,
      ],
    );
  }
}

class RespuestaCuadriculaFormArray extends FormArray<OpcionDeRespuesta>
    implements BloqueDeFormulario {
  final CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula;
  final List<PreguntaConRespuestaConOpcionesDeRespuesta> preguntasRespondidas;

  //constructor que le envia los controles a la clase padre
  RespuestaCuadriculaFormArray._(
      controles, this.cuadricula, this.preguntasRespondidas)
      : super(controles);

  factory RespuestaCuadriculaFormArray(
    CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula,
    List<PreguntaConRespuestaConOpcionesDeRespuesta> preguntasRespondidas,
  ) {
    preguntasRespondidas.forEach((e) {
      e.respuesta.respuesta ??= respuestaPorDefectoBuilder(e.pregunta.id);
    });

    final List<FormControl<OpcionDeRespuesta>> controles = preguntasRespondidas
        .map(
          (e) => FormControl<OpcionDeRespuesta>(
              value: cuadricula.opcionesDeRespuesta.firstWhere(
                (e1) => e1 == e.respuesta.opcionesDeRespuesta?.first,
                orElse: () => null,
              ),
              validators: [Validators.required]),
        )
        .toList(); //TODO: seleccion multiple

    return RespuestaCuadriculaFormArray._(
      controles,
      cuadricula,
      preguntasRespondidas,
    );
  }

  List<RespuestaConOpcionesDeRespuesta> toDB([int inspeccionId]) {
    return IterableZip([preguntasRespondidas, controls]).map((e) {
      final pregunta = e[0] as PreguntaConRespuestaConOpcionesDeRespuesta;
      final ctrlPregunta = e[1] as FormControl<OpcionDeRespuesta>;
      return RespuestaConOpcionesDeRespuesta(
        pregunta.respuesta.respuesta,
        [ctrlPregunta.value], //TODO: implementar la seleccion multiple
      );
    }).toList();
  }

  get criticidad {
    /*TODO: calcular la criticidad de las multiples con las reglas de
      * Sebastian o hacerlo en la bd dejando esta criticidad como axiliar 
      * solo para la pantalla de arreglos
      */

    return IterableZip([preguntasRespondidas, controls]).map((e) {
      final pregunta = e[0] as PreguntaConRespuestaConOpcionesDeRespuesta;
      final ctrlPregunta = e[1] as FormControl<OpcionDeRespuesta>;
      return pregunta.pregunta.criticidad * ctrlPregunta.value.criticidad;
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

respuestaPorDefectoBuilder(int preguntaId) => RespuestasCompanion.insert(
      inspeccionId: null, //! agregar la inspeccion en el guardado de la db
      preguntaId: preguntaId,
      observacion: Value(''),
      fotosBase: Value(listOf()),
      reparado: Value(false),
      observacionReparacion: Value(""),
      fotosReparacion: Value(listOf()),
    );

abstract class BloqueDeFormulario {
  int get criticidad;
}
