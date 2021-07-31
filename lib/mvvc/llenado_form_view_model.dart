import 'package:flutter/foundation.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/llenado_controls.dart';
import 'package:kt_dart/collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'llenado_datos_test.dart';

/// Validaciones para el llenado de inspección.
class LlenadoFormViewModel extends ChangeNotifier {
  final _db = getIt<Database>();

  /// Evita un error porque se tienen que cargar los bloques.
  final ValueNotifier<bool> cargada = ValueNotifier(false);
  final ValueNotifier<EstadoDeInspeccion> estado =
      ValueNotifier(EstadoDeInspeccion.borrador);

  /// Por defecto es una inspección desde 0.
  final esNueva = ValueNotifier<bool>(true);
  final int _activo;
  final int cuestionarioId;

  /// Si fue guardado por primera vez.
  final fueGuardado = ValueNotifier<bool>(false);
  final form = FormGroup({});
  //FormArray bloques = bloquesDeEjemplo;
  FormArray bloques;
  //List bloquesMutables;

  LlenadoFormViewModel(
    this._activo,
    this.cuestionarioId,
  ) {
    /*form.addAll({
      'bloques': bloques,
    });*/
    cargarDatos();
  }

  Future cargarDatos() async {
    /// Se usa para instanciar los valores de [fueGuardado], [estado] y [esNueva].
    final inspeccion =
        await _db.llenadoDao.getInspeccion(_activo, cuestionarioId);
    if (inspeccion?.momentoBorradorGuardado != null) {
      fueGuardado.value = true;
    }
    estado.value = inspeccion?.estado ?? EstadoDeInspeccion.borrador;

    /// Si es false, los textFields tienen readOnly =  True.
    esNueva.value = inspeccion?.esNueva ?? true;
    final bloquesBD =
        await _db.llenadoDao.cargarInspeccion(cuestionarioId, _activo);

    //ordenamiento y creacion de los controles dependiendo del tipo de elemento
    bloques = FormArray(
      (bloquesBD
            ..sort(
              (a, b) => a.nOrden.compareTo(b.bloque.nOrden),
            ))
          .map<AbstractControl>((e) {
        if (e is BloqueConTitulo) return TituloFormGroup(e.titulo);
        /*   if (e is BloqueConCondicional) {
          esCondicional.value = true;
          return RespuestaSeleccionSimpleFormGroup(e.pregunta, e.respuesta,
              condiciones: e.condiciones, bloque: e.bloque);
        } */
        if (e is BloqueConPreguntaSimple) {
          return RespuestaSeleccionSimpleFormGroup(e.pregunta, e.respuesta);
        }
        if (e is BloqueConCuadricula) {
          return RespuestaCuadriculaFormArray(
              e.cuadricula, e.preguntasRespondidas);
        }
        if (e is BloqueConPreguntaNumerica) {
          return RespuestaNumericaFormGroup(
              e.pregunta.pregunta, e.respuesta, e.pregunta.criticidades);
        }
        throw Exception("Tipo de bloque no reconocido");
      }).toList(),
    );

    form.addAll({
      'bloques': bloques,
    });
    cargada.value = true;
  }

  /// Guarda la inspección en la bd.
  Future guardarInspeccionEnLocal({
    @required EstadoDeInspeccion estado,
    @required double criticidadTotal,
    @required double criticidadReparacion,
  }) async {
    form.markAllAsTouched();
    List<List<RespuestaConOpcionesDeRespuesta>> respuestas;

    /// Procesa los FormGroups, y devuelve bloques que puedemanejar la Bd
    respuestas =
        bloques.controls.expand<List<RespuestaConOpcionesDeRespuesta>>((e) {
      if (e is TituloFormGroup) return [];
      if (e is RespuestaSeleccionSimpleFormGroup) return [e.toDB()];
      if (e is RespuestaCuadriculaFormArray) return e.toDB();
      if (e is RespuestaNumericaFormGroup) {
        return [
          [e.toDB()]
        ];
      }
      throw Exception("Tipo de control no reconocido");
    }).toList();
    await _db.llenadoDao.guardarInspeccion(respuestas, cuestionarioId, _activo,
        estado, criticidadTotal, criticidadReparacion);
  }

  @override
  void dispose() {
    cargada.dispose();
    estado.dispose();
    form.dispose();
    super.dispose();
  }
}
