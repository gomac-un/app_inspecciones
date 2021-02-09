import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:kt_dart/kt.dart';

import 'package:reactive_forms/reactive_forms.dart';

class CreadorTituloFormGroup extends FormGroup implements Copiable {
  CreadorTituloFormGroup([Titulo d])
      : super({
          'titulo': fb.control<String>(d?.titulo ?? "", [Validators.required]),
          'descripcion': fb.control<String>(d?.descripcion ?? "")
        });

  @override
  Future<CreadorTituloFormGroup> copiar() async {
    return CreadorTituloFormGroup(toDataclass());
  }

  Titulo toDataclass() => Titulo(
        id: null,
        fotos: null,
        bloqueId: null,
        titulo: value["titulo"] as String,
        descripcion: value["descripcion"] as String,
      );
}

class CreadorPreguntaFormGroup extends FormGroup
    implements ConRespuestas, Copiable {
  final ValueNotifier<List<SubSistema>> subSistemas;
  final ValueNotifier<TipoDePregunta> tipoUnicaRespuesta;

  factory CreadorPreguntaFormGroup({
    PreguntaConOpcionesDeRespuesta defaultValue,
    bool parteDeCuadricula = false,
    bool esNumerica = false,
  }) {
    final d = defaultValue;
    final sistema = fb.control<Sistema>(null, [Validators.required]);
    final subSistemas = ValueNotifier<List<SubSistema>>([]);
    final tipoDePregunta = fb.control<TipoDePregunta>(
        d?.pregunta?.tipo, [if (!parteDeCuadricula) Validators.required]);
    final tipoUnicaRespuesta = ValueNotifier(TipoDePregunta.multipleRespuesta);
    final respuestas = fb.array<Map<String, dynamic>>(
      d?.opcionesDeRespuesta
              ?.map((e) => CreadorRespuestaFormGroup(
                    defaultValue: e,
                  ))
              ?.toList() ??
          [],
      [if (!parteDeCuadricula && !esNumerica) Validators.minLength(1)],
    );

    tipoDePregunta.valueChanges.asBroadcastStream().listen((tipo) {
      tipoUnicaRespuesta.value = tipo;
    });

    sistema.valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemas.value =
          await getIt<Database>().creacionDao.getSubSistemas(sistema);
    });

    final Map<String, AbstractControl<dynamic>> controles = {
      'titulo':
          fb.control<String>(d?.pregunta?.titulo ?? "", [Validators.required]),
      'descripcion': fb.control<String>(d?.pregunta?.descripcion ?? ""),
      'sistema': sistema,
      'subSistema': fb.control<SubSistema>(null, [Validators.required]),
      'posicion': fb.control<String>(d?.pregunta?.posicion ?? "no aplica"),
      'criticidad':
          fb.control<double>(d?.pregunta?.criticidad?.toDouble() ?? 0),
      'fotosGuia': fb.array<File>(
          d?.pregunta?.fotosGuia?.iter?.map((e) => File(e))?.toList() ?? []),
      'tipoDePregunta':
          tipoDePregunta, //em realidad para las cuadriculas de debe manejar distinto pero se reescribira mas adelante
      'condicional': fb.control<bool>(d?.pregunta?.esCondicional ?? false,
          [if (!parteDeCuadricula & !esNumerica) Validators.required]),
      'respuestas': respuestas,
    };

    return CreadorPreguntaFormGroup._(
        controles, subSistemas, tipoUnicaRespuesta,
        d: d);
  }

  //constructor que le envia los controles a la clase padre
  CreadorPreguntaFormGroup._(Map<String, AbstractControl<dynamic>> controles,
      this.subSistemas, this.tipoUnicaRespuesta,
      {PreguntaConOpcionesDeRespuesta d})
      : super(controles) {
    instanciarControls(d);
    // Machetazo que puede dar resultados inesperados si se utiliza el
    // constructor en codigo sincrono ya que no se está esperando a que termine esta funcion asincrona
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

  @override
  Future<CreadorPreguntaFormGroup> copiar() async {
    return CreadorPreguntaFormGroup(defaultValue: toDataclass());
  }

  PreguntaConOpcionesDeRespuesta toDataclass() =>
      PreguntaConOpcionesDeRespuesta(
        Pregunta(
          id: null,
          bloqueId: null,
          titulo: value['titulo'] as String,
          descripcion: value['descripcion'] as String,
          sistemaId: (value['sistema'] as Sistema)?.id,
          subSistemaId: (value['subSistema'] as SubSistema)?.id,
          posicion: value['posicion'] as String,
          criticidad: (value['criticidad'] as double).round(),
          fotosGuia: (control('fotosGuia') as FormArray<File>)
              .controls
              .map((e) => e.value.path)
              .toImmutableList(),
          tipo: value['tipoDePregunta'] as TipoDePregunta,
          esCondicional: value['condicional'] as bool,
        ),
        (control('respuestas') as FormArray).controls.map((e) {
          final formGroup = e as CreadorRespuestaFormGroup;
          if (value['condicional'] as bool) {
            final x = formGroup.toDataClassCondicional();
            return x.opcionRespuesta;
          }
          return formGroup.toDataClass();
        }).toList(),
      );

  @override
  void agregarRespuesta() => {
        (control('respuestas') as FormArray).add(CreadorRespuestaFormGroup(
            /* esCondicional: value['condicional'] as bool */)),
      };

  @override
  void borrarRespuesta(AbstractControl e) {
    try {
      (control('respuestas') as FormArray).remove(e);
      // ignore: empty_catches
    } on FormControlNotFoundException {}
    return;
  }

  @override
  void dispose() {
    super.dispose();
    subSistemas.dispose();
  }
}

class CreadorCriticidadesNumericas extends FormGroup {
  CreadorCriticidadesNumericas({CriticidadesNumerica d})
      : super({
          'minimo': fb.control<double>(d?.valorMinimo ?? 0, [
            Validators.required,
          ]),
          'maximo': fb.control<double>(d?.valorMaximo ?? 0, [
            Validators.required,
          ]),
          'criticidad': fb.control<double>(d?.criticidad?.toDouble() ?? 0)
        }, validators: [
          _verificarRango('minimo', 'maximo'),
        ]);
  CriticidadesNumerica toDataClass() => CriticidadesNumerica(
        id: null,
        criticidad: (value['criticidad'] as double).round(),
        valorMaximo: value['maximo'] as double,
        valorMinimo: value['minimo'] as double,
        preguntaId: null,
      );
}

ValidatorFunction _verificarRango(String controlMinimo, String controlMaximo) {
  return (AbstractControl<dynamic> control) {
    final form = control as FormGroup;

    final valorMinimo = form.control(controlMinimo);
    final valorMaximo = form.control(controlMaximo);
    if (double.parse(valorMinimo.value.toString()) >=
        double.parse(valorMaximo.value.toString())) {
      valorMaximo.setErrors({'verificarRango': true});
    } else {
      valorMaximo.removeError('verificarRango');
    }

    return null;
  };
}

class CreadorRespuestaFormGroup extends FormGroup {
  factory CreadorRespuestaFormGroup({
    OpcionDeRespuesta defaultValue,
  }) {
    final d = defaultValue;
    final Map<String, AbstractControl<dynamic>> controles = {
      'texto': fb.control<String>(d?.texto ?? "", [Validators.required]),
      'criticidad': fb.control<double>(d?.criticidad?.toDouble() ?? 0),
      'seccion': fb.control<String>(
        '',
        [Validators.required],
      ),
      //em realidad para las cuadriculas de debe manejar distinto pero se reescribira mas adelante
    };

    return CreadorRespuestaFormGroup._(controles, d: d);
  }

  //constructor que le envia los controles a la clase padre
  CreadorRespuestaFormGroup._(Map<String, AbstractControl<dynamic>> controles,
      {OpcionDeRespuesta d})
      : super(controles);

  /* OpcionDeRespuesta toDataClass() => OpcionDeRespuesta(
        id: null,
        texto: value['texto'] as String,
        criticidad: (value['criticidad'] as double).round(),
      ); */

  OpcionDeRespuesta toDataClass() => OpcionDeRespuesta(
        id: null,
        texto: value['texto'] as String,
        criticidad: (value['criticidad'] as double).round(),
      );

  OpcionDeRespuestaConCondicional toDataClassCondicional() =>
      OpcionDeRespuestaConCondicional(
        OpcionDeRespuesta(
          id: null,
          texto: value['texto'] as String,
          criticidad: (value['criticidad'] as double).round(),
        ),
        condiciones: Condicionale(
          preguntaId: null,
          id: null,
          seccion: int.parse(
              (value['seccion'] as String).replaceAll('Ir a bloque ', ''),
              onError: (value) => null),
          opcionDeRespuesta: value['texto'] as String,
        ),
      );
}

class CreadorPreguntaCuadriculaFormGroup extends FormGroup
    implements ConRespuestas, Copiable {
  final ValueNotifier<List<SubSistema>> subSistemas;

  factory CreadorPreguntaCuadriculaFormGroup(
      {CuadriculaConPreguntasYConOpcionesDeRespuesta defaultValue}) {
    final d = defaultValue;
    final sistema = fb.control<Sistema>(null, [Validators.required]);
    final subSistemas = ValueNotifier<List<SubSistema>>([]);

    sistema.valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemas.value =
          await getIt<Database>().creacionDao.getSubSistemas(sistema);
    });

    final Map<String, AbstractControl<dynamic>> controles = {
      'titulo': fb.control<String>(d?.cuadricula?.titulo ?? ""),
      'descripcion': fb.control<String>(d?.cuadricula?.descripcion ?? ""),
      'sistema': sistema,
      'subSistema': fb.control<SubSistema>(null, [Validators.required]),
      'posicion': fb.control<String>("no aplica"),
      'preguntas': fb.array<Map<String, dynamic>>(
        d?.preguntas
                ?.map((e) => CreadorPreguntaFormGroup(
                    defaultValue: e, parteDeCuadricula: true))
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

    return CreadorPreguntaCuadriculaFormGroup._(controles, subSistemas);
  }
  CreadorPreguntaCuadriculaFormGroup._(
    Map<String, AbstractControl<dynamic>> controles,
    this.subSistemas,
  ) : super(controles);

  /// Se le agrega el sistema y subsistema por defecto de la cuadricula,
  /// similar a lo que realiza la factory crearAsync pero sin otros valores por defecto
  Future<void> agregarPregunta() async {
    final instancia = CreadorPreguntaFormGroup(parteDeCuadricula: true);
    await Future.delayed(const Duration(
        seconds:
            1)); //machete para poder asignar el sistema sin que el constructor le asigne null despues
    instancia.controls['sistema'].value = value['sistema'] as Sistema;
    instancia.controls['subSistema'].value = value['subSistema'] as SubSistema;
    (control('preguntas') as FormArray).add(instancia);
  }

  void borrarPregunta(AbstractControl e) {
    try {
      (control('preguntas') as FormArray).remove(e);
      // ignore: empty_catches
    } on FormControlNotFoundException {}
  }

  @override
  void agregarRespuesta() {
    (control('respuestas') as FormArray).add(CreadorRespuestaFormGroup());
  }

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

  @override
  Future<CreadorPreguntaCuadriculaFormGroup> copiar() async {
    //instanciar los sistemas y subsitemas de las preguntas

    return CreadorPreguntaCuadriculaFormGroup(defaultValue: toDataclass());
  }

  CuadriculaConPreguntasYConOpcionesDeRespuesta toDataclass() =>
      CuadriculaConPreguntasYConOpcionesDeRespuesta(
        CuadriculaDePreguntas(
          id: null,
          bloqueId: null,
          titulo: value['titulo'] as String,
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
}

class CreadorPreguntaNumericaFormGroup extends FormGroup
    implements Copiable, Numerica {
  final ValueNotifier<List<SubSistema>> subSistemas;
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
      'titulo':
          fb.control<String>(d?.pregunta?.titulo ?? "", [Validators.required]),
      'descripcion': fb.control<String>(d?.pregunta?.descripcion ?? ""),
      'sistema': sistema,
      'subSistema': fb.control<SubSistema>(null, [Validators.required]),
      'posicion': fb.control<String>(d?.pregunta?.posicion ?? "no aplica"),
      'criticidad':
          fb.control<double>(d?.pregunta?.criticidad?.toDouble() ?? 0),
      'fotosGuia': fb.array<File>(
          d?.pregunta?.fotosGuia?.iter?.map((e) => File(e))?.toList() ?? []),
      'criticidadRespuesta': fb.array<Map<String, dynamic>>(
        d?.criticidades
                ?.map((e) => CreadorCriticidadesNumericas(
                      d: e,
                    ))
                ?.toList() ??
            [],
      )
    };

    return CreadorPreguntaNumericaFormGroup._(controles, subSistemas, d: d);
  }
  CreadorPreguntaNumericaFormGroup._(
      Map<String, AbstractControl<dynamic>> controles, this.subSistemas,
      {PreguntaNumerica d})
      : super(controles) {
    instanciarControls(d);
    // Machetazo que puede dar resultados inesperados si se utiliza el
    // constructor en codigo sincrono ya que no se está esperando a que termine esta funcion asincrona
  }

  Future<void> instanciarControls(PreguntaNumerica d) async {
    controls['sistema'].value =
        await getIt<Database>().getSistemaPorId(d?.pregunta?.sistemaId);
    controls['subSistema'].value =
        await getIt<Database>().getSubSistemaPorId(d?.pregunta?.subSistemaId);
  }

  @override
  Future<CreadorPreguntaNumericaFormGroup> copiar() async {
    return CreadorPreguntaNumericaFormGroup(defaultValue: toDataclass());
  }

  PreguntaNumerica toDataclass() => PreguntaNumerica(
        Pregunta(
          id: null,
          bloqueId: null,
          titulo: value['titulo'] as String,
          descripcion: value['descripcion'] as String,
          sistemaId: (value['sistema'] as Sistema)?.id,
          subSistemaId: (value['subSistema'] as SubSistema)?.id,
          posicion: value['posicion'] as String,
          criticidad: (value['criticidad'] as double).round(),
          fotosGuia: (control('fotosGuia') as FormArray<File>)
              .controls
              .map((e) => e.value.path)
              .toImmutableList(),
          tipo: TipoDePregunta.numerica,
          esCondicional: null,
        ),
        (control('criticidadRespuesta') as FormArray).controls.map((e) {
          final formGroup = e as CreadorCriticidadesNumericas;
          return formGroup.toDataClass();
        }).toList(),
      );

  @override
  void agregarCriticidad() {
    (control('criticidadRespuesta') as FormArray)
        .add(CreadorCriticidadesNumericas());
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
abstract class ConRespuestas {
  void agregarRespuesta();
  void borrarRespuesta(AbstractControl e);
}

abstract class Numerica {
  void agregarCriticidad();
}

abstract class Copiable {
  Future<AbstractControl> copiar();
}
