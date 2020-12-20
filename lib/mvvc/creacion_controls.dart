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

class CreadorPreguntaSeleccionSimpleFormGroup extends FormGroup
    implements ConRespuestas, Copiable {
  final ValueNotifier<List<SubSistema>> subSistemas;

  factory CreadorPreguntaSeleccionSimpleFormGroup(
      [PreguntaConOpcionesDeRespuesta d]) {
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
      'posicion': fb.control<String>("no aplica"),
      'criticidad':
          fb.control<double>(d?.pregunta?.criticidad?.toDouble() ?? 0),
      'fotosGuia': fb.array<File>(
          d?.pregunta?.fotosGuia?.iter?.map((e) => File(e))?.toList() ?? []),
      'tipoDePregunta':
          fb.control<TipoDePregunta>(d?.pregunta?.tipo, [Validators.required]),
      'respuestas': fb.array<Map<String, dynamic>>(
          d?.opcionesDeRespuesta
                  ?.map((e) => CreadorRespuestaFormGroup(e))
                  ?.toList() ??
              [],
          [Validators.minLength(1)]),
    };

    return CreadorPreguntaSeleccionSimpleFormGroup._(controles, subSistemas);
  }

  //constructor que le envia los controles a la clase padre
  CreadorPreguntaSeleccionSimpleFormGroup._(
      Map<String, AbstractControl<dynamic>> controles, this.subSistemas)
      : super(controles);

  /// debido a que las instancias de sistema y subsistema se deben obtener desde la bd,
  /// se debe usar esta factory que los busca en la bd, de lo contrario quedan null
  static Future<CreadorPreguntaSeleccionSimpleFormGroup> crearAsync(
      [PreguntaConOpcionesDeRespuesta d]) async {
    final instancia = CreadorPreguntaSeleccionSimpleFormGroup(d);

    // Do initialization that requires async
    instancia.controls['sistema'].value =
        await getIt<Database>().getSistemaPorId(d.pregunta.sistemaId);
    instancia.controls['subSistema'].value =
        await getIt<Database>().getSubSistemaPorId(d.pregunta.subSistemaId);

    // Return the fully initialized object
    return instancia;
  }

  @override
  Future<CreadorPreguntaSeleccionSimpleFormGroup> copiar() async {
    return CreadorPreguntaSeleccionSimpleFormGroup.crearAsync(toDataclass());
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
          parteDeCuadricula: null,
          tipo: value['tipoDePregunta'] as TipoDePregunta,
        ),
        (control('respuestas') as FormArray).controls.map((e) {
          final formGroup = e as FormGroup;
          return OpcionDeRespuesta(
            id: null,
            texto: formGroup.value['texto'] as String,
            criticidad: (formGroup.value['criticidad'] as double).round(),
          );
        }).toList(),
      );

  @override
  void agregarRespuesta() =>
      (control('respuestas') as FormArray).add(CreadorRespuestaFormGroup());

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

class CreadorRespuestaFormGroup extends FormGroup {
  CreadorRespuestaFormGroup([OpcionDeRespuesta d])
      : super({
          'texto': fb.control<String>(d?.texto ?? "", [Validators.required]),
          'criticidad': fb.control<double>(d?.criticidad?.toDouble() ?? 0)
        });
}

class CreadorPreguntaCuadriculaFormGroup extends FormGroup
    implements ConRespuestas {
  final ValueNotifier<List<SubSistema>> subSistemas;

  factory CreadorPreguntaCuadriculaFormGroup() {
    final sistema = fb.control<Sistema>(null, [Validators.required]);
    final subSistemas = ValueNotifier<List<SubSistema>>([]);

    sistema.valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemas.value =
          await getIt<Database>().creacionDao.getSubSistemas(sistema);
    });

    final Map<String, AbstractControl<dynamic>> controles = {
      'titulo': fb.control<String>(""),
      'descripcion': fb.control<String>(""),
      'sistema': sistema,
      'subSistema': fb.control<SubSistema>(null, [Validators.required]),
      'posicion': fb.control<String>("no aplica"),
      'preguntas':
          fb.array<Map<String, dynamic>>([], [Validators.minLength(1)]),
      'respuestas':
          fb.array<Map<String, dynamic>>([], [Validators.minLength(1)]),
    };

    return CreadorPreguntaCuadriculaFormGroup._(controles, subSistemas);
  }
  CreadorPreguntaCuadriculaFormGroup._(
    Map<String, AbstractControl<dynamic>> controles,
    this.subSistemas,
  ) : super(controles);

  void agregarPregunta() {
    (control('preguntas') as FormArray)
        .add(CreadorSubPreguntaCuadriculaFormGroup());
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
}

class CreadorSubPreguntaCuadriculaFormGroup extends FormGroup {
  CreadorSubPreguntaCuadriculaFormGroup()
      : super({
          //! En la bd se agrega el sistema, subsistema, posicion, tipodepregunta correspondiente para no crear mas controles aqui
          'titulo': fb.control<String>("", [Validators.required]),
          'descripcion': fb.control<String>(""),
          'criticidad': fb.control<double>(0),
        });
}

abstract class ConRespuestas {
  void agregarRespuesta();
  void borrarRespuesta(AbstractControl e);
}

abstract class Copiable {
  Future<AbstractControl> copiar();
}
/*
extension XAbstractControl on AbstractControl {
  AbstractControl copy() {
    if (this is FormControl) return fb.control(value, validators);
    if (this is FormArray) {
      final thisarr = this as FormArray;
      final copiedControls = thisarr.controls.map((e) => e.copy()).toList();
      return FormArray(copiedControls, validators: validators);
    }
    if (this is FormGroup) {
      final thisgroup = this as FormGroup;
      final copiedControls =
          thisgroup.controls.map((key, value) => MapEntry(key, value.copy()));
      return FormGroup(copiedControls, validators: validators);
    }
    throw Exception();
  }
}
*/
