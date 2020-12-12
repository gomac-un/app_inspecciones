import 'dart:io';
import 'package:inspecciones/application/crear_cuestionario_form/respuesta_field_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:moor/moor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LlenarCuestionarioFormBloc extends FormBloc<String, String> {
  final Database _db;

  //lista que almacena los blocs de respuestas
  //lista que almacena todos los bloques que se muestran en la inspeccion, incluyendo titulos y preguntas
  List<Object> bloques = [];

  final String _vehiculo;
  final int _cuestionarioId;

  final respuestas = ListFieldBloc<RespuestaFieldBloc>(name: 'respuestas');

  //@factoryMethod
  LlenarCuestionarioFormBloc.withBorrador(Database db, Borrador borrador)
      : this(db, borrador.activo.identificador,
            borrador.inspeccion.cuestionarioId);

  LlenarCuestionarioFormBloc(this._db, this._vehiculo, this._cuestionarioId)
      : super(isLoading: true) {
    addFieldBlocs(fieldBlocs: [
      respuestas,
    ]);

    // TODO: Autoguardado automático.

    /*distinct(
      (previous, current) =>
          previous.toJson().toString() == current.toString().toString(),
    ).listen((state) {
      
      //print(state.toJson());
    });*/
  }
  @override
  void onLoading() async {
    /*
    final bloquesBD = await _db.cargarInspeccion(
      _cuestionarioId,
      _vehiculo,
    );

    bool flagIniciaCuadricula = false;
    bloquesBD?.forEach((bloque) {
      if (bloque.pregunta == null) {
        //los titulos no tienen pregunta asociada
        bloques.add(Object()
            /*Titulo(
            titulo: bloque.bloque.titulo,
            descripcion: bloque.bloque.descripcion,
          ),*/
            );
      } else {
        
        //logica para el agrupamiento de las preguntas que componen una cuadricula
        // funciona solo si los elementos pertenecientes a una cuadricula
        // se encuentran contiguos

        //primero agregarle el bloc al modelo en el objeto extendido y agregar este bloc al form
        final bloqueExt = BloqueConPreguntaRespondidaExt(
            bloqueConPreguntaRespondida: bloque,
            bloc: RespuestaFieldBloc(bloque));
        respuestas.addFieldBloc(bloqueExt.bloc);

        // para el primer elemento se crea el objeto de agrupacion
        if (!flagIniciaCuadricula &&
            bloque.pregunta.tipo == TipoDePregunta.cuadricula) {
          flagIniciaCuadricula = true;
          final inicioCuadricula = PreguntaTipoCuadricula();
          inicioCuadricula.grupoCuadricula.add(bloqueExt);
          bloques.add(inicioCuadricula);
        }
        //los siguientes de la cuadricula se agregan en el grupo
        if (flagIniciaCuadricula &&
            bloque.pregunta.tipo == TipoDePregunta.cuadricula) {
          final cuadricula = bloques.last as PreguntaTipoCuadricula;
          cuadricula.grupoCuadricula.add(bloqueExt);
        }
        //cuando termina el grupo
        if (flagIniciaCuadricula &&
            bloque.pregunta.tipo != TipoDePregunta.cuadricula) {
          flagIniciaCuadricula = false;
        }
        //preguntas que no hacen parte de un grupo
        if (bloque.pregunta.tipo != TipoDePregunta.cuadricula) {
          bloques.add(bloqueExt);
        }
      }
    });
*/
    emitLoaded();
  }

  @override
  void onSubmitting() async {
    //print(state.toString());

    try {
      await guardarEnLocal(esBorrador: false);
      emitSuccess(
        canSubmitAgain: false,
        /*successResponse: JsonEncoder.withIndent('    ').convert(
            state.toJson(),
          )*/
      );
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }

  Future guardarEnLocal({bool esBorrador}) async {
    final appDir = await getApplicationDocumentsDirectory();
    final subDir = "inspecciones";

    final idform =
        respuestas.state.fieldBlocs.first.bloque.bloque.cuestionarioId;

    //actualizar las fotos
    await Future.forEach(respuestas.state.fieldBlocs, (e) async {
      final bloc = e as RespuestaFieldBloc;
      final fotosBases =
          procesarFotos(bloc.fotosBase, appDir.path, subDir, idform.toString());
      final fotosBaseProcesadas = await Future.wait(fotosBases);
      final fotosReparacion = procesarFotos(
          bloc.fotosReparacion, appDir.path, subDir, idform.toString());
      final fotosReparacionProcesadas = await Future.wait(fotosReparacion);
      bloc.bloque.respuesta = bloc.bloque.respuesta.copyWith(
        fotosBase: Value(
          fotosBaseProcesadas.toList(),
        ),
        fotosReparacion: Value(
          fotosReparacionProcesadas.toList(),
        ),
      );
    });
    await _db.guardarInspeccion(
        respuestas.state.fieldBlocs.map((e) => e.bloque.respuesta).toList(),
        _cuestionarioId,
        _vehiculo,
        esBorrador);
  }

  Iterable<Future<String>> procesarFotos(
      ListFieldBloc<InputFieldBloc<File, Object>> blocImagenes,
      String appDir,
      String subDir,
      String idform) {
    return blocImagenes.state.fieldBlocs.map((imagebloc) async {
      var image = imagebloc.state.value;
      if (path.isWithin(appDir, image.path)) {
        // la imagen ya esta en la carpeta de datos
        return imagebloc.state.value.path;
      } else {
        //mover la foto a la carpeta de datos
        final fileName = path.basename(image.path);
        final newPath =
            path.join(appDir, 'fotos', subDir, idform.toString(), fileName);
        await File(newPath).create(recursive: true);
        final savedImage = await image.copy(newPath);
        return savedImage.path;
      }
    });
  }

  void enviar() {
    if (state is FormBlocLoaded) {
      if (state.isValid()) {
        // TODO: scroll al lugar del error
        respuestas.state.fieldBlocs.forEach((bloc) {
          bloc.inicioRevision();
        });
        add(UpdateFormBlocState<String, String>(
            FormBlocRevisando.fromState(state)));
        guardarEnLocal(esBorrador: true);
      }
    } else if (state is FormBlocRevisando) {
      submit();
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

// estados custom
class FormBlocRevisando<SuccessResponse, FailureResponse>
    extends FormBlocLoaded<SuccessResponse, FailureResponse> {
  FormBlocRevisando(
    Map<int, bool> isValidByStep, {
    bool isEditing = false,
    Map<int, Map<String, FieldBloc>> fieldBlocs,
    int currentStep,
  }) : super(
          isValidByStep,
          isEditing: isEditing,
          fieldBlocs: fieldBlocs,
          currentStep: currentStep ?? 0,
        );

  @override
  List<Object> get props => [
        isValid(0),
        isEditing,
        toJson(),
        currentStep,
      ];
  factory FormBlocRevisando.fromState(FormBlocState state) => FormBlocRevisando(
        {0: state.isValid(0)},
        isEditing: state.isEditing,
        fieldBlocs: {0: state.fieldBlocs(0)},
        currentStep: state.currentStep ?? 0,
      );
}
