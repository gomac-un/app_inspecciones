import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../domain/bloque.dart';
import '../domain/bloques/bloques.dart';
import '../domain/bloques/preguntas/opcion_de_respuesta.dart';
import '../domain/cuestionario.dart';
import '../domain/inspeccion.dart';
import '../domain/metarespuesta.dart';
import '../domain/respuesta.dart';

final inspeccionesRepositoryProvider =
    Provider((_) => InspeccionesRepository());

class InspeccionesRepository {
  Future<CuestionarioInspeccionado> cargarInspeccion(int inspeccionId) async {
    print("cargando inspeccion $inspeccionId");
    //await Future.delayed(const Duration(seconds: 1));
    if (inspeccionId == 1) {
      return _inspeccionNueva();
    } else {
      return _inspeccionIniciada();
    }
  }

  Future<CuestionarioInspeccionado> _inspeccionIniciada() {
    final List<OpcionDeRespuesta> opciones = [
      OpcionDeRespuesta(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vehicula quam dui, in lobortis leo accumsan vel. Ut semper augue a erat tempus sagittis. Phasellus orci turpis, laoreet ac est.",
          "",
          1),
      OpcionDeRespuesta("op2", "", 0),
      OpcionDeRespuesta(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam feugiat ullamcorper lacus nec tincidunt. Maecenas.",
          "lalalallala",
          1),
      OpcionDeRespuesta("op4", "", 0),
      OpcionDeRespuesta(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ligula est, suscipit at venenatis at.",
          "yayayayqa",
          1),
      OpcionDeRespuesta("op6", "", 0),
      OpcionDeRespuesta(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In et erat et tellus dapibus lacinia in non quam. Cras et.",
          "ñañañaññañañañaa",
          1),
      OpcionDeRespuesta("op8", "", 0),
      OpcionDeRespuesta(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In et erat et tellus dapibus lacinia in non quam. Cras et.",
          "alalalal",
          1),
      OpcionDeRespuesta("op10", "", 0),
    ];
    late final List<Bloque> bloques = [
      CuadriculaDeSeleccionMultiple(
        [
          PreguntaDeSeleccionMultiple(
            // TODO: hacer que sean las mismas que las de la cuadricula
            opciones,
            opciones
                .map((op) => SubPreguntaDeSeleccionMultiple(
                      op,
                      calificable: false,
                      criticidad: op.criticidad,
                      descripcion: op.descripcion,
                      posicion: '',
                      titulo: op.titulo,
                      respuesta: SubRespuestaDeSeleccionMultiple(
                          MetaRespuesta(),
                          estaSeleccionada: Random().nextBool()),
                    ))
                .toList(),
            titulo: "Mi pregunta unica en cuadricula",
            descripcion:
                "Mi descripcion de la de seleccion unica en cuadricula",
            criticidad: 1,
            posicion: "arriba",
            calificable: true,
            respuesta: RespuestaDeSeleccionMultiple(MetaRespuesta()),
          ),
          PreguntaDeSeleccionMultiple(
            opciones,
            opciones
                .map((op) => SubPreguntaDeSeleccionMultiple(
                      op,
                      calificable: false,
                      criticidad: op.criticidad,
                      descripcion: op.descripcion,
                      posicion: '',
                      titulo: op.titulo,
                      respuesta: SubRespuestaDeSeleccionMultiple(
                          MetaRespuesta(),
                          estaSeleccionada: Random().nextBool()),
                    ))
                .toList(),
            titulo:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec in varius augue. Sed vestibulum sapien laoreet, tempus metus at, malesuada justo. Morbi cursus mi sollicitudin, vestibulum dolor nec, sagittis tellus. Phasellus a erat eget mi mattis ullamcorper. Nunc dignissim arcu eu urna pulvinar faucibus. Praesent ac pharetra odio. Donec pellentesque.",
            descripcion:
                "Mi descripcion de la de seleccion unica en cuadricula",
            criticidad: 1,
            posicion: "arriba",
            calificable: false,
            respuesta: RespuestaDeSeleccionMultiple(MetaRespuesta()),
          ),
        ],
        opciones,
        titulo: "Mi pregunta cuadricula de seleccion unica",
        descripcion: "Mi descripcion de cuadricula de seleccion unica",
        criticidad: 1,
        posicion: "arriba",
        calificable: true,
        respuesta: RespuestaDeCuadriculaDeSeleccionMultiple(
          MetaRespuesta(observaciones: "oberservacion"),
        ),
      ),
      CuadriculaDeSeleccionUnica(
        [
          PreguntaDeSeleccionUnica(
            // TODO: hacer que sean las mismas que las de la cuadricula
            opciones,
            titulo: "Mi pregunta unica en cuadricula",
            descripcion:
                "Mi descripcion de la de seleccion unica en cuadricula",
            criticidad: 1,
            posicion: "arriba",
            calificable: true,
            respuesta: RespuestaDeSeleccionUnica(
              MetaRespuesta(),
              opciones[1],
            ),
          ),
          PreguntaDeSeleccionUnica(
            opciones,
            titulo:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec in varius augue. Sed vestibulum sapien laoreet, tempus metus at, malesuada justo. Morbi cursus mi sollicitudin, vestibulum dolor nec, sagittis tellus. Phasellus a erat eget mi mattis ullamcorper. Nunc dignissim arcu eu urna pulvinar faucibus. Praesent ac pharetra odio. Donec pellentesque.",
            descripcion:
                "Mi descripcion de la de seleccion unica en cuadricula",
            criticidad: 1,
            posicion: "arriba",
            calificable: false,
            respuesta: RespuestaDeSeleccionUnica(
              MetaRespuesta(),
              opciones[2],
            ),
          ),
        ],
        opciones,
        titulo: "Mi pregunta cuadricula de seleccion unica",
        descripcion: "Mi descripcion de cuadricula de seleccion unica",
        criticidad: 1,
        posicion: "arriba",
        calificable: true,
        respuesta: RespuestaDeCuadriculaDeSeleccionUnica(MetaRespuesta()),
      ),
      Titulo(titulo: "El titulo", descripcion: "La descripcion"),
      Titulo(
          titulo: "El otro titulazo " * 10,
          descripcion: "La otra descripcion " * 5),
      PreguntaNumerica(
        [],
        titulo: "Mi pregunta numerica",
        descripcion: "Mi descripcion de la numerica",
        criticidad: 1,
        posicion: "abajo",
        calificable: true,
        respuesta: RespuestaNumerica(
          MetaRespuesta(),
          respuestaNumerica: 0,
        ),
        unidades: "grados",
      ),
      PreguntaDeSeleccionUnica(
        opciones,
        titulo: "Mi pregunta unica",
        descripcion: "Mi descripcion de la de seleccion unica",
        criticidad: 1,
        posicion: "a la derecha",
        calificable: false,
        respuesta: RespuestaDeSeleccionUnica(
          MetaRespuesta(),
          opciones[1],
        ),
      ),
      PreguntaDeSeleccionMultiple(
        opciones,
        opciones
            .map((op) => SubPreguntaDeSeleccionMultiple(
                  op,
                  titulo: op.titulo,
                  descripcion: op.descripcion,
                  criticidad: op.criticidad,
                  posicion: "",
                  calificable: false,
                  respuesta: SubRespuestaDeSeleccionMultiple(
                    MetaRespuesta(),
                    estaSeleccionada: op.titulo.length < 10,
                  ),
                ))
            .toList(),
        titulo: "Mi pregunta de seleccion multiple",
        descripcion: "Mi descripcion de la de seleccion multiple",
        criticidad: 1,
        posicion: "a la izquierda",
        calificable: true,
        respuesta: RespuestaDeSeleccionMultiple(MetaRespuesta()),
      ),
    ];
    final inspeccion = Inspeccion(
      id: 1,
      estado: EstadoDeInspeccion.borrador,
      activo: "123",
    );
    final cuestionario = CuestionarioInspeccionado(
      inspeccion,
      bloques,
      id: 1,
      tipoDeInspeccion: "preoperacional",
    );
    inspeccion.cuestionario = cuestionario;

    return Future.value(cuestionario);
  }

  Future<CuestionarioInspeccionado> _inspeccionNueva() async {
    final List<OpcionDeRespuesta> opciones = [
      OpcionDeRespuesta(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vehicula quam dui, in lobortis leo accumsan vel. Ut semper augue a erat tempus sagittis. Phasellus orci turpis, laoreet ac est.",
          "",
          1),
      OpcionDeRespuesta("op2", "", 1),
      OpcionDeRespuesta(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam feugiat ullamcorper lacus nec tincidunt. Maecenas.",
          "lalalallala",
          1),
      OpcionDeRespuesta("op4", "", 1),
      OpcionDeRespuesta(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ligula est, suscipit at venenatis at.",
          "yayayayqa",
          1),
      OpcionDeRespuesta("op6", "", 1),
      OpcionDeRespuesta(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In et erat et tellus dapibus lacinia in non quam. Cras et.",
          "ñañañaññañañañaa",
          1),
      OpcionDeRespuesta("op8", "", 1),
      OpcionDeRespuesta(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In et erat et tellus dapibus lacinia in non quam. Cras et.",
          "alalalal",
          1),
      OpcionDeRespuesta("op10", "", 1),
    ];
    late final List<Bloque> bloques = [
      Titulo(titulo: "El titulo", descripcion: "La descripcion"),
      CuadriculaDeSeleccionMultiple(
        [
          PreguntaDeSeleccionMultiple(
            // TODO: hacer que sean las mismas que las de la cuadricula
            opciones,
            opciones
                .map((op) => SubPreguntaDeSeleccionMultiple(
                      op,
                      calificable: false,
                      criticidad: op.criticidad,
                      descripcion: op.descripcion,
                      posicion: '',
                      titulo: op.titulo,
                    ))
                .toList(),
            titulo: "Mi pregunta unica en cuadricula",
            descripcion:
                "Mi descripcion de la de seleccion unica en cuadricula",
            criticidad: 1,
            posicion: "arriba",
            calificable: true,
          ),
          PreguntaDeSeleccionMultiple(
            opciones,
            opciones
                .map((op) => SubPreguntaDeSeleccionMultiple(
                      op,
                      calificable: false,
                      criticidad: op.criticidad,
                      descripcion: op.descripcion,
                      posicion: '',
                      titulo: op.titulo,
                    ))
                .toList(),
            titulo:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec in varius augue. Sed vestibulum sapien laoreet, tempus metus at, malesuada justo. Morbi cursus mi sollicitudin, vestibulum dolor nec, sagittis tellus. Phasellus a erat eget mi mattis ullamcorper. Nunc dignissim arcu eu urna pulvinar faucibus. Praesent ac pharetra odio. Donec pellentesque.",
            descripcion:
                "Mi descripcion de la de seleccion unica en cuadricula",
            criticidad: 1,
            posicion: "arriba",
            calificable: false,
          ),
        ],
        opciones,
        titulo: "Mi pregunta cuadricula de seleccion unica",
        descripcion: "Mi descripcion de cuadricula de seleccion unica",
        criticidad: 1,
        posicion: "arriba",
        calificable: true,
      ),
      CuadriculaDeSeleccionUnica(
        [
          PreguntaDeSeleccionUnica(
            // TODO: hacer que sean las mismas que las de la cuadricula
            opciones,
            titulo: "Mi pregunta unica en cuadricula",
            descripcion:
                "Mi descripcion de la de seleccion unica en cuadricula",
            criticidad: 1,
            posicion: "arriba",
            calificable: true,
          ),
          PreguntaDeSeleccionUnica(
            opciones,
            titulo:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec in varius augue. Sed vestibulum sapien laoreet, tempus metus at, malesuada justo. Morbi cursus mi sollicitudin, vestibulum dolor nec, sagittis tellus. Phasellus a erat eget mi mattis ullamcorper. Nunc dignissim arcu eu urna pulvinar faucibus. Praesent ac pharetra odio. Donec pellentesque.",
            descripcion:
                "Mi descripcion de la de seleccion unica en cuadricula",
            criticidad: 1,
            posicion: "arriba",
            calificable: false,
          ),
        ],
        opciones,
        titulo: "Mi pregunta cuadricula de seleccion unica",
        descripcion: "Mi descripcion de cuadricula de seleccion unica",
        criticidad: 1,
        posicion: "arriba",
        calificable: true,
      ),
      Titulo(titulo: "El otro titulo ", descripcion: "La otra descripcion "),
      PreguntaNumerica(
        [],
        titulo: "Mi pregunta numerica",
        descripcion: "Mi descripcion de la numerica",
        criticidad: 1,
        posicion: "abajo",
        calificable: true,
        unidades: "metros",
      ),
      PreguntaDeSeleccionUnica(
        opciones,
        titulo: "Mi pregunta unica",
        descripcion: "Mi descripcion de la de seleccion unica",
        criticidad: 1,
        posicion: "abajo",
        calificable: false,
      ),
      PreguntaDeSeleccionMultiple(
        opciones,
        opciones
            .map((op) => SubPreguntaDeSeleccionMultiple(
                  op,
                  titulo: op.titulo,
                  descripcion: op.descripcion,
                  criticidad: op.criticidad,
                  posicion: "",
                  calificable: false,
                ))
            .toList(),
        titulo: "Mi pregunta de seleccion multiple",
        descripcion: "Mi descripcion de la de seleccion multiple",
        criticidad: 1,
        posicion: "abajo",
        calificable: true,
      ),
    ];
    final inspeccion = Inspeccion(
      id: 2,
      estado: EstadoDeInspeccion.borrador,
      activo: "123",
    );
    final cuestionario = CuestionarioInspeccionado(
      inspeccion,
      bloques,
      id: 1,
      tipoDeInspeccion: "preoperacional",
    );
    inspeccion.cuestionario = cuestionario;

    return Future.value(cuestionario);
  }

  Future<void> guardarInspeccion(List<Respuesta> respuestas,
      {required int inspeccionId}) async {
    /* _db.llenadoDao.guardarInspeccion(respuestas,inspeccionId); */

    print("guardando inspeccion $inspeccionId");
    for (final respuesta in respuestas) {
      print(respuesta);
    }
  }
}
