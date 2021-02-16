import 'package:flutter/foundation.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/llenado_controls.dart';
import 'package:kt_dart/collection.dart';
import 'package:kt_dart/kt.dart';
import 'package:reactive_forms/reactive_forms.dart';

part 'llenado_datos_test.dart';

//TODO: verificar y asociar al usuario
class LlenadoFormViewModel extends ChangeNotifier {
  final _db = getIt<Database>();

  final ValueNotifier<bool> cargada = ValueNotifier(false);
  final ValueNotifier<EstadoDeInspeccion> estado =
      ValueNotifier(EstadoDeInspeccion.borrador);
  final ValueNotifier<bool> esCondicional = ValueNotifier(false);

  final int _activo;
  final int cuestionarioId;

  final form = FormGroup({});

  //FormArray bloques = bloquesDeEjemplo;
  FormArray bloques;
  ValueNotifier<List<AbstractControl<dynamic>>> bloques1;
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
    final inspeccion =
        await _db.llenadoDao.getInspeccion(_activo, cuestionarioId);
    estado.value = inspeccion?.estado ?? EstadoDeInspeccion.borrador;

    final bloquesBD =
        await _db.llenadoDao.cargarCuestionario(cuestionarioId, _activo);

    //ordenamiento y creacion de los controles dependiendo del tipo de elemento
    bloques = FormArray(
      (bloquesBD
            ..sort(
              (a, b) => a.nOrden.compareTo(b.bloque.nOrden),
            ))
          .map<AbstractControl>((e) {
        if (e is BloqueConTitulo) return TituloFormGroup(e.titulo);
        if (e is BloqueConCondicional) {
          esCondicional.value = true;
          return RespuestaSeleccionSimpleFormGroup(e.pregunta, e.respuesta,
              condiciones: e.condiciones, bloque: e.bloque);
        }
        if (e is BloqueConPreguntaSimple) {
          return RespuestaSeleccionSimpleFormGroup(e.pregunta, e.respuesta);
        }
        if (e is BloqueConCuadricula) {
          return RespuestaCuadriculaFormArray(
              e.cuadricula, e.preguntasRespondidas);
        }
        if (e is BloqueConPreguntaNumerica) {
          return RespuestaNumericaFormGroup(
              e.pregunta, e.respuesta, e.criticidades);
        }
        throw Exception("Tipo de bloque no reconocido");
      }).toList(),
    );

    form.addAll({
      'bloques': bloques,
    });
    cargada.value = true;
    bloques1 = ValueNotifier(bloques.controls);
  }

  Future guardarInspeccionEnLocal({@required EstadoDeInspeccion estado}) async {
    form.markAllAsTouched();

    final respuestas =
        bloques.controls.expand<RespuestaConOpcionesDeRespuesta>((e) {
      if (e is TituloFormGroup) return [];
      if (e is RespuestaSeleccionSimpleFormGroup) return [e.toDB()];
      if (e is RespuestaCuadriculaFormArray) return e.toDB();
      if (e is RespuestaNumericaFormGroup) return [e.toDB()];
      throw Exception("Tipo de control no reconocido");
    }).toList();

    await _db.llenadoDao
        .guardarInspeccion(respuestas, cuestionarioId, _activo, estado);
  }

  void finalizar() {
    //TODO: implementar
    form.markAllAsTouched();
  }

  void dispose() {
    cargada.dispose();
    estado.dispose();
    form.dispose();
  }


  //TODO: hacer esta parte menos a lo fundamentos de programación.

  final List<AbstractControl<dynamic>> subListaDeApoyo = [];
  final List<int> ultimaSeccion = [1];

  void borrarBloque(int bloqueInicial, int bloqueFinal) {
    print('inicial: $bloqueInicial final: $bloqueFinal');
    //TODO hacerle dispose si se requiere
    final element = bloques.controls.elementAt(bloqueInicial + 1);
    try {
      if (subListaDeApoyo.contains(element) &&
          bloqueFinal <= ultimaSeccion.last) {
        for (int i = bloqueInicial + 1; i <= ultimaSeccion.last; i++) {
          final x = bloques.controls.elementAt(i);
          if (x is RespuestaSeleccionSimpleFormGroup) {
            x.control('respuestas').setErrors({'required': true});
          }
          if (x is RespuestaNumericaFormGroup) {
            x.control('valor').setErrors({'required': true});
          }
          subListaDeApoyo.remove(element);
          subListaDeApoyo.remove(x);
        }
      }
      final subLista = bloques.controls.sublist(bloqueInicial + 1, bloqueFinal);
      subListaDeApoyo.addAll(subLista);
      bloques1 = ValueNotifier(
          bloques.controls.where((x) => !subListaDeApoyo.contains(x)).toList());
      /* bloques.controls.where((x) => subListaDeApoyo.contains(x)).map((x) => x.); */
      bloques.controls.forEach((x) => {
            if (subListaDeApoyo.contains(x))
              {
                if (x is RespuestaSeleccionSimpleFormGroup)
                  {x.control('respuestas').removeError('required'), print('se borró')},
                if (x is RespuestaNumericaFormGroup)
                  {x.control('valor').removeError('required'), print('se borró numerica')}
              },
            
          });
      ultimaSeccion.add(bloqueFinal);
      bloques1.notifyListeners();
      // ignore: empty_catches
    } on FormControlNotFoundException {}
  }

}
