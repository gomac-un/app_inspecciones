import 'dart:io';
import 'package:collection/collection.dart';
import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:kt_dart/kt.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:path/path.dart' as path;

//TODO: agregarle todas las validaciones necesarias a los campos
//TODO: implementar estos controles como sealed classes
class RespuestaSeleccionSimpleFormGroup extends FormGroup {
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

    final respuestas = FormArray<OpcionDeRespuesta>(
      pregunta.opcionesDeRespuesta
          .where(
            (opcion) =>
                respuesta.opcionesDeRespuesta?.any((res) => res == opcion) ??
                false,
          )
          .map((e) => FormControl(value: e))
          .toList(),
    );
    if (respuestas.value.length == 0 &&
        pregunta.pregunta.tipo == TipoDePregunta.unicaRespuesta)
      respuestas.value = [
        null
      ]; //si no hay respuestas agrega un control vacio porque la seleccion unica lo necesita

    final Map<String, AbstractControl<dynamic>> controles = {
      'respuestas': respuestas,
      'observacion':
          FormControl<String>(value: respuesta.respuesta.observacion.value),
      'fotosBase': FormArray(
        respuesta.respuesta.fotosBase.value
            .map((e) => FormControl(value: File(e)))
            .iter
            .toList(),
      ),
      'reparado': FormControl<bool>(value: respuesta.respuesta.reparado.value),
      'observacionReparacion': FormControl<String>(
          value: respuesta.respuesta.observacionReparacion.value),
      'fotosReparacion': FormArray(
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
  get criticidad {
    int sumres = 0;
    if (control('respuesta').value is Iterable) {
      /*TODO: calcular la criticidad de las multiples con las reglas de
      * Sebastian o hacerlo en la bd dejando esta criticidad como axiliar 
      * solo para la pantalla de arreglos
      */
      control('respuesta').value.forEach((e) {
        sumres += e.criticidad;
      });
    } else {
      sumres = control('respuesta').value.criticidad;
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
      (control('respuestas') as FormArray<OpcionDeRespuesta>)
          .controls
          .map((e) => e.value)
          .toList(),
    );
  }
}

class RespuestaCuadriculaFormArray extends FormArray<OpcionDeRespuesta> {
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

    final List<FormControl> controles = preguntasRespondidas
        .map(
          (e) => FormControl<OpcionDeRespuesta>(
            value: cuadricula.opcionesDeRespuesta.firstWhere(
              (e1) => e1 == e.respuesta.opcionesDeRespuesta?.first,
              orElse: () => null,
            ),
          ),
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
    /*return IterableZip([preguntasRespondidas, controls]).map((e) {
      final pregunta = e[0] as PreguntaConRespuestaConOpcionesDeRespuesta;
      final ctrlPregunta = e[1] as FormControl<OpcionDeRespuesta>;
      return pregunta.respuesta
          .respuesta; //pregunta.respuesta.respuesta.copyWith(momentoRespuesta: Value(_momento));
    }).toList();*/
  }
}

class TituloFormGroup extends FormGroup {
  final Titulo titulo;

  TituloFormGroup(this.titulo) : super({});
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
