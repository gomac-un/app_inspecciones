/// Definición de todos los Controllers de los bloques en la creación de cuestionarios
import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:inspecciones/core/entities/app_image.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:inspecciones/infrastructure/drift_database.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'creacion_validators.dart';
import 'tablas_unidas.dart';

/// Interfaz de todos los controllers involucrados en la creación de cuestionarios
@immutable
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
  /// ! Buscar la manera de definir tagged union types para que sea imposible enviar
  /// objetos que la Database no pueda tratar, por ahora basta con fijarse que la DB
  /// trate todos los posibles objetos retornados por los metodos [toDB].
  Companion toDB();

  /// Libera los recursos de este control
  void dispose() {
    /// creo que no va a ser falta porque al insertarlo en un formgroup superior,
    /// este va a hacer dispose de todo (o deberia)
    control.dispose();
  }
}

mixin ConRespuestas {
  List<CreadorRespuestaController> get controllersRespuestas;
  FormArray<Map<String, dynamic>> get respuestasControl;

  /// Añade una opcion de respuesta a los controles

  void agregarRespuesta() {
    final nuevoController = CreadorRespuestaController();
    controllersRespuestas.add(nuevoController);
    respuestasControl.add(nuevoController.control);
  }

  /// Elimina de los controles, la opcion de respuesta [c]

  void borrarRespuesta(CreadorRespuestaController c) {
    controllersRespuestas.remove(c);
    respuestasControl.remove(c.control);
  }
}

/// Crea o edita un titulo en un cuestionario
/// Si [tituloCompanion] no es null, se insertan los valores de sus campos en el control
/// y se guarda su id para editarlo en la db
/// si es nulo se establecen unos valores por defecto

class CreadorTituloController extends CreacionController {
  final TituloDCompanion _tituloCompanion;

  late final tituloControl = fb.control<String>(
    _tituloCompanion.titulo.titulo.valueOrDefault(" "),
    [Validators.required],
  );
  late final descripcionControl = fb.control<String>(
    _tituloCompanion.titulo.descripcion.valueOrDefault(""),
  );
  late final fotosControl = fb.control<List<AppImage>>(
    _tituloCompanion.titulo.fotos.valueOrDefault([]).toList(),
  );

  @override
  late final control = FormGroup({
    'titulo': tituloControl,
    'descripcion': descripcionControl,
    'fotos': fotosControl,
  });

  /// Recibe el companion de un titulo el cual puede(O DEBE?) contener valores
  /// por defecto para los campos, si incluye la id, el control será actualizado
  /// en la db con la misma id
  CreadorTituloController(
      [this._tituloCompanion = const TituloDCompanion.vacio()]);

  @override
  CreadorTituloController copy() {
    final copied = toDB();
    return CreadorTituloController(
      copied.copyWith(
        titulo: copied.titulo.copyWith(
          id: const Value.absent(),
          bloqueId: const Value.absent(),
        ),
      ),
    );
  }

  /// En caso de que ya exista, se actualiza con los nuevos valores introducidos
  /// en el formulario, (Como ya tenemos un titulo, se actualiza en la bd)
  /// Este método es usado a la hora de guardar el cuestionario en la bd.
  /// Devuelve un [TitulosCompanion] usando el constructor
  /// [TitulosCompanion.insert] pero como no sabemos el bloqueId todavia se debe usar
  /// el constructor normal de companion, pero para insertar mas adelante se deberia
  /// usar el constructor [TitulosCompanion.insert] para asegurarse que todo esté bien.

  @override
  TituloDCompanion toDB() {
    return _tituloCompanion.copyWith(
      titulo: _tituloCompanion.titulo.copyWith(
        titulo: Value(tituloControl.value!),
        descripcion: Value(descripcionControl.value!),
        fotos: Value(fotosControl.value!),
      ),
    );
  }
}

///  Control encargado de manejar las preguntas de tipo selección
class CreadorPreguntaController extends CreacionController with ConRespuestas {
  /// Si se llama al agregar un nuevo bloque (desde [BotonesBloque]), [datosIniciales] es null,
  /// Cuando se va a editar, [datosIniciales] es pasado directamente desde el
  /// controller superior.
  /// Cuando se usa copiar, [datosIniciales] se obtiene desde el método [toDataClass()]
  final PreguntaDeSeleccionCompanion datosIniciales;

  /// Diferencia las de selección y las que son de cuadricula
  final bool parteDeCuadricula;
  final bool esNumerica;

  /// Son las opciones de respuesta.
  /// Si el bloque es nuevo, son null y se pasa un FormArray vacío.
  /// Si es bloque copiado o viene de edición se pasa un FormArray con cada
  /// una de las opciones que ya existen para la pregutna
  @override
  late final controllersRespuestas = datosIniciales.opcionesDeRespuesta
      .map((e) => CreadorRespuestaController(e))
      .toList();

  @override
  late final respuestasControl = fb.array<Map<String, dynamic>>(
    controllersRespuestas.map((e) => e.control).toList(),

    /// Si es parte de cuadricula o numérica no tienen opciones de respuesta
    [if (!parteDeCuadricula && !esNumerica) Validators.minLength(1)],
  );

  late final tipoDePreguntaControl = fb.control<TipoDePregunta>(
    datosIniciales.pregunta.tipoDePregunta
        .valueOrDefault(TipoDePregunta.seleccionUnica),
    [Validators.required],
  );

  @override
  late final control = fb.group({
    'general': camposGeneralesControl,
    'respuestas': respuestasControl,
    'tipoDePregunta': tipoDePreguntaControl,
  });

  final CamposGeneralesPreguntaController controllerCamposGenerales;
  late final camposGeneralesControl = controllerCamposGenerales.control;

  CreadorPreguntaController({
    this.datosIniciales = const PreguntaDeSeleccionCompanion.vacio(),
    this.parteDeCuadricula = false,
    this.esNumerica = false,
  }) : controllerCamposGenerales = CamposGeneralesPreguntaController(
          tituloInicial: datosIniciales.pregunta.titulo,
          descripcionInicial: datosIniciales.pregunta.descripcion,
          etiquetasIniciales: Value(datosIniciales.etiquetas),
          parteDeCuadricula: parteDeCuadricula,
          criticidadInicial: datosIniciales.pregunta.criticidad,
          fotosGuiaIniciales: datosIniciales.pregunta.fotosGuia,
        );

  @override
  CreadorPreguntaController copy() {
    final copied = toDB();

    return CreadorPreguntaController(
      datosIniciales: copied.copyWith(
        pregunta: copied.pregunta.copyWith(
          id: const Value.absent(),
          bloqueId: const Value.absent(),
        ),
        opcionesDeRespuesta: copied.opcionesDeRespuesta
            .map((o) => o.copyWith(
                  id: const Value.absent(),
                  preguntaId: const Value.absent(),
                ))
            .toList(),
        etiquetas: [...copied.etiquetas],
      ),
    );
  }

  /// En caso de que ya exista [datosIniciales], se actualiza con los nuevos
  /// valores introducidos en el formulario, (Como ya tiene id, se actualiza en la bd)
  /// Si no se "crea" uno con el método [toDataClass()]
  /// Este método es usado a la hora de guardar el cuestionario en la bd.
  @override
  PreguntaDeSeleccionCompanion toDB() {
    final g = controllerCamposGenerales; // alias para escribir menos
    return PreguntaDeSeleccionCompanion(
        datosIniciales.pregunta.copyWith(
          titulo: Value(g.tituloControl.value!),
          descripcion: Value(g.descripcionControl.value!),
          tipoDePregunta: Value(tipoDePreguntaControl.value!),
          criticidad: Value(g.criticidadControl.value!.round()),
          fotosGuia: Value(g.fotosGuiaControl.value!),
        ),
        controllersRespuestas.map((e) => e.toDB()).toList(),
        g.etiquetasControl.value!
            .map((e) => EtiquetasDePreguntaCompanion.insert(
                clave: e.clave, valor: e.valor))
            .toList());
  }
}

/// Control encargado de manejar la creación de opciones de respuesta en preguntas de selección o de cuadricula
class CreadorRespuestaController {
  /// Si se llama al agregar criticidad (desde la cración de pregunta numerica), [_respuestaDesdeDB] es null,
  /// Cuando se va a editar, [_respuestaDesdeDB] es pasado directamente desde los BloquesBd de [CreacionFormViewModel.cargarBloques()]
  /// Cuando se usa copiar, [_respuestaDesdeDB] se obtiene desde el método [toDataClass()]
  final OpcionesDeRespuestaCompanion _respuestaDesdeDB;

  late final tituloControl = fb.control<String>(
    _respuestaDesdeDB.titulo.valueOrDefault(""),
    [Validators.required],
  );
  late final descripcionControl = fb.control<String>(
    _respuestaDesdeDB.descripcion.valueOrDefault(""),
  );
  late final criticidadControl = fb.control<double>(
      _respuestaDesdeDB.criticidad.valueOrDefault(0).toDouble());

  late final control = fb.group({
    'titulo': tituloControl,
    'descripcion': descripcionControl,
    'criticidad': criticidadControl,
  });

  CreadorRespuestaController(
      [this._respuestaDesdeDB = const OpcionesDeRespuestaCompanion()]);

  CreadorRespuestaController copy() {
    return CreadorRespuestaController(
      toDB().copyWith(id: const Value.absent()),
    );
  }

  OpcionesDeRespuestaCompanion toDB() {
    return _respuestaDesdeDB.copyWith(
        titulo: Value(tituloControl.value!),
        descripcion: Value(descripcionControl.value!),
        criticidad: Value(criticidadControl.value!.round()));
  }
}

/// Controller que maneja la creación de rangoss de criticidad para preguntas numericas
class CreadorCriticidadesNumericasController {
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

  late final FormGroup control;

  CreadorCriticidadesNumericasController(
      [this._criticidadDB = const CriticidadesNumericasCompanion()]) {
    //No se puede inicializar en el late porque si nunca se usa el control, los
    //validators generales no se van a crear.
    // TODO: arreglar todos los otros controls de la app que sufran de este problema
    control = fb.group({
      'minimo': minimoControl,
      'maximo': maximoControl,
      'criticidad': criticidadControl,
    }, [
      /// Que el valor mínimo sea menor que el introducido en máximo
      //TODO: validación para que no se entrecrucen los rangos
      verificarRango(controlMinimo: minimoControl, controlMaximo: maximoControl)
    ]);
  }

  CreadorCriticidadesNumericasController copy() {
    return CreadorCriticidadesNumericasController(
      toDB().copyWith(id: const Value.absent()),
    );
  }

  CriticidadesNumericasCompanion toDB() {
    return _criticidadDB.copyWith(
      valorMinimo: Value(minimoControl.value!),
      valorMaximo: Value(maximoControl.value!),
      criticidad: Value(criticidadControl.value!.round()),
    );
  }
}

///TODO: reducir la duplicacion de codigo con la pregunta normal
class CreadorPreguntaCuadriculaController extends CreacionController
    with ConRespuestas {
  /// Info cuadricula y opciones de respuesta
  final CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion datosIniciales;

  late final controllersPreguntas = datosIniciales.preguntas
      .map((e) => CreadorPreguntaController(
            datosIniciales: e,
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
  @override
  late final controllersRespuestas = datosIniciales
      .cuadricula.opcionesDeRespuesta
      .map((e) => CreadorRespuestaController(e))
      .toList();

  @override
  late final respuestasControl = fb.array<Map<String, dynamic>>(
    controllersRespuestas.map((e) => e.control).toList(),

    /// Si es parte de cuadricula o numérica no tienen opciones de respuesta
    [Validators.minLength(1)],
  );
  final CamposGeneralesPreguntaController controllerCamposGenerales;
  late final camposGeneralesControl = controllerCamposGenerales.control;

  late final tipoDePreguntaControl = fb.control<TipoDePregunta>(
    (datosIniciales.cuadricula.pregunta.tipoDeCuadricula
                    .valueOrDefault(TipoDeCuadricula.seleccionUnica) ??
                TipoDeCuadricula.seleccionUnica) ==
            TipoDeCuadricula.seleccionUnica
        ? TipoDePregunta.seleccionUnica
        : TipoDePregunta.seleccionMultiple, //WTFFFFFFF
    [Validators.required],
  );

  @override
  late final control = fb.group({
    'general': camposGeneralesControl,
    // de cuadricula
    'preguntas': preguntasControl,
    'respuestas': respuestasControl,
    'tipoDePregunta': tipoDePreguntaControl,
  });

  CreadorPreguntaCuadriculaController({
    this.datosIniciales =
        const CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion.vacio(),
  }) : controllerCamposGenerales = CamposGeneralesPreguntaController(
          tituloInicial: datosIniciales.cuadricula.pregunta.titulo,
          descripcionInicial: datosIniciales.cuadricula.pregunta.descripcion,
          etiquetasIniciales: Value(datosIniciales.cuadricula.etiquetas),
          parteDeCuadricula: true,
          criticidadInicial: datosIniciales.cuadricula.pregunta.criticidad,
          fotosGuiaIniciales: datosIniciales.cuadricula.pregunta.fotosGuia,
        );

  @override
  CreadorPreguntaCuadriculaController copy() {
    final copied = toDB();

    return CreadorPreguntaCuadriculaController(
      datosIniciales: copied.copyWith(
        cuadricula: copied.cuadricula.copyWith(
          pregunta: copied.cuadricula.pregunta.copyWith(
            id: const Value.absent(),
            bloqueId: const Value.absent(),
          ),
          opcionesDeRespuesta: copied.cuadricula.opcionesDeRespuesta
              .map((o) => o.copyWith(
                    id: const Value.absent(),
                    preguntaId: const Value.absent(),
                  ))
              .toList(),
          etiquetas: copied.cuadricula.etiquetas
              .map((o) => o.copyWith(
                    id: const Value.absent(),
                  ))
              .toList(),
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
      ),
    );
  }

  @override
  CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion toDB() {
    final g = controllerCamposGenerales;
    return CuadriculaConPreguntasYConOpcionesDeRespuestaCompanion(
      datosIniciales.cuadricula.copyWith(
        pregunta: datosIniciales.cuadricula.pregunta.copyWith(
          titulo: Value(g.tituloControl.value!),
          descripcion: Value(
            g.descripcionControl.value!,
          ),
          tipoDePregunta: const Value(TipoDePregunta.cuadricula),
          tipoDeCuadricula: Value(
              tipoDePreguntaControl.value! == TipoDePregunta.seleccionUnica
                  ? TipoDeCuadricula.seleccionUnica
                  : TipoDeCuadricula.seleccionMultiple),
          criticidad: Value(g.criticidadControl.value!.round()),
          fotosGuia: Value(g.fotosGuiaControl.value!),
        ),
        opcionesDeRespuesta:
            controllersRespuestas.map((e) => e.toDB()).toList(),
        etiquetas: g.etiquetasControl.value!
            .map((e) => EtiquetasDePreguntaCompanion.insert(
                clave: e.clave, valor: e.valor))
            .toList(),
      ),
      controllersPreguntas.map((e) {
        final e1 = e.toDB();
        return e1.copyWith(
          pregunta: e1.pregunta.copyWith(
            tipoDePregunta: const Value(TipoDePregunta.parteDeCuadricula),
          ),
        );
      }).toList(),
    );
  }

  void agregarPregunta() {
    final nuevoController = CreadorPreguntaController(
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

class CreadorPreguntaNumericaController extends CreacionController {
  final PreguntaNumericaCompanion datosIniciales;

  /// Rangos de criticidad
  late final controllersCriticidades = datosIniciales.criticidades
      .map((e) => CreadorCriticidadesNumericasController(e))
      .toList();
  late final criticidadesControl = fb.array<Map<String, dynamic>>(
    controllersCriticidades.map((e) => e.control).toList(),
  );
  final CamposGeneralesPreguntaController controllerCamposGenerales;
  late final camposGeneralesControl = controllerCamposGenerales.control;

  /// alias de [camposGeneralesControl], usar con sabiduría
  late final g = controllerCamposGenerales;

  late final unidadesControl = fb.control<String>(
    datosIniciales.pregunta.unidades.valueOrDefault("") ?? "",
    [Validators.required],
  );

  @override
  late final control = fb.group({
    'general': camposGeneralesControl,
    'criticidadRespuesta': criticidadesControl,
    'unidades': unidadesControl,
  });

  CreadorPreguntaNumericaController({
    this.datosIniciales = const PreguntaNumericaCompanion.vacio(),
  }) : controllerCamposGenerales = CamposGeneralesPreguntaController(
          tituloInicial: datosIniciales.pregunta.titulo,
          descripcionInicial: datosIniciales.pregunta.descripcion,
          etiquetasIniciales: Value(datosIniciales.etiquetas),
          parteDeCuadricula: false,
          criticidadInicial: datosIniciales.pregunta.criticidad,
          fotosGuiaIniciales: datosIniciales.pregunta.fotosGuia,
        );

  /// Agrega control a 'criticidadRespuesta' para añadir un rango de criticidad a la pregunta numerica
  void agregarCriticidad() {
    final nuevoController = CreadorCriticidadesNumericasController();
    controllersCriticidades.add(nuevoController);
    criticidadesControl.add(nuevoController.control);
  }

  /// Elimina Control de 'criticidadRespuesta'
  void borrarCriticidad(CreadorCriticidadesNumericasController c) {
    controllersCriticidades.remove(c);
    criticidadesControl.remove(c.control);
  }

  @override
  CreadorPreguntaNumericaController copy() {
    final copied = toDB();

    return CreadorPreguntaNumericaController(
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
        etiquetas: copied.etiquetas
            .map((o) => o.copyWith(
                  id: const Value.absent(),
                ))
            .toList(),
      ),
    );
  }

  /// En caso de que ya exista [datosIniciales], se actualiza con los nuevos
  /// valores introducidos en el formulario, (Como ya tiene id, se actualiza en la bd)
  /// Si no se "crea" uno con el método [toDataClass()]
  /// Este método es usado a la hora de guardar el cuestionario en la bd.
  @override
  PreguntaNumericaCompanion toDB() {
    return PreguntaNumericaCompanion(
      datosIniciales.pregunta.copyWith(
        titulo: Value(g.tituloControl.value!),
        descripcion: Value(g.descripcionControl.value!),
        criticidad: Value(g.criticidadControl.value!.round()),
        fotosGuia: Value(g.fotosGuiaControl.value!),
        tipoDePregunta: const Value(TipoDePregunta.numerica),
        unidades: Value(unidadesControl.value!),
      ),
      controllersCriticidades.map((e) => e.toDB()).toList(),
      g.etiquetasControl.value!
          .map((e) => EtiquetasDePreguntaCompanion.insert(
              clave: e.clave, valor: e.valor))
          .toList(),
    );
  }
}

class CamposGeneralesPreguntaController {
  /// Diferencia las de selección y las que son de cuadricula
  final bool parteDeCuadricula;

  /// Controles del bloque del formulario
  final Value<String> tituloInicial;
  late final tituloControl = fb.control<String>(
    tituloInicial.valueOrDefault(""),
    [Validators.required],
  );

  final Value<String> descripcionInicial;
  late final descripcionControl =
      fb.control<String>(descripcionInicial.valueOrDefault(""));

  final Value<List<EtiquetasDePreguntaCompanion>> etiquetasIniciales;
  late final etiquetasControl = fb.control<Set<Etiqueta>>(etiquetasIniciales
      .valueOrDefault([])
      .map((e) => Etiqueta(e.clave.value, e.valor.value))
      .toSet());

  final Value<int> criticidadInicial;
  late final criticidadControl =
      fb.control<double>(criticidadInicial.valueOrDefault(0).toDouble());

  final Value<List<AppImage>> fotosGuiaIniciales;
  late final fotosGuiaControl = fb.control<List<AppImage>>(
    fotosGuiaIniciales.valueOrDefault([]).toList(),
  );

  late final FormGroup control = fb.group({
    'titulo': tituloControl,
    'descripcion': descripcionControl,
    'etiquetas': etiquetasControl,
    'criticidad': criticidadControl,
    'fotosGuia': fotosGuiaControl,
  });

  CamposGeneralesPreguntaController({
    required this.tituloInicial,
    required this.descripcionInicial,
    required this.etiquetasIniciales,
    required this.criticidadInicial,
    required this.fotosGuiaIniciales,
    this.parteDeCuadricula = false,
  });

  List<Etiqueta> getEtiquetasDisponibles(List<Jerarquia> todas) {
    final usadas = etiquetasControl.value!;

    final result = <Etiqueta>[];

    for (final jerarquia in todas) {
      final ruta = <String>[];
      for (final nivel in jerarquia.niveles) {
        final etiquetaParaNivel =
            usadas.firstWhereOrNull((e) => e.clave == nivel);
        if (etiquetaParaNivel != null) {
          ruta.add(etiquetaParaNivel.valor);
          continue;
        } else {
          result.addAll(jerarquia.getEtiquetasDeNivel(nivel, ruta));
          break;
        }
      }
    }
    return result;
  }
}
