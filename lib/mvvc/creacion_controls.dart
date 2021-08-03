import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/mvvc/creacion_validators.dart';
import 'package:kt_dart/kt.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// Definición de todos los FormGroup de los bloques en la creación de cuetionarios

/// Control para creación de titulos
class CreadorTituloFormGroup extends FormGroup implements Copiable {
  /// Cuando se añade el bloque, [d] es null porque aun no existe.
  /// Cuando se va a editar, [d] es pasado directamente desde los BloquesBd de [CreacionFormViewModel]
  /// Cuando se usa copiar, [d] se obtiene desde el método [toDataClass()]
  final Titulo d;
  CreadorTituloFormGroup({this.d})
      : super({
          'titulo': fb.control<String>(d?.titulo ?? " ", [Validators.required]),
          'descripcion': fb.control<String>(d?.descripcion ?? "")
        });

  /// Devuelve el formGroup, haciendo uso del metodo [toDataClass()]
  @override
  Future<CreadorTituloFormGroup> copiar() async {
    return CreadorTituloFormGroup(d: toDataclass());
  }

  /// Devuelve una instancia de [Titulo] haciendo uso de los valores introducidos en el formulario.
  Titulo toDataclass() => Titulo(
        id: null,
        fotos: null,
        bloqueId: null,
        titulo: value["titulo"] as String ?? ' ',
        descripcion: value["descripcion"] as String ?? '',
      );

  /// En caso de que ya exista [d], se actualiza con los nuevos valores introducidos en el formulario, (Como ya tiene id, se actualiza en la bd)
  /// Si no se "crea" uno con el método [toDataClass()]
  /// Este método es usado a la hora de guardar el cuestionario en la bd.
  Titulo toDB() {
    final titulo = d?.copyWith(
          titulo: value["titulo"] as String ?? ' ',
          descripcion: value["descripcion"] as String ?? '',
        ) ??
        toDataclass();
    return titulo;
  }
}

///  Control encargado de manejar las preguntas de tipo selección
class CreadorPreguntaFormGroup extends FormGroup
    implements ConRespuestas, Copiable {
  final ValueNotifier<List<SubSistema>> subSistemas;

  /// Si se llama al agregar un nuevo bloque (desde [BotonesBloque]), [preguntaPorDefecto] es null,
  /// Cuando se va a editar, [preguntaPorDefecto] es pasado directamente desde los BloquesBd de [CreacionFormViewModel.cargarBloques()]
  /// Cuando se usa copiar, [preguntaPorDefecto] se obtiene desde el método [toDataClass()]
  final PreguntaConOpcionesDeRespuesta preguntaPorDefecto;

  /// Diferencia las de selección y las que son de cuadricula
  final bool parteDeCuadricula;

  factory CreadorPreguntaFormGroup({
    PreguntaConOpcionesDeRespuesta defaultValue,
    bool parteDeCuadricula = false,
    bool esNumerica = false,
  }) {
    final d = defaultValue;
    final c = parteDeCuadricula;
    final sistema = fb.control<Sistema>(null, [Validators.required]);
    final subSistemas = ValueNotifier<List<SubSistema>>([]);

    sistema.valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemas.value =
          await getIt<Database>().creacionDao.getSubSistemas(sistema);
    });

    /// Si es de cuadricula, no se debe requerir que elija el tipo e pregunta
    final tipoDePregunta = fb.control<TipoDePregunta>(
        d?.pregunta?.tipo, [if (!parteDeCuadricula) Validators.required]);

    /// Son las opciones de respuesta.
    /// Si el bloque es nuevo, son null y se pasa un FormArray vacío.
    /// Si es bloque copiado o viene de edición se pasa un FormArray con cada una de las opciones que ya existen para la pregutna
    final respuestas = fb.array<Map<String, dynamic>>(
      d?.opcionesDeRespuesta
              ?.map((e) => CreadorRespuestaFormGroup(
                    defaultValue: e,
                  ))
              ?.toList() ??
          [],

      /// Si es parte de cuadricula o numérica no tienen opciones de respuesta
      [if (!parteDeCuadricula && !esNumerica) Validators.minLength(1)],
    );

    final Map<String, AbstractControl<dynamic>> controles = {
      'titulo':
          fb.control<String>(d?.pregunta?.titulo ?? "", [Validators.required]),
      'descripcion': fb.control<String>(d?.pregunta?.descripcion ?? ""),
      'sistema': sistema,
      'subSistema': fb.control<SubSistema>(null, [Validators.required]),
      'eje': fb.control<String>(d?.pregunta?.eje, [Validators.required]),
      'lado': fb.control<String>(d?.pregunta?.lado, [Validators.required]),
      'posicionZ':
          fb.control<String>(d?.pregunta?.posicionZ, [Validators.required]),
      'criticidad':
          fb.control<double>(d?.pregunta?.criticidad?.toDouble() ?? 0),
      'fotosGuia': fb.array<File>(
          d?.pregunta?.fotosGuia?.iter?.map((e) => File(e))?.toList() ?? []),
      'tipoDePregunta': tipoDePregunta,
      'respuestas': respuestas,
    };

    return CreadorPreguntaFormGroup._(controles, subSistemas, d, c);
  }

  ///Constructor que le envia los controles a la clase padre
  CreadorPreguntaFormGroup._(Map<String, AbstractControl<dynamic>> controles,
      this.subSistemas, this.preguntaPorDefecto, this.parteDeCuadricula)
      : super(controles) {
    instanciarControls(preguntaPorDefecto);

    /// Machetazo que puede dar resultados inesperados si se utiliza el
    /// constructor en codigo sincrono ya que no se está esperando a que termine esta funcion asincrona
  }

  /// debido a que las instancias de sistema y subsistema se deben obtener desde la bd,
  /// se debe usar esta factory que los busca en la bd, de lo contrario quedan null
  /*static Future<CreadorPreguntaFormGroup> crearAsync(
      [PreguntaConOpcionesDeRespuesta d]) async {
    final instancia = CreadorPreguntaFormGroup(defaultValue: d);

    // Do initialization that requires async
    

    // Return the fully initialized object
    return instancia;
  }*/
  Future<void> instanciarControls(PreguntaConOpcionesDeRespuesta d) async {
    controls['sistema'].value =
        await getIt<Database>().getSistemaPorId(d?.pregunta?.sistemaId);
    controls['subSistema'].value =
        await getIt<Database>().getSubSistemaPorId(d?.pregunta?.subSistemaId);
  }

  /// Devuelve el FormGroup con los datos introducidos hasta el momento, haciendo uso del metodo [toDataClass()]
  @override
  Future<CreadorPreguntaFormGroup> copiar() async {
    return CreadorPreguntaFormGroup(defaultValue: toDataclass());
  }

  /// Devuelve una instancia de [PreguntaConOpcionesDeRespuesta] haciendo uso de los valores introducidos en el formulario.
  PreguntaConOpcionesDeRespuesta toDataclass() {
    return PreguntaConOpcionesDeRespuesta(
      Pregunta(
        id: null,
        bloqueId: null,
        titulo: value['titulo'] as String ?? "      ",
        descripcion: value['descripcion'] as String,
        sistemaId: (value['sistema'] as Sistema)?.id,
        subSistemaId: (value['subSistema'] as SubSistema)?.id,
        eje: value['eje'] as String,
        lado: value['lado'] as String,
        posicionZ: value['posicionZ'] as String,
        criticidad: (value['criticidad'] as double).round(),
        fotosGuia: (control('fotosGuia') as FormArray<File>)
            .controls
            .map((e) => e.value.path)
            .toImmutableList(),
        tipo: value['tipoDePregunta'] as TipoDePregunta,
        esCondicional: value['condicional'] as bool,
      ),

      /// Opciones de respuesta
      (control('respuestas') as FormArray).controls.map((e) {
        final formGroup = e as CreadorRespuestaFormGroup;
        /* if (value['condicional'] as bool) {
          final x = formGroup.toDataClassCondicional();
          return OpcionDeRespuestaConCondicional(x.opcionRespuesta,
              condiciones: x.condiciones);
        } */
        return formGroup.toDataClass();
      }).toList(),
    );
  }

  /// En caso de que ya exista [preguntaPorDefecto], se actualiza con los nuevos valores introducidos en el formulario, (Como ya tiene id, se actualiza en la bd)
  /// Si no se "crea" uno con el método [toDataClass()]
  /// Este método es usado a la hora de guardar el cuestionario en la bd.
  PreguntaConOpcionesDeRespuesta toDB() {
    final PreguntaConOpcionesDeRespuesta preguntas =
        PreguntaConOpcionesDeRespuesta(
      preguntaPorDefecto?.pregunta?.copyWith(
            titulo: value['titulo'] as String ?? "     ",
            descripcion: value['descripcion'] as String,
            sistemaId: (value['sistema'] as Sistema)?.id,
            subSistemaId: (value['subSistema'] as SubSistema)?.id,
            eje: value['eje'] as String,
            lado: value['lado'] as String,
            posicionZ: value['posicionZ'] as String,
            criticidad: (value['criticidad'] as double).round(),
            fotosGuia: (control('fotosGuia') as FormArray<File>)
                .controls
                .map((e) => e.value.path)
                .toImmutableList(),
            tipo: value['tipoDePregunta'] as TipoDePregunta ??
                TipoDePregunta.unicaRespuesta,
            esCondicional: value['condicional'] as bool,
          ) ??
          toDataclass().pregunta,
      (control('respuestas') as FormArray).controls.map((e) {
        final formGroup = e as CreadorRespuestaFormGroup;
        return formGroup.toDB();
      }).toList(),
    );
    return preguntas;
  }

  /// Añade una opcion de respuesta a los controles
  @override
  void agregarRespuesta() => {
        (control('respuestas') as FormArray).add(CreadorRespuestaFormGroup(
            /* esCondicional: value['condicional'] as bool */)),
      };

  /// Elimina de los controles, la opcion de respuesta [e]
  @override
  void borrarRespuesta(AbstractControl e) {
    try {
      (control('respuestas') as FormArray).remove(e);
      // ignore: empty_catches
    } on FormControlNotFoundException {}
    return;
  }
}

/// FormGroup que maneja la creación de rangoss de criticidad para preguntas numericas
class CreadorCriticidadesNumericas extends FormGroup {
  /// Si se llama al agregar criticidad (desde la cración de pregunta numerica), [defaultValue] es null,
  /// Cuando se va a editar, [defaultValue] es pasado directamente desde los BloquesBd de [CreacionFormViewModel.cargarBloques()]
  /// Cuando se usa copiar, [defaultValue] se obtiene desde el método [toDataClass()]

  final CriticidadesNumerica defaultValue;
  CreadorCriticidadesNumericas({
    CriticidadesNumerica d,
    this.defaultValue,
  }) : super({
          'minimo': fb.control<double>(d?.valorMinimo ?? 0, [
            Validators.required,
          ]),
          'maximo': fb.control<double>(d?.valorMaximo ?? 0, [
            Validators.required,
          ]),
          'criticidad': fb.control<double>(d?.criticidad?.toDouble() ?? 0)
        }, validators: [
          /// Que el valor mínimo sea menor que el introducido en máximo
          //TODO: validación para que no se entrecrucen los rangos
          verificarRango('minimo', 'maximo'),
        ]);

  /// Devuelve una instancia de [CriticidadesNumerica] haciendo uso de los valores introducidos en el formulario.

  CriticidadesNumerica toDataClass() => CriticidadesNumerica(
        id: null,
        criticidad: (value['criticidad'] as double).round(),
        valorMaximo: value['maximo'] as double,
        valorMinimo: value['minimo'] as double,
        preguntaId: null,
      );

  /// En caso de que ya exista [defaultValue], se actualiza con los nuevos valores introducidos en el formulario, (Como ya tiene id, se actualiza en la bd)
  /// Si no se "crea" uno con el método [toDataClass()]
  /// Este método es usado a la hora de guardar el cuestionario en la bd.

  CriticidadesNumerica toDB() =>
      defaultValue?.copyWith(
        criticidad: (value['criticidad'] as double).round(),
        valorMaximo: value['maximo'] as double,
        valorMinimo: value['minimo'] as double,
      ) ??
      toDataClass();
}

/// FormGroup encargado de manejar la creación de opciones de respuesta en preguntas de selección o de cuadricula
class CreadorRespuestaFormGroup extends FormGroup {
  /// Si se llama al agregar criticidad (desde la cración de pregunta numerica), [respuesta] es null,
  /// Cuando se va a editar, [respuesta] es pasado directamente desde los BloquesBd de [CreacionFormViewModel.cargarBloques()]
  /// Cuando se usa copiar, [respuesta] se obtiene desde el método [toDataClass()]
  final OpcionDeRespuesta respuesta;

  factory CreadorRespuestaFormGroup({
    OpcionDeRespuesta defaultValue,
  }) {
    final d = defaultValue;

    final Map<String, AbstractControl<dynamic>> controles = {
      'texto': fb.control<String>(d?.texto ?? " ", [Validators.required]),
      'criticidad': fb.control<double>(d?.criticidad?.toDouble() ?? 0),
      'calificable': fb.control<bool>(d?.calificable ?? false),
    };

    return CreadorRespuestaFormGroup._(
      controles,
      d,
    );
  }

  //constructor que le envia los controles a la clase padre
  CreadorRespuestaFormGroup._(
      Map<String, AbstractControl<dynamic>> controles, this.respuesta)
      : super(controles);

  /* OpcionDeRespuesta toDataClass() => OpcionDeRespuesta(
        id: null,
        texto: value['texto'] as String,
        criticidad: (value['criticidad'] as double).round(),
      ); */
  /// Devuelve una instancia de [OpcionDeRespuesta] haciendo uso de los valores introducidos en el formulario.

  OpcionDeRespuesta toDataClass() => OpcionDeRespuesta(
        id: null,
        texto: value['texto'] as String ?? ' ',
        criticidad: (value['criticidad'] as double).round(),
        calificable: value['calificable'] as bool,
      );

  /// En caso de que ya exista [respuesta], se actualiza con los nuevos valores introducidos en el formulario,(Como ya tiene id, se actualiza en la bd)
  /// Si no se "crea" uno con el método [toDataClass()]
  /// Este método es usado a la hora de guardar el cuestionario en la bd.
  OpcionDeRespuesta toDB() =>
      respuesta?.copyWith(
        texto: value['texto'] as String ?? ' ',
        criticidad: (value['criticidad'] as double).round(),
        calificable: value['calificable'] as bool,
      ) ??
      toDataClass();

  /* OpcionDeRespuestaConCondicional toDataClassCondicional() =>
      OpcionDeRespuestaConCondicional(
        toDataClass(),
        condiciones: PreguntasCondicionalData(
          preguntaId: null,
          id: null,
          seccion: int.parse(
                  
                  (value['seccion'] as String).replaceAll('Ir a bloque ', ''),
                  onError: (value) => null) ??
              0, 
          opcionDeRespuesta: value['texto'] as String,
        ),
      ); */

/* 
  OpcionDeRespuestaConCondicional toDBCondicional() =>
      OpcionDeRespuestaConCondicional(
        toDB(),
        condiciones: respuesta?.condiciones?.copyWith(
              seccion: int.parse(
                  (value['seccion'] as String).replaceAll('Ir a bloque ', ''),
                  onError: (value) => null) -1,
              opcionDeRespuesta: value['texto'] as String,
            ) ??
            toDataClassCondicional().condiciones,
      ); */
}

/// FormGroup que maneja  la creación de cuadriculas
class CreadorPreguntaCuadriculaFormGroup extends FormGroup
    implements ConRespuestas, Copiable {
  final ValueNotifier<List<SubSistema>> subSistemas;

  /// Si se llama al agregar un nuevo bloque (desde [BotonesBloque]), [cuadricula] y [preguntasDeCuadricula] es null,
  /// Cuando se va a editar, son pasadas directamente desde los BloquesBd de [CreacionFormViewModel.cargarBloques()]
  /// Cuando se usa copiar,  se obtienen desde el método [toDataClass()]

  /// Info cuadricula y opciones de respuesta
  final CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula;

  /// Filas de la cuadricula
  final List<PreguntaConOpcionesDeRespuesta> preguntasDeCuadricula;
  factory CreadorPreguntaCuadriculaFormGroup({
    CuadriculaDePreguntasConOpcionesDeRespuesta cuadricula,
    List<PreguntaConOpcionesDeRespuesta> preguntasDeCuadricula,
  }) {
    final d = cuadricula;
    final n = preguntasDeCuadricula;
    final sistema = fb.control<Sistema>(null, [Validators.required]);
    final subSistemas = ValueNotifier<List<SubSistema>>([]);

    sistema.valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemas.value =
          await getIt<Database>().creacionDao.getSubSistemas(sistema);
    });
    final Map<String, AbstractControl<dynamic>> controles = {
      'titulo': fb.control<String>(d?.cuadricula?.titulo ?? " "),
      'descripcion': fb.control<String>(d?.cuadricula?.descripcion ?? ""),
      'sistema': sistema,
      'subSistema': fb.control<SubSistema>(null, [Validators.required]),
      'eje': fb.control<String>(
          n?.first?.pregunta?.eje ?? '', [Validators.required]),
      'lado': fb.control<String>(
          n?.first?.pregunta?.lado ?? '', [Validators.required]),
      'posicionZ': fb.control<String>(
          n?.first?.pregunta?.posicionZ ?? '', [Validators.required]),
      'posicion': fb.control<String>("no aplica"),
      'tipoDePregunta': fb.control<TipoDePregunta>(
          n?.first?.pregunta?.tipo, [Validators.required]),
      'preguntas': fb.array<Map<String, dynamic>>(
        preguntasDeCuadricula
                ?.map((e) => CreadorPreguntaFormGroup(
                    defaultValue: PreguntaConOpcionesDeRespuesta(
                        e.pregunta, e.opcionesDeRespuesta),
                    parteDeCuadricula: true))
                ?.toList() ??
            [],
        [Validators.minLength(1)],
      ),
      'respuestas': fb.array<Map<String, dynamic>>(
        d?.opcionesDeRespuesta
                ?.map((e) => CreadorRespuestaFormGroup(defaultValue: e))
                ?.toList() ??
            [],
        [Validators.minLength(1)],
      ),
    };

    return CreadorPreguntaCuadriculaFormGroup._(controles, subSistemas, d, n);
  }
  CreadorPreguntaCuadriculaFormGroup._(
    Map<String, AbstractControl<dynamic>> controles,
    this.subSistemas,
    this.cuadricula,
    this.preguntasDeCuadricula,
  ) : super(controles) {
    instanciarControls(preguntasDeCuadricula?.first);
  }

  /// Los valores de subsistema, posicion y tipo de pregunta se instancian con el valor de la primera pregunta
  // La cosa es que si se agrega una pregunta sin haber llenado esa info, va a generar un error al guardar
  // porque a esa pregunta se le pasan los valores que haya llenado el usuario y estarán vacíos.
  // También, si se llena la info de la cuadricula, pero no se agrega pregunta, al guardar, la info de
  // subsistema, posicion y tipo de pregunta se pierden, ya que no existe ninguna pregunta que guarde la info en la BD
  //TODO: arreglar esto

  Future<void> instanciarControls(PreguntaConOpcionesDeRespuesta d) async {
    controls['sistema'].value =
        await getIt<Database>().getSistemaPorId(d?.pregunta?.sistemaId);
    controls['subSistema'].value =
        await getIt<Database>().getSubSistemaPorId(d?.pregunta?.subSistemaId);
    controls['eje'].value = d?.pregunta?.eje;
    controls['lado'].value = d?.pregunta?.lado;
    controls['posicionZ'].value = d?.pregunta?.posicionZ;
    controls['tipoDePregunta'].value = d?.pregunta?.tipo;
  }

  /// Se le agrega el sistema y subsistema por defecto de la cuadricula,
  /// similar a lo que realiza la factory crearAsync pero sin otros valores por defecto
  Future<void> agregarPregunta() async {
    final instancia = CreadorPreguntaFormGroup(parteDeCuadricula: true);
    await Future.delayed(const Duration(
        seconds:
            1)); //machete para poder asignar el sistema sin que el constructor le asigne null despues
    instancia.controls['sistema'].value = value['sistema'] as Sistema;
    instancia.controls['subSistema'].value = value['subSistema'] as SubSistema;
    instancia.controls['eje'].value = value['eje'] as String;
    instancia.controls['lado'].value = value['lado'] as String;
    instancia.controls['posicionZ'].value = value['posicionZ'] as String;
    instancia.controls['tipoDePregunta'].value =
        value['tipoDePregunta'] as TipoDePregunta;
    (control('preguntas') as FormArray).add(instancia);
  }

  /// Elimina del control 'pregunta' una instancia
  void borrarPregunta(AbstractControl e) {
    try {
      (control('preguntas') as FormArray).remove(e);
      // ignore: empty_catches
    } on FormControlNotFoundException {}
  }

  ///Sirve para agregar fila a la cuadricula
  @override
  void agregarRespuesta() {
    (control('respuestas') as FormArray).add(CreadorRespuestaFormGroup());
  }

  /// Elimina una respuesta [e] de la cuadricula
  @override
  void borrarRespuesta(AbstractControl e) {
    try {
      (control('respuestas') as FormArray).remove(e);
      // ignore: empty_catches
    } on FormControlNotFoundException {}
  }

  @override
  void dispose() {
    super.dispose();
    subSistemas.dispose();
  }

  /// Devuelve un FormGroup con todos los datos introducidos actualmente en el actual.
  @override
  Future<CreadorPreguntaCuadriculaFormGroup> copiar() async {
    final cuadricula = toDataclass();
    final instancia = CreadorPreguntaCuadriculaFormGroup(
      preguntasDeCuadricula: cuadricula.preguntas,
      cuadricula: CuadriculaDePreguntasConOpcionesDeRespuesta(
          cuadricula.cuadricula, cuadricula.opcionesDeRespuesta),
    );
    await Future.delayed(const Duration(
        seconds:
            1)); //machete para poder asignar el sistema sin que el constructor le asigne null despues
    instancia.controls['subSistema'].value = value['subSistema'] as SubSistema;
    instancia.controls['eje'].value = value['eje'] as String;
    instancia.controls['lado'].value = value['lado'] as String;
    instancia.controls['posicionZ'].value = value['posicionZ'] as String;
    //instanciar los sistemas y subsitemas de las preguntas
    return instancia;
  }

  /// Devuelve una instancia de [CuadriculaConPreguntasYConOpcionesDeRespuesta] haciendo uso de los
  /// valores introducidos en el formulario.
  /// Usado cuando se llama [copiar()] o cuando el bloque es nuevo y se va a guardar (no tiene id, entonces crea un nuevo registo en la bd)
  CuadriculaConPreguntasYConOpcionesDeRespuesta toDataclass() =>
      CuadriculaConPreguntasYConOpcionesDeRespuesta(
        CuadriculaDePreguntas(
          id: null,
          bloqueId: null,
          titulo: value['titulo'] as String ?? ' ',
          descripcion: value['descripcion'] as String,
        ),
        (controls['preguntas'] as FormArray).controls.map((e) {
          final formGroup = e as CreadorPreguntaFormGroup;
          return formGroup.toDataclass();
        }).toList(),
        (control('respuestas') as FormArray).controls.map((e) {
          final formGroup = e as CreadorRespuestaFormGroup;
          return formGroup.toDataClass();
        }).toList(),
        /*List<PreguntaConOpcionesDeRespuesta>
        List<OpcionDeRespuesta>*/
      );

  /// En caso de que ya exista [cuadricula], se actualiza con los nuevos valores introducidos en el formulario, (Como ya tiene id, se actualiza en la bd)
  /// Si no se "crea" uno con el método [toDataClass()]
  /// Este método es usado a la hora de guardar el cuestionario en la bd.
  CuadriculaConPreguntasYConOpcionesDeRespuesta toDB() =>
      CuadriculaConPreguntasYConOpcionesDeRespuesta(
        cuadricula?.cuadricula?.copyWith(
              titulo: value['titulo'] as String ?? ' ',
              descripcion: value['descripcion'] as String,
            ) ??
            toDataclass().cuadricula,
        (controls['preguntas'] as FormArray).controls.map((e) {
              final formGroup = e as CreadorPreguntaFormGroup;
              return formGroup.toDB();
            }).toList() ??
            toDataclass().preguntas,
        (control('respuestas') as FormArray).controls.map((e) {
              final formGroup = e as CreadorRespuestaFormGroup;
              return formGroup.toDataClass();
            }).toList() ??
            toDataclass().opcionesDeRespuesta,
      );
}

/// FormGroup encargado de manejar la creación de preguntas numéricas
class CreadorPreguntaNumericaFormGroup extends FormGroup
    implements Copiable, Numerica {
  final ValueNotifier<List<SubSistema>> subSistemas;

  /// Si se llama al agregar un nuevo bloque (desde [BotonesBloque]), [preguntaPorDefecto] es null,
  /// Cuando se va a editar, [preguntaPorDefecto] es pasado directamente desde los BloquesBd de [CreacionFormViewModel.cargarBloques()]
  /// Cuando se usa copiar, [preguntaPorDefecto] se obtiene desde el método [toDataClass()]

  final PreguntaNumerica preguntaPordefecto;
  factory CreadorPreguntaNumericaFormGroup({
    PreguntaNumerica defaultValue,
  }) {
    final d = defaultValue;
    final sistema = fb.control<Sistema>(null, [Validators.required]);
    final subSistemas = ValueNotifier<List<SubSistema>>([]);

    sistema.valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemas.value =
          await getIt<Database>().creacionDao.getSubSistemas(sistema);
    });

    final Map<String, AbstractControl<dynamic>> controles = {
      'titulo': fb
          .control<String>(d?.pregunta?.titulo ?? "  ", [Validators.required]),
      'descripcion': fb.control<String>(d?.pregunta?.descripcion ?? ""),
      'sistema': sistema,
      'subSistema': fb.control<SubSistema>(null, [Validators.required]),
      'eje': fb.control<String>(d?.pregunta?.eje, [Validators.required]),
      'lado': fb.control<String>(d?.pregunta?.lado, [Validators.required]),
      'posicionZ':
          fb.control<String>(d?.pregunta?.posicionZ, [Validators.required]),
      'criticidad':
          fb.control<double>(d?.pregunta?.criticidad?.toDouble() ?? 0),
      'fotosGuia': fb.array<File>(
          d?.pregunta?.fotosGuia?.iter?.map((e) => File(e))?.toList() ?? []),

      ///Rangos de criticidad
      'criticidadRespuesta': fb.array<Map<String, dynamic>>(
        d?.criticidades
                ?.map((e) => CreadorCriticidadesNumericas(
                      defaultValue: e,
                      d: e,
                    ))
                ?.toList() ??
            [],
      )
    };

    return CreadorPreguntaNumericaFormGroup._(controles, subSistemas, d, d: d);
  }
  CreadorPreguntaNumericaFormGroup._(
      Map<String, AbstractControl<dynamic>> controles,
      this.subSistemas,
      this.preguntaPordefecto,
      {PreguntaNumerica d})
      : super(controles) {
    instanciarControls(d);
    // Machetazo que puede dar resultados inesperados si se utiliza el
    // constructor en codigo sincrono ya que no se está esperando a que termine esta funcion asincrona
  }

  /// Consulta el subsistema de [d] en la bd por el id
  Future<void> instanciarControls(PreguntaNumerica d) async {
    controls['sistema'].value =
        await getIt<Database>().getSistemaPorId(d?.pregunta?.sistemaId);
    controls['subSistema'].value =
        await getIt<Database>().getSubSistemaPorId(d?.pregunta?.subSistemaId);
  }

  /// Devuelve el FormGroup con los datos introducidos hasta el momento, haciendo uso del metodo [toDataClass()]
  @override
  Future<CreadorPreguntaNumericaFormGroup> copiar() async {
    return CreadorPreguntaNumericaFormGroup(defaultValue: toDataclass());
  }

  /// Devuelve una instancia de [PreguntaNumerica] haciendo uso de los valores introducidos en el formulario.
  /// Como no tiene id, al guardar se reconoce como un registro nuevo en la bd

  PreguntaNumerica toDataclass() => PreguntaNumerica(
        Pregunta(
              id: null,
              bloqueId: null,
              titulo: value['titulo'] as String ?? '  ',
              descripcion: value['descripcion'] as String,
              sistemaId: (value['sistema'] as Sistema)?.id,
              subSistemaId: (value['subSistema'] as SubSistema)?.id,
              eje: value['eje'] as String,
              lado: value['lado'] as String,
              posicionZ: value['posicionZ'] as String,
              criticidad: (value['criticidad'] as double).round(),
              fotosGuia: (control('fotosGuia') as FormArray<File>)
                  .controls
                  .map((e) => e.value.path)
                  .toImmutableList(),
              tipo: TipoDePregunta.numerica,
              esCondicional: null,
            ) ??
            toDataclass().pregunta,
        (control('criticidadRespuesta') as FormArray).controls.map((e) {
          final formGroup = e as CreadorCriticidadesNumericas;
          return formGroup.toDB();
        }).toList(),
      );

  /// En caso de que ya exista [preguntaPorDefecto], se actualiza con los nuevos valores introducidos en el formulario,
  ///  (Como ya existe un id, en la bd se reconoce como un registro existente y se actualiza)
  /// Si no se "crea" uno con el método [toDataClass()]
  PreguntaNumerica toDB() => PreguntaNumerica(
        preguntaPordefecto?.pregunta?.copyWith(
              titulo: value['titulo'] as String ?? '  ',
              descripcion: value['descripcion'] as String,
              sistemaId: (value['sistema'] as Sistema)?.id,
              subSistemaId: (value['subSistema'] as SubSistema)?.id,
              eje: value['eje'] as String,
              lado: value['lado'] as String,
              posicionZ: value['posicionZ'] as String,
              criticidad: (value['criticidad'] as double).round(),
              fotosGuia: (control('fotosGuia') as FormArray<File>)
                  .controls
                  .map((e) => e.value.path)
                  .toImmutableList(),
              tipo: TipoDePregunta.numerica,
            ) ??
            toDataclass().pregunta,
        (control('criticidadRespuesta') as FormArray).controls.map((e) {
              final formGroup = e as CreadorCriticidadesNumericas;
              return formGroup.toDB();
            }).toList() ??
            toDataclass().criticidades,
      );

  /// Agrega control a 'criticidadRespuesta' para añadir un rango de criticidad a la pregunta numerica
  @override
  void agregarCriticidad() {
    (control('criticidadRespuesta') as FormArray)
        .add(CreadorCriticidadesNumericas());
  }

  /// Elimina Control de 'criticidadRespuesta'
  @override
  void borrarCriticidad(AbstractControl e) {
    /* try { */
    (control('criticidadRespuesta') as FormArray).remove(e);
    // ignore: empty_catches
    /*  } on FormControlNotFoundException {}
    return; */
  }
}

/*
class CreadorSubPreguntaCuadriculaFormGroup extends FormGroup {
  CreadorSubPreguntaCuadriculaFormGroup()
      : super({
          //! En la bd se agrega el sistema, subsistema, posicion, tipodepregunta correspondiente para no crear mas controles aqui
          'titulo': fb.control<String>("", [Validators.required]),
          'descripcion': fb.control<String>(""),
          'criticidad': fb.control<double>(0),
        });
}
*/
/// Usada por las preguntas de seleción y de cuadricula
abstract class ConRespuestas {
  void agregarRespuesta();
  void borrarRespuesta(AbstractControl e);
}

abstract class Numerica {
  void agregarCriticidad();
  void borrarCriticidad(AbstractControl e);
}

/// Usada por todos los bloques.
abstract class Copiable {
  Future<AbstractControl> copiar();
}
