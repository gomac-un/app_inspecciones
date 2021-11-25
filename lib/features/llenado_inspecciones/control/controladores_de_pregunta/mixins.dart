import '../../domain/metarespuesta.dart';
import '../controlador_de_pregunta.dart';

//TODO: usar en las clases necesarias cuando el LSP deje de tirar error
mixin CriticidadDelInspector on ControladorDePregunta {
  //TODO: probar si el mixin sobreescribe el metodo
  @override
  MetaRespuesta guardarMetaRespuesta() => super
      .guardarMetaRespuesta()
      .copyWith(criticidadDelInspector: criticidadDelInspectorControl.value);
}
