import 'dart:io';

import 'package:inspecciones/application/crear_cuestionario_form/bloques_de_formulario.dart';
import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'bloques_de_ejemplo.dart';

//TODO: agregar todas las validaciones necesarias

class FormLlenadoViewModel {
  final _db = getIt<Database>();

  final String _vehiculo;
  final int _cuestionarioId;

  final form = FormGroup({});

  final bloques = bloquesDeEjemplo;

  List bloquesMutables;

  FormLlenadoViewModel(this._vehiculo, this._cuestionarioId) {
    form.addAll({
      'bloques': bloques,
    });
  }
  Future cargarDatos() async {
    final Inspeccion inspeccion = _db.getInspeccion(_vehiculo, _cuestionarioId);

    final List<BloqueConTitulo> titulos = await _db.getTitulos(inspeccion);

    final List<BloqueConPreguntaRespondida> preguntasSimples =
        await _db.getPreguntasSimples(inspeccion);

    final List<BloqueConCuadricula> cuadriculas =
        await _db.getCuadriculas(inspeccion);

    bloquesMutables = ([...titulos, ...preguntasSimples, ...cuadriculas]
          ..sort((a, b) => a.bloque.nOrder.compareTo(b.bloque.nOrder)))
        .map((e) => FormControl())
        .toList();
  }
}

class RespuestaSeleccionSimpleFormGroup extends FormGroup {
  final PreguntaConOpcionesDeRespuesta preguntaConOpcionesDeRespuesta;
  final RespuestaConOpcionesDeRespuesta respuesta;

  //constructor que le envia los controles a la clase padre
  RespuestaSeleccionSimpleFormGroup._(
      controles, this.preguntaConOpcionesDeRespuesta, this.respuesta)
      : super(controles);

  factory RespuestaSeleccionSimpleFormGroup(
      PreguntaConOpcionesDeRespuesta preguntaConOpcionesDeRespuesta,
      RespuestaConOpcionesDeRespuesta respuesta) {
    respuesta.respuesta ??= RespuestasCompanion.insert(
      //TODO: pendiente de https://github.com/simolus3/moor/issues/960
      inspeccionId: null, //! agregar la inspeccion en el guardado de la db
      preguntaId: preguntaConOpcionesDeRespuesta.pregunta.id,
      fotosBase: Value([]),
      reparado: Value(false),
    );

    final Map<String, AbstractControl<dynamic>> controles = {
      'respuesta': FormControl<OpcionDeRespuesta>(
        value: preguntaConOpcionesDeRespuesta.opcionesDeRespuesta.firstWhere(
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
      preguntaConOpcionesDeRespuesta,
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

    return preguntaConOpcionesDeRespuesta.pregunta.criticidad * sumres;
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
