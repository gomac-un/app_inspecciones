import 'package:json_annotation/json_annotation.dart';

enum TipoDePregunta {
  @JsonValue("unicaRespuesta")
  unicaRespuesta,
  @JsonValue("multipleRespuesta")
  multipleRespuesta,
  @JsonValue("binaria")
  binaria,
  @JsonValue("fecha")
  fecha,
  @JsonValue("rangoNumerico")
  rangoNumerico,
}

/*extension json on TipoDePregunta {
  Map<String, dynamic> toJson() {
    return {
      'TipoDePregunta': this.toString().split('.').last,
    };
  }
}*/

enum EstadoDeInspeccion {
  enBorrador,
  enviada,
}
