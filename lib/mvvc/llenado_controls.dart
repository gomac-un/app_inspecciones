import 'dart:io';

import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:reactive_forms/reactive_forms.dart';

class RespuestaSeleccionSimpleFormGroup extends FormGroup {
  final PreguntaConOpcionesDeRespuesta pregunta;
  final RespuestaConOpcionesDeRespuesta respuesta;

  //constructor que le envia los controles a la clase padre
  RespuestaSeleccionSimpleFormGroup._(controles, this.pregunta, this.respuesta)
      : super(controles);

  factory RespuestaSeleccionSimpleFormGroup(
      PreguntaConOpcionesDeRespuesta pregunta,
      RespuestaConOpcionesDeRespuesta respuesta) {
    respuesta.respuesta ??= RespuestasCompanion.insert(
      //TODO: pendiente de https://github.com/simolus3/moor/issues/960
      inspeccionId: null, //! agregar la inspeccion en el guardado de la db
      preguntaId: pregunta.pregunta.id,
      fotosBase: Value([]),
      reparado: Value(false),
    );

    final Map<String, AbstractControl<dynamic>> controles = {
      'respuesta': FormControl<OpcionDeRespuesta>(
        value: pregunta.opcionesDeRespuesta.firstWhere(
          (e) => respuesta.opcionesDeRespuesta?.first?.id == e?.id,
          orElse: () => null,
        ), //TODO: multiples respuestas
      ),
      'observacion':
          FormControl<String>(value: respuesta.respuesta.observacion.value),
      'fotosBase': FormArray(
        respuesta.respuesta.fotosBase.value
            .map((e) => FormControl(value: File(e)))
            .toList(),
      ),
      'reparado': FormControl<bool>(value: respuesta.respuesta.reparado.value),
      'observacionReparacion': FormControl<String>(
          value: respuesta.respuesta.observacionReparacion.value),
      'fotosReparacion': FormArray(
        respuesta.respuesta.fotosReparacion.value
            .map((e) => FormControl(value: File(e)))
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
      e.respuesta.respuesta ??= RespuestasCompanion.insert(
        inspeccionId: null, //! agregar la inspeccion en el guardado de la db
        preguntaId: e.pregunta.id,
      );
    });

    final List<FormControl> controles = preguntasRespondidas
        .map(
          (e) => FormControl<OpcionDeRespuesta>(
            value: cuadricula.opcionesDeRespuesta.firstWhere(
              (e1) => e1.id == e.respuesta.opcionesDeRespuesta?.first?.id,
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
}

class TituloFormGroup extends FormGroup {
  final Titulo titulo;

  TituloFormGroup(this.titulo) : super({});
}
