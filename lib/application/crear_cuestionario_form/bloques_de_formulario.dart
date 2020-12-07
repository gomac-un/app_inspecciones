import 'package:inspecciones/application/crear_cuestionario_form/respuesta_field_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';

class BloqueConPreguntaRespondidaExt extends BloqueConPreguntaRespondida {
  BloqueConPreguntaRespondida bloqueConPreguntaRespondida;
  RespuestaFieldBloc bloc;
  BloqueConPreguntaRespondidaExt({this.bloqueConPreguntaRespondida, this.bloc});
}

class PreguntaTipoCuadricula {
  List<BloqueConPreguntaRespondidaExt> grupoCuadricula = [];
}

class Titulo {
  String titulo;
  String descripcion;
  Titulo({
    this.titulo,
    this.descripcion,
  });
}
