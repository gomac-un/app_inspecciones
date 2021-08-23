/// Definición de todos los Controllers de los bloques en la creación de cuestionarios
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/cuestionarios_repository.dart';
import 'package:inspecciones/mvvc/creacion_validators.dart';
import 'package:kt_dart/kt.dart';
import 'package:moor/moor.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Interfaz de todos los controllers involucrados en la creación de cuestionarios
abstract class CreacionController {
  /// Objeto de la librería reactive forms, por ahora todos son [FormGroup] pero
  /// de llegar el caso se puede abstraer a [AbstractControl]
  FormGroup get control;

  /// Crea un control del mismo tipo usando los datos ingresados en este,
  /// Importante: Se deben eliminar ([Value.absent]) las referencias unicas
  /// tales como id y bloqueId
  CreacionController copy();

  /// Devuelve la información obtenida en forma de un objeto que
  /// será usado para persistir la información en el repositorio local
  Object toDB();

  /// Libera los recursos de este control
  void dispose() {
    /// creo que no va a ser falta porque al insertarlo en un formgroup superior,
    /// este va a hacer dispose de todo (o deberia)
    control.dispose();
  }
}

/// Crea o edita un titulo en un cuestionario
/// Si [tituloCompanion] no es null, se insertan los valores de sus campos en el control
/// y se guarda su id para editarlo en la db
/// si es nulo se establecen unos valores por defecto
class CreadorTituloController extends CreacionController {
  final TitulosCompanion _tituloCompanion;

  late final tituloControl = fb.control<String>(
    _tituloCompanion.titulo.valueOrDefault(" "),
    [Validators.required],
  );
  late final descripcionControl = fb.control<String>(
    _tituloCompanion.descripcion.valueOrDefault(""),
  );

  @override
  late final control = FormGroup({
    'titulo': tituloControl,
    'descripcion': descripcionControl,
  });

  /// Recibe el companion de un titulo el cual puede(O DEBE?) contener valores
  /// por defecto para los campos, si incluye la id, el control será actualizado
  /// en la db con la misma id
  CreadorTituloController([this._tituloCompanion = const TitulosCompanion()]);

  @override
  CreadorTituloController copy() {
    return CreadorTituloController(
      toDB().copyWith(
        id: const Value.absent(),
        bloqueId: const Value.absent(),
      ),
    );
  }

  /// En caso de que ya exista, se actualiza con los nuevos valores introducidos
  /// en el formulario, (Como ya tenemos un titulo, se actualiza en la bd)
  /// Este método es usado a la hora de guardar el cuestionario en la bd.
  /// Si es para insertar debe devolver un [TitulosCompanion] usando el constructor
  /// [TitulosCompanion.insert] pero como no sabemos el bloqueId todavia se debe usar
  /// el constructor normal de companion, pero para insertar mas adelante se deberia
  /// usar el constructor [TitulosCompanion.insert] para asegurarse que todo esté bien.
  /// Si es para editar tenemos el id con el que podemos generar
  /// la dataclass entera, ie la unica diferencia es que no tenemos el id
  @override
  TitulosCompanion toDB() {
    return _tituloCompanion.copyWith(
      titulo: Value(tituloControl.value!),
      descripcion: Value(descripcionControl.value!),
    );
  }
}

class PreguntaConOpcionesDeRespuestaCompanion {
  final PreguntasCompanion pregunta;
  final List<OpcionesDeRespuestaCompanion> opcionesDeRespuesta;

  PreguntaConOpcionesDeRespuestaCompanion(
    this.pregunta,
    this.opcionesDeRespuesta,
  );
  PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(
      PreguntaConOpcionesDeRespuesta p)
      : pregunta = p.pregunta.toCompanion(true),
        opcionesDeRespuesta =
            p.opcionesDeRespuesta.map((o) => o.toCompanion(true)).toList();
  const PreguntaConOpcionesDeRespuestaCompanion.vacio()
      : pregunta = const PreguntasCompanion(),
        opcionesDeRespuesta = const [];

  PreguntaConOpcionesDeRespuestaCompanion copyWith({
    PreguntasCompanion? pregunta,
    List<OpcionesDeRespuestaCompanion>? opcionesDeRespuesta,
  }) =>
      PreguntaConOpcionesDeRespuestaCompanion(
        pregunta ?? this.pregunta,
        opcionesDeRespuesta ?? this.opcionesDeRespuesta,
      );
}

extension DefaultGetter<T> on Value<T> {
  T valueOrDefault(T def) {
    return present ? value : def;
  }
  // ···
}

///  Control encargado de manejar las preguntas de tipo selección
class CreadorPreguntaController extends CreacionController
    implements ConRespuestas {
  final CuestionariosRepository _repository;

  /// Si se llama al agregar un nuevo bloque (desde [BotonesBloque]), [preguntaDesdeDB] es null,
  /// Cuando se va a editar, [preguntaDesdeDB] es pasado directamente desde el
  /// controller superior.
  /// Cuando se usa copiar, [preguntaDesdeDB] se obtiene desde el método [toDataClass()]
  final PreguntaConOpcionesDeRespuestaCompanion preguntaDesdeDB;

  /// Diferencia las de selección y las que son de cuadricula
  final bool parteDeCuadricula;
  final bool esNumerica;

  final Sistema? _sistemaInicial;
  final SubSistema? _subSistemaInicial;

  final ValueNotifier<List<SubSistema>> subSistemasDisponibles =
      ValueNotifier<List<SubSistema>>([]);

  /// Controles del bloque del formulario
  late final tituloControl = fb.control<String>(
    preguntaDesdeDB.pregunta.titulo.valueOrDefault(""),
    [Validators.required],
  );
  late final descripcionControl = fb
      .control<String>(preguntaDesdeDB.pregunta.descripcion.valueOrDefault(""));
  late final sistemaControl = fb.control<Sistema?>(
    _sistemaInicial,
    [Validators.required],
  )..valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemasDisponibles.value =
          sistema == null ? [] : await _repository.getSubSistemas(sistema);
    });
  late final subSistemaControl = fb.control<SubSistema?>(
    _subSistemaInicial,
    [Validators.required],
  );
  late final ejeControl = fb.control<String?>(
    preguntaDesdeDB.pregunta.eje.valueOrDefault(""),
    [Validators.required],
  );
  late final ladoControl = fb.control<String?>(
    preguntaDesdeDB.pregunta.lado.valueOrDefault(""),
    [Validators.required],
  );
  late final posicionZControl = fb.control<String?>(
    preguntaDesdeDB.pregunta.posicionZ.valueOrDefault(""),
    [Validators.required],
  );
  late final criticidadControl = fb.control<double>(
      preguntaDesdeDB.pregunta.criticidad.valueOrDefault(0).toDouble());
  late final fotosGuiaControl = fb.array<File>(
    preguntaDesdeDB.pregunta.fotosGuia
        .valueOrDefault(const KtList.empty())
        .iter
        .map((e) => File(e))
        .toList(),
  );

  /// Si es de cuadricula, no se debe requerir que elija el tipo e pregunta
  late final tipoDePreguntaControl = fb.control<TipoDePregunta>(
    preguntaDesdeDB.pregunta.tipo.valueOrDefault(TipoDePregunta.unicaRespuesta),
    [if (!parteDeCuadricula) Validators.required],
  );

  /// Son las opciones de respuesta.
  /// Si el bloque es nuevo, son null y se pasa un FormArray vacío.
  /// Si es bloque copiado o viene de edición se pasa un FormArray con cada
  /// una de las opciones que ya existen para la pregutna
  late final controllersRespuestas = preguntaDesdeDB.opcionesDeRespuesta
      .map((e) => CreadorRespuestaController(e))
      .toList();

  late final respuestasControl = fb.array<Map<String, dynamic>>(
    controllersRespuestas.map((e) => e.control).toList(),

    /// Si es parte de cuadricula o numérica no tienen opciones de respuesta
    [if (!parteDeCuadricula && !esNumerica) Validators.minLength(1)],
  );

  @override
  late final control = fb.group({
    'titulo': tituloControl,
    'descripcion': descripcionControl,
    'sistema': sistemaControl,
    'subSistema': subSistemaControl,
    'eje': ejeControl,
    'lado': ladoControl,
    'posicionZ': posicionZControl,
    'criticidad': criticidadControl,
    'fotosGuia': fotosGuiaControl,
    'tipoDePregunta': tipoDePreguntaControl,
    'respuestas': respuestasControl,
  });

  CreadorPreguntaController(
    this._repository,
    this._sistemaInicial,
    this._subSistemaInicial, {
    this.preguntaDesdeDB =
        const PreguntaConOpcionesDeRespuestaCompanion.vacio(),
    this.parteDeCuadricula = false,
    this.esNumerica = false,
  });

  @override
  CreadorPreguntaController copy() {
    final copied = toDB();

    return CreadorPreguntaController(
      _repository,
      sistemaControl.value,
      subSistemaControl.value,
      preguntaDesdeDB: copied.copyWith(
        pregunta: copied.pregunta.copyWith(
          id: const Value.absent(),
          bloqueId: const Value.absent(),
        ),
        opcionesDeRespuesta: copied.opcionesDeRespuesta
            .map((o) => o.copyWith(
                  id: const Value.absent(),
                  preguntaId: const Value.absent(),
                  cuadriculaId: const Value.absent(),
                ))
            .toList(),
      ),
    );
  }

  /// En caso de que ya exista [preguntaDesdeDB], se actualiza con los nuevos
  /// valores introducidos en el formulario, (Como ya tiene id, se actualiza en la bd)
  /// Si no se "crea" uno con el método [toDataClass()]
  /// Este método es usado a la hora de guardar el cuestionario en la bd.
  @override
  PreguntaConOpcionesDeRespuestaCompanion toDB() {
    return PreguntaConOpcionesDeRespuestaCompanion(
      preguntaDesdeDB.pregunta.copyWith(
        titulo: Value(tituloControl.value!),
        descripcion: Value(descripcionControl.value!),
        sistemaId: Value(sistemaControl.value?.id),
        subSistemaId: Value(subSistemaControl.value?.id),
        eje: Value(ejeControl.value),
        lado: Value(ladoControl.value),
        posicionZ: Value(posicionZControl.value),
        criticidad: Value(criticidadControl.value!.round()),
        fotosGuia: Value(fotosGuiaControl.controls
            .map((e) => e.value!.path)
            .toImmutableList()),
        tipo: Value(tipoDePreguntaControl.value!),
      ),
      controllersRespuestas.map((e) => e.toDB()).toList(),
    );
  }

  /// Añade una opcion de respuesta a los controles
  @override
  void agregarRespuesta() {
    final nuevoController = CreadorRespuestaController();
    controllersRespuestas.add(nuevoController);
    respuestasControl.add(nuevoController.control);
  }

  /// Elimina de los controles, la opcion de respuesta [c]
  @override
  void borrarRespuesta(CreacionController c) {
    controllersRespuestas.remove(c);
    respuestasControl.remove(c.control);
  }
}

/// Control encargado de manejar la creación de opciones de respuesta en preguntas de selección o de cuadricula
class CreadorRespuestaController extends CreacionController {
  /// Si se llama al agregar criticidad (desde la cración de pregunta numerica), [respuestaDesdeDB] es null,
  /// Cuando se va a editar, [respuestaDesdeDB] es pasado directamente desde los BloquesBd de [CreacionFormViewModel.cargarBloques()]
  /// Cuando se usa copiar, [respuestaDesdeDB] se obtiene desde el método [toDataClass()]
  final OpcionesDeRespuestaCompanion _respuestaDesdeDB;

  late final textoControl = fb.control<String>(
    _respuestaDesdeDB.texto.valueOrDefault(""),
    [Validators.required],
  );
  late final criticidadControl = fb.control<double>(
      _respuestaDesdeDB.criticidad.valueOrDefault(0).toDouble());
  late final calificableControl =
      fb.control<bool>(_respuestaDesdeDB.calificable.valueOrDefault(false));

  @override
  late final control = fb.group({
    'texto': textoControl,
    'criticidad': criticidadControl,
    'calificable': calificableControl,
  });

  CreadorRespuestaController(
      [this._respuestaDesdeDB = const OpcionesDeRespuestaCompanion()]);

  @override
  CreadorRespuestaController copy() {
    return CreadorRespuestaController(
      toDB().copyWith(id: const Value.absent()),
    );
  }

  @override
  OpcionesDeRespuestaCompanion toDB() {
    return _respuestaDesdeDB.copyWith(
        texto: Value(textoControl.value!),
        criticidad: Value(criticidadControl.value!.round()),
        calificable: Value(calificableControl.value!));
  }
}

/// Controller que maneja la creación de rangoss de criticidad para preguntas numericas
class CreadorCriticidadesNumericasController extends CreacionController {
  final CriticidadesNumericasCompanion _criticidadDB;

  late final minimoControl = fb.control<double>(
    _criticidadDB.valorMinimo.valueOrDefault(0),
    [Validators.required],
  );
  late final maximoControl = fb.control<double>(
    _criticidadDB.valorMaximo.valueOrDefault(0),
    [Validators.required],
  );
  late final criticidadControl =
      fb.control<double>(_criticidadDB.criticidad.valueOrDefault(0).toDouble());

  @override
  late final control = fb.group({
    'minimo': maximoControl,
    'maximo': minimoControl,
    'criticidad': criticidadControl,
  }, [
    /// Que el valor mínimo sea menor que el introducido en máximo
    //TODO: validación para que no se entrecrucen los rangos
    verificarRango('minimo', 'maximo'),
  ]);

  CreadorCriticidadesNumericasController(
      [this._criticidadDB = const CriticidadesNumericasCompanion()]);

  @override
  CreadorCriticidadesNumericasController copy() {
    return CreadorCriticidadesNumericasController(
      toDB().copyWith(id: const Value.absent()),
    );
  }

  @override
  CriticidadesNumericasCompanion toDB() {
    return _criticidadDB.copyWith(
      valorMinimo: Value(minimoControl.value!),
      valorMaximo: Value(maximoControl.value!),
      criticidad: Value(criticidadControl.value!.round()),
    );
  }
}

class CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion {
  final CuadriculasDePreguntasCompanion cuadricula;
  final List<PreguntaConOpcionesDeRespuestaCompanion> preguntas;
  final List<OpcionesDeRespuestaCompanion> opcionesDeRespuesta;

  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
    this.cuadricula,
    this.preguntas,
    this.opcionesDeRespuesta,
  );
  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.fromDataClass(
      CuadriculaConPreguntasYConOpcionesDeRespuesta c)
      : cuadricula = c.cuadricula.toCompanion(true),
        preguntas = c.preguntas
            .map(
                (p) => PreguntaConOpcionesDeRespuestaCompanion.fromDataClass(p))
            .toList(),
        opcionesDeRespuesta =
            c.opcionesDeRespuesta.map((o) => o.toCompanion(true)).toList();
  const CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.vacio()
      : cuadricula = const CuadriculasDePreguntasCompanion(),
        preguntas = const [],
        opcionesDeRespuesta = const [];

  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion copyWith({
    CuadriculasDePreguntasCompanion? cuadricula,
    List<PreguntaConOpcionesDeRespuestaCompanion>? preguntas,
    List<OpcionesDeRespuestaCompanion>? opcionesDeRespuesta,
  }) =>
      CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
        cuadricula ?? this.cuadricula,
        preguntas ?? this.preguntas,
        opcionesDeRespuesta ?? this.opcionesDeRespuesta,
      );
}

///TODO: reducir la duplicacion de codigo con la pregunta normal
class CreadorPreguntaCuadriculaController extends CreacionController
    implements ConRespuestas {
  final CuestionariosRepository _repository;

  /// Info cuadricula y opciones de respuesta
  /*final CuadriculaDePreguntasConOpcionesDeRespuestaCompanion cuadriculaDesdeDB;
  final List<PreguntaConOpcionesDeRespuestaCompanion>
      preguntasDeCuadriculaDesdeDB;*/
  final CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion datosIniciales;

  final Sistema? _sistemaInicial;
  final SubSistema? _subSistemaInicial;

  final ValueNotifier<List<SubSistema>> subSistemasDisponibles =
      ValueNotifier<List<SubSistema>>([]);

  /// Controles del bloque del formulario
  late final tituloControl = fb.control<String>(
    datosIniciales.cuadricula.titulo.valueOrDefault(""),
    [Validators.required],
  );
  late final descripcionControl = fb.control<String>(
      datosIniciales.cuadricula.descripcion.valueOrDefault(""));
  late final sistemaControl = fb.control<Sistema?>(
    _sistemaInicial,
    [Validators.required],
  )..valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemasDisponibles.value =
          sistema == null ? [] : await _repository.getSubSistemas(sistema);
    });
  late final subSistemaControl = fb.control<SubSistema?>(
    _subSistemaInicial,
    [Validators.required],
  );
  late final ejeControl = fb.control<String?>(
    datosIniciales.preguntas.first.pregunta.eje.valueOrDefault(""),
    [Validators.required],
  );
  late final ladoControl = fb.control<String?>(
    datosIniciales.preguntas.first.pregunta.lado.valueOrDefault(""),
    [Validators.required],
  );
  late final posicionZControl = fb.control<String?>(
    datosIniciales.preguntas.first.pregunta.posicionZ.valueOrDefault(""),
    [Validators.required],
  );

  /// Si es de cuadricula, no se debe requerir que elija el tipo e pregunta
  late final tipoDePreguntaControl = fb.control<TipoDePregunta>(
    datosIniciales.preguntas.first.pregunta.tipo
        .valueOrDefault(TipoDePregunta.parteDeCuadriculaUnica),
  );
  late final controllersPreguntas = datosIniciales.preguntas
      .map((e) => CreadorPreguntaController(
            _repository,
            _sistemaInicial,
            _subSistemaInicial,
            preguntaDesdeDB: e,
            parteDeCuadricula: true,
          ))
      .toList();

  late final preguntasControl = fb.array<Map<String, dynamic>>(
    controllersPreguntas.map((e) => e.control).toList(),

    /// Si es parte de cuadricula o numérica no tienen opciones de respuesta
    [Validators.minLength(1)],
  );

  /// Son las opciones de respuesta.
  /// Si el bloque es nuevo, son null y se pasa un FormArray vacío.
  /// Si es bloque copiado o viene de edición se pasa un FormArray con cada
  /// una de las opciones que ya existen para la pregutna
  late final controllersRespuestas = datosIniciales.opcionesDeRespuesta
      .map((e) => CreadorRespuestaController(e))
      .toList();

  late final respuestasControl = fb.array<Map<String, dynamic>>(
    controllersRespuestas.map((e) => e.control).toList(),

    /// Si es parte de cuadricula o numérica no tienen opciones de respuesta
    [Validators.minLength(1)],
  );

  @override
  late final control = fb.group({
    'titulo': tituloControl,
    'descripcion': descripcionControl,
    'sistema': sistemaControl,
    'subSistema': subSistemaControl,
    'eje': ejeControl,
    'lado': ladoControl,
    'posicionZ': posicionZControl,
    'tipoDePregunta': tipoDePreguntaControl,
    'preguntas': preguntasControl,
    'respuestas': respuestasControl,
  });

  CreadorPreguntaCuadriculaController(
    this._repository,
    this._sistemaInicial,
    this._subSistemaInicial, {
    this.datosIniciales =
        const CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.vacio(),
  });

  @override
  CreadorPreguntaCuadriculaController copy() {
    final copied = toDB();

    return CreadorPreguntaCuadriculaController(
      _repository,
      sistemaControl.value,
      subSistemaControl.value,
      datosIniciales: copied.copyWith(
        cuadricula: copied.cuadricula.copyWith(
          id: const Value.absent(),
          bloqueId: const Value.absent(),
        ),
        preguntas: copied.preguntas
            .map((p) => p.copyWith(
                pregunta: p.pregunta.copyWith(
                  id: const Value.absent(),
                  bloqueId: const Value.absent(),
                ),
                opcionesDeRespuesta: p.opcionesDeRespuesta
                    .map((e) => e.copyWith(
                          id: const Value.absent(),
                          preguntaId: const Value.absent(),
                        ))
                    .toList()))
            .toList(),
        opcionesDeRespuesta: copied.opcionesDeRespuesta
            .map((o) => o.copyWith(
                  id: const Value.absent(),
                  preguntaId: const Value.absent(),
                  cuadriculaId: const Value.absent(),
                ))
            .toList(),
      ),
    );
  }

  @override
  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion toDB() {
    return CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
      datosIniciales.cuadricula.copyWith(
        titulo: Value(tituloControl.value!),
        descripcion: Value(descripcionControl.value!),
      ),
      controllersPreguntas.map((e) {
        final e1 = e.toDB();
        return e1.copyWith(
            pregunta: e1.pregunta.copyWith(
          sistemaId: Value(sistemaControl.value?.id),
          subSistemaId: Value(subSistemaControl.value?.id),
          eje: Value(ejeControl.value),
          lado: Value(ladoControl.value),
          posicionZ: Value(posicionZControl.value),
          tipo: Value(tipoDePreguntaControl.value!),
        ));
      }).toList(),
      controllersRespuestas.map((e) => e.toDB()).toList(),
    );
  }

  /// Añade una opcion de respuesta a los controles
  @override
  void agregarRespuesta() {
    final nuevoController = CreadorRespuestaController();
    controllersRespuestas.add(nuevoController);
    respuestasControl.add(nuevoController.control);
  }

  /// Elimina de los controles, la opcion de respuesta [c]
  @override
  void borrarRespuesta(CreacionController c) {
    controllersRespuestas.remove(c);
    respuestasControl.remove(c.control);
  }

  void agregarPregunta() {
    /// Se le agrega el sistema y subsistema por defecto de la cuadricula,
    final nuevoController = CreadorPreguntaController(
      _repository,
      sistemaControl.value!,
      subSistemaControl.value!,
      parteDeCuadricula: true,
    );
    controllersPreguntas.add(nuevoController);
    preguntasControl.add(nuevoController.control);
  }

  /// Elimina del control 'pregunta' una instancia
  void borrarPregunta(CreadorPreguntaController c) {
    controllersPreguntas.remove(c);
    preguntasControl.remove(c.control);
  }
}

class PreguntaNumericaCompanion {
  final PreguntasCompanion pregunta;
  final List<CriticidadesNumericasCompanion> criticidades;

  PreguntaNumericaCompanion(
    this.pregunta,
    this.criticidades,
  );
  PreguntaNumericaCompanion.fromDataClass(PreguntaNumerica p)
      : pregunta = p.pregunta.toCompanion(true),
        criticidades = p.criticidades.map((o) => o.toCompanion(true)).toList();
  const PreguntaNumericaCompanion.vacio()
      : pregunta = const PreguntasCompanion(),
        criticidades = const [];

  PreguntaNumericaCompanion copyWith({
    PreguntasCompanion? pregunta,
    List<CriticidadesNumericasCompanion>? criticidades,
  }) =>
      PreguntaNumericaCompanion(
        pregunta ?? this.pregunta,
        criticidades ?? this.criticidades,
      );
}

class CreadorPreguntaNumericaController extends CreacionController {
  final CuestionariosRepository _repository;

  final PreguntaNumericaCompanion datosIniciales;

  final Sistema? _sistemaInicial;
  final SubSistema? _subSistemaInicial;

  final ValueNotifier<List<SubSistema>> subSistemasDisponibles =
      ValueNotifier<List<SubSistema>>([]);

  /// Controles del bloque del formulario
  late final tituloControl = fb.control<String>(
    datosIniciales.pregunta.titulo.valueOrDefault(""),
    [Validators.required],
  );
  late final descripcionControl = fb
      .control<String>(datosIniciales.pregunta.descripcion.valueOrDefault(""));
  late final sistemaControl = fb.control<Sistema?>(
    _sistemaInicial,
    [Validators.required],
  )..valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemasDisponibles.value =
          sistema == null ? [] : await _repository.getSubSistemas(sistema);
    });
  late final subSistemaControl = fb.control<SubSistema?>(
    _subSistemaInicial,
    [Validators.required],
  );
  late final ejeControl = fb.control<String?>(
    datosIniciales.pregunta.eje.valueOrDefault(""),
    [Validators.required],
  );
  late final ladoControl = fb.control<String?>(
    datosIniciales.pregunta.lado.valueOrDefault(""),
    [Validators.required],
  );
  late final posicionZControl = fb.control<String?>(
    datosIniciales.pregunta.posicionZ.valueOrDefault(""),
    [Validators.required],
  );
  late final criticidadControl = fb.control<double>(
      datosIniciales.pregunta.criticidad.valueOrDefault(0).toDouble());
  late final fotosGuiaControl = fb.array<File>(
    datosIniciales.pregunta.fotosGuia
        .valueOrDefault(const KtList.empty())
        .iter
        .map((e) => File(e))
        .toList(),
  );

  /// Rangos de criticidad
  late final controllersCriticidades = datosIniciales.criticidades
      .map((e) => CreadorCriticidadesNumericasController(e))
      .toList();
  late final criticidadesControl = fb.array<Map<String, dynamic>>(
    controllersCriticidades.map((e) => e.control).toList(),
  );

  @override
  late final control = fb.group({
    'titulo': tituloControl,
    'descripcion': descripcionControl,
    'sistema': sistemaControl,
    'subSistema': subSistemaControl,
    'eje': ejeControl,
    'lado': ladoControl,
    'posicionZ': posicionZControl,
    'criticidad': criticidadControl,
    'fotosGuia': fotosGuiaControl,
    'criticidadRespuesta': criticidadesControl,
  });

  CreadorPreguntaNumericaController(
    this._repository,
    this._sistemaInicial,
    this._subSistemaInicial, {
    this.datosIniciales = const PreguntaNumericaCompanion.vacio(),
  });

  /// Agrega control a 'criticidadRespuesta' para añadir un rango de criticidad a la pregunta numerica
  void agregarCriticidad() {
    final nuevoController = CreadorCriticidadesNumericasController();
    controllersCriticidades.add(nuevoController);
    criticidadesControl.add(nuevoController.control);
  }

  /// Elimina Control de 'criticidadRespuesta'
  void borrarCriticidad(CreacionController c) {
    controllersCriticidades.remove(c);
    criticidadesControl.remove(c.control);
  }

  @override
  CreadorPreguntaNumericaController copy() {
    final copied = toDB();

    return CreadorPreguntaNumericaController(
      _repository,
      sistemaControl.value,
      subSistemaControl.value,
      datosIniciales: copied.copyWith(
        pregunta: copied.pregunta.copyWith(
          id: const Value.absent(),
          bloqueId: const Value.absent(),
        ),
        criticidades: copied.criticidades
            .map((o) => o.copyWith(
                  id: const Value.absent(),
                  preguntaId: const Value.absent(),
                ))
            .toList(),
      ),
    );
  }

  /// En caso de que ya exista [preguntaDesdeDB], se actualiza con los nuevos
  /// valores introducidos en el formulario, (Como ya tiene id, se actualiza en la bd)
  /// Si no se "crea" uno con el método [toDataClass()]
  /// Este método es usado a la hora de guardar el cuestionario en la bd.
  @override
  PreguntaNumericaCompanion toDB() {
    return PreguntaNumericaCompanion(
      datosIniciales.pregunta.copyWith(
        titulo: Value(tituloControl.value!),
        descripcion: Value(descripcionControl.value!),
        sistemaId: Value(sistemaControl.value?.id),
        subSistemaId: Value(subSistemaControl.value?.id),
        eje: Value(ejeControl.value),
        lado: Value(ladoControl.value),
        posicionZ: Value(posicionZControl.value),
        criticidad: Value(criticidadControl.value!.round()),
        fotosGuia: Value(fotosGuiaControl.controls
            .map((e) => e.value!.path)
            .toImmutableList()),
        tipo: const Value(TipoDePregunta.numerica),
      ),
      controllersCriticidades.map((e) => e.toDB()).toList(),
    );
  }
}

/// Usada por las preguntas de seleción y de cuadricula
abstract class ConRespuestas {
  void agregarRespuesta();
  void borrarRespuesta(CreacionController c);
}
