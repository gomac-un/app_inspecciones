import 'dart:developer' as developer;
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../domain/bloque.dart';
import '../domain/bloques/bloques.dart';
import '../domain/bloques/preguntas/opcion_de_respuesta.dart';
import '../domain/borrador.dart';
import '../domain/cuestionario.dart';
import '../domain/identificador_inspeccion.dart';
import '../domain/inspeccion.dart';
import '../domain/metarespuesta.dart';
import '../domain/modelos.dart';
import '../domain/respuesta.dart';

final inspeccionesRepositoryProvider =
    Provider((_) => InspeccionesRepository());

//TODO: pasar a freezed
class InspeccionesFailure {
  final String msg;

  InspeccionesFailure(this.msg);
}

// FEF: Future Either Fail
typedef FEF<C> = Future<Either<InspeccionesFailure, C>>;

class InspeccionesRepository {
  FEF<Unit> eliminarBorrador(Borrador inspeccion) =>
      Future.value(const Right(unit));

  FEF<Unit> subirInspeccion(Inspeccion inspeccion) => Future.value(const Right(
      unit)); // subir la inspeccion al server y si es exitoso, borrarla del local

  Stream<List<Borrador>> getBorradores() => Stream.value([
        Borrador(
          Inspeccion(
            id: 1,
            estado: EstadoDeInspeccion.borrador,
            activo: Activo(id: "1", modelo: "auto"),
            momentoBorradorGuardado: DateTime.now(),
            criticidadTotal: 10,
            criticidadReparacion: 5,
            esNueva: true,
          ),
          Cuestionario(id: 1, tipoDeInspeccion: "preoperacional"),
          avance: 5,
          total: 10,
        )
      ]);

  //FEF<List<Cuestionario>> cuestionariosParaActivo(String activo) async {
  Future<Either<InspeccionesFailure, List<Cuestionario>>>
      cuestionariosParaActivo(String activo) async {
    return Right([
      if (activo == "1")
        Cuestionario(id: 1, tipoDeInspeccion: "preoperacional"),
      Cuestionario(id: 2, tipoDeInspeccion: "otro cuestionario"),
    ]);
  }

  //FEF<CuestionarioInspeccionado> cargarInspeccionLocal(
  Future<Either<InspeccionesFailure, CuestionarioInspeccionado>>
      cargarInspeccionLocal(IdentificadorDeInspeccion id) async {
    //TODO: implementar
    developer.log("cargando inspeccion $id");
    //await Future.delayed(const Duration(seconds: 1));
    if (id.activo != "1") {
      return Right(await _inspeccionNueva());
    } else {
      return Right(await _inspeccionIniciada());
    }
  }

  FEF<CuestionarioInspeccionado> cargarInspeccionRemota(
      int inspeccionId) async {
    //TODO: implementar
    developer.log("cargando inspeccion $inspeccionId");
    //await Future.delayed(const Duration(seconds: 1));
    if (inspeccionId == 1) {
      return Right(await _inspeccionNueva());
    } else {
      return Right(await _inspeccionIniciada());
    }
  }

  Future<void> guardarInspeccion(List<Pregunta> preguntasRespondidas,
      {required int inspeccionId}) async {
    /* _db.llenadoDao.guardarInspeccion(respuestas,inspeccionId); */

    developer.log("guardando inspeccion $inspeccionId");
    for (final respuesta in preguntasRespondidas) {
      developer.log(respuesta.toString());
    }
  }

  Future<CuestionarioInspeccionado> _inspeccionIniciada() {
    final List<OpcionDeRespuesta> opciones = [
      OpcionDeRespuesta(
        id: 1,
        titulo:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vehicula quam dui, in lobortis leo accumsan vel. Ut semper augue a erat tempus sagittis. Phasellus orci turpis, laoreet ac est.",
        descripcion: "",
        criticidad: 1,
      ),
      OpcionDeRespuesta(id: 2, titulo: "op2", descripcion: "", criticidad: 0),
      OpcionDeRespuesta(
        id: 3,
        titulo:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam feugiat ullamcorper lacus nec tincidunt. Maecenas.",
        descripcion: "lalalallala",
        criticidad: 1,
      ),
      OpcionDeRespuesta(id: 4, titulo: "op4", descripcion: "", criticidad: 0),
      OpcionDeRespuesta(
        id: 5,
        titulo:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ligula est, suscipit at venenatis at.",
        descripcion: "yayayayqa",
        criticidad: 1,
      ),
      OpcionDeRespuesta(id: 6, titulo: "op6", descripcion: "", criticidad: 0),
      OpcionDeRespuesta(
        id: 7,
        titulo:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In et erat et tellus dapibus lacinia in non quam. Cras et.",
        descripcion: "ñañañaññañañañaa",
        criticidad: 1,
      ),
      OpcionDeRespuesta(id: 8, titulo: "op8", descripcion: "", criticidad: 0),
      OpcionDeRespuesta(
        id: 9,
        titulo:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In et erat et tellus dapibus lacinia in non quam. Cras et.",
        descripcion: "alalalal",
        criticidad: 1,
      ),
      OpcionDeRespuesta(id: 9, titulo: "op10", descripcion: "", criticidad: 0),
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
                      id: 3,
                      titulo: op.titulo,
                      descripcion: op.descripcion,
                      criticidad: op.criticidad,
                      posicion: '',
                      calificable: false,
                      respuesta: SubRespuestaDeSeleccionMultiple(
                          MetaRespuesta(),
                          estaSeleccionada: Random().nextBool()),
                    ))
                .toList(),
            id: 2,
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
                      id: 5,
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
            id: 4,
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
        id: 1,
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
            id: 7,
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
            id: 8,
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
        id: 6,
        titulo: "Mi pregunta cuadricula de seleccion unica",
        descripcion: "Mi descripcion de cuadricula de seleccion unica",
        criticidad: 1,
        posicion: "arriba",
        calificable: true,
        respuesta: RespuestaDeCuadriculaDeSeleccionUnica(MetaRespuesta()),
      ),
      Titulo(
          titulo: "El otro titulazo " * 10,
          descripcion: "La otra descripcion " * 5),
      PreguntaNumerica(
        [],
        id: 9,
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
        id: 10,
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
                  id: 12,
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
        id: 11,
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
      activo: Activo(id: "123", modelo: "auto"),
      momentoBorradorGuardado: DateTime.now(),
      criticidadTotal: 10,
      criticidadReparacion: 5,
      esNueva: true,
    );
    final cuestionario = CuestionarioInspeccionado(
      Cuestionario(
        id: 1,
        tipoDeInspeccion: "preoperacional",
      ),
      inspeccion,
      bloques,
    );
    inspeccion.cuestionario = cuestionario;

    return Future.value(cuestionario);
  }

  Future<CuestionarioInspeccionado> _inspeccionNueva() =>
      _inspeccionIniciada().then(
        (c) => CuestionarioInspeccionado(
          c.cuestionario,
          c.inspeccion,
          c.bloques.map(_quitarRespuesta).toList(),
        ),
      );
  Bloque _quitarRespuesta(Bloque b) {
    if (b is Pregunta) {
      b.respuesta = null;
      if (b is PreguntaDeSeleccionMultiple) {
        for (var r in b.respuestas) {
          _quitarRespuesta(r);
        }
      }
      if (b is CuadriculaDeSeleccionUnica) {
        for (var r in b.preguntas) {
          _quitarRespuesta(r);
        }
      }
    }
    return b;
  }
}
