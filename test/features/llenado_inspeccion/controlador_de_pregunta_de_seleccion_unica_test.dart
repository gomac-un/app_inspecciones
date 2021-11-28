@Timeout(Duration(seconds: 5))

import 'package:inspecciones/features/llenado_inspecciones/control/controlador_llenado_inspeccion.dart';
import 'package:inspecciones/features/llenado_inspecciones/control/controladores_de_pregunta/controlador_de_pregunta_de_seleccion_unica.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/bloques/preguntas/opcion_de_respuesta.dart';
import 'package:inspecciones/features/llenado_inspecciones/domain/bloques/preguntas/pregunta_de_seleccion_unica.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockControladorLlenadoInspeccion extends Mock
    implements ControladorLlenadoInspeccion {}

void main() {
  late ControladorDePreguntaDeSeleccionUnica control;
  late OpcionDeRespuesta opcion1;
  late OpcionDeRespuesta opcion2;

  setUp(() async {
    opcion1 = OpcionDeRespuesta(
        id: "1",
        titulo: "titop1",
        descripcion: "",
        criticidad: 1,
        requiereCriticidadDelInspector: false);

    opcion2 = OpcionDeRespuesta(
        id: "2",
        titulo: "titop2",
        descripcion: "",
        criticidad: 2,
        requiereCriticidadDelInspector: true);

    final pregunta = PreguntaDeSeleccionUnica(
      [opcion1, opcion2],
      id: "1",
      titulo: "tit",
      descripcion: "desc",
      fotosGuia: [],
      criticidad: 2,
      etiquetas: [],
    );

    final controlInspeccion = MockControladorLlenadoInspeccion();
    control =
        ControladorDePreguntaDeSeleccionUnica(pregunta, controlInspeccion);
  });

  test('test controlador de seleccion unica', () async {
    // un false al primer listen, un false al seleccionar opcion1, true al
    //seleccionar opcion2 y donde por el dispose
    expect(control.requiereCriticidadDelInspector,
        emitsInOrder([false, false, true, emitsDone]));

    expect(control.criticidadRespuesta, emitsInOrder([null, 1, 2, emitsDone]));

    // valores por defecto
    expect(control.requiereCriticidadDelInspector.value, false);
    expect(control.criticidadRespuesta.value, null);

    // seleccionar opcion1
    control.respuestaEspecificaControl.value = opcion1;
    await Future.delayed(const Duration(seconds: 0));
    expect(control.requiereCriticidadDelInspector.value, false);
    expect(control.criticidadRespuesta.value, 1);

    // nuevo listener luego de una interaccion
    expect(control.criticidadRespuesta, emitsInOrder([1, 2, emitsDone]));

    // segunda opinion
    control.criticidadRespuesta.listen(
      expectAsync1((c) {
        expect(c, isIn([1, 2]));
      }, count: 2),
    );

    final terceraOpinion = <int?>[];
    control.criticidadRespuesta.listen((v) {
      terceraOpinion.add(v);
    });

    // seleccionar opcion2
    control.respuestaEspecificaControl.value = opcion2;
    await Future.delayed(const Duration(seconds: 0));
    expect(control.requiereCriticidadDelInspector.value, true);
    expect(control.criticidadRespuesta.value, 2);

    control.dispose();
    await Future.delayed(const Duration(seconds: 0));

    expect(terceraOpinion, [1, 2]);
  });

  test('test value streams de controlador de pregunta', () async {
    // 1 para el valor por defecto y 1 por cada cambio de respuesta especifica
    expect(control.momentoRespuesta.fold<int>(0, (p, _) => p + 1),
        completion(equals(4)));

    expect(
        control.criticidadRespuesta, emitsInOrder([null, 1, 2, 1, emitsDone]));
    expect(control.requiereCriticidadDelInspector,
        emitsInOrder([false, false, true, false, emitsDone]));
    expect(control.criticidadDelInspectorControl.valueChanges,
        emitsInOrder([2, emitsDone]));

    final terceraOpinion = <int?>[];
    control.criticidadCalculada.listen((v) {
      terceraOpinion.add(v);
    });
    // 0 por defecto al escuchar, 0 inesperado antes de encolar la opcion1
    // 2 por la opcion1, 2 se repite inesperadamente con los mismos datos,
    // 4 por la opcion2 pero sin parar en el breakpoint y sin tener en cuenta el
    // bool de criticidad del inspector requerida, 2 al tener en cuenta el bool,
    // 3 luego de aumentar la criticidad del inspector, 1 al seleccionar la opcion 1 sin tener en cuenta el bool,
    // 2 al tener en cuenta el bool
    expect(control.criticidadCalculada,
        emitsInOrder([0, 0, 2, 2, 4, 2, 3, 1, 2, emitsDone]));

    /*
    expect(control.criticidadCalculadaConReparaciones,
        emitsInOrder([0, 2, 4, 3, 0, 0, emitsDone]));*/

    const duration = Duration(milliseconds: 50);
    expect(control.criticidadCalculada.value, 0);
    print(1);
    // evento 1 selecciona opcion 1
    control.respuestaEspecificaControl.value = opcion1;
    await Future.delayed(duration);
    expect(control.criticidadRespuesta.value, 1);
    expect(control.criticidadCalculada.value, 2);
    expect(control.criticidadCalculadaConReparaciones.value, 2);

    expect(control.criticidadCalculada,
        emitsInOrder([2, 4, 2, 3, 1, 2, emitsDone]));

    print(2);
    // evento 2 selecciona opcion 2, esta opcion requiere criticidad del inspector,
    //la cual por defecto es 1 y reduciendola a la mitad por el porcentaje calculado
    control.respuestaEspecificaControl.value = opcion2;
    await Future.delayed(duration);
    expect(control.criticidadRespuesta.value, 2);
    expect(control.criticidadCalculada.value, 2);
    expect(control.criticidadCalculadaConReparaciones.value, 2);

    print(3);
    // evento 3 aumenta criticidad del inspector
    control.criticidadDelInspectorControl.value = 2;
    await Future.delayed(duration);
    expect(control.criticidadCalculada.value, 3);
    expect(control.criticidadCalculadaConReparaciones.value, 3);

    print(4);
    // evento 4 activa reparacion
    control.reparadoControl.value = true;
    await Future.delayed(duration);
    expect(control.criticidadCalculada.value, 3);
    expect(control.criticidadCalculadaConReparaciones.value, 0);

    print(5);
    //evento 5 selecciona opcion 1
    control.respuestaEspecificaControl.value = opcion1;
    await Future.delayed(duration);
    expect(control.criticidadCalculada.value, 2);
    expect(control.criticidadCalculadaConReparaciones.value, 0);

    control.dispose();
    await Future.delayed(duration);
    expect(terceraOpinion, [0, 0, 2, 2, 4, 2, 3, 1, 2]);

  });
}
