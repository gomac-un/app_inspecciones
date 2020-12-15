import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreadorTituloFormGroup extends FormGroup {
  CreadorTituloFormGroup()
      : super({
          'titulo': fb.control<String>("", [Validators.required]),
          'descripcion': fb.control<String>("")
        });
}

class CreadorPreguntaSeleccionSimpleFormGroup extends FormGroup
    implements ConRespuestas {
  final ValueNotifier<List<SubSistema>> subSistemas;
  //constructor que le envia los controles a la clase padre
  CreadorPreguntaSeleccionSimpleFormGroup._(
      Map<String, AbstractControl<dynamic>> controles, this.subSistemas)
      : super(controles);

  factory CreadorPreguntaSeleccionSimpleFormGroup() {
    final sistema = fb.control<Sistema>(null, [Validators.required]);
    final subSistemas = ValueNotifier<List<SubSistema>>([]);

    sistema.valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemas.value =
          await getIt<Database>().creacionDao.getSubSistemas(sistema);
    });

    final Map<String, AbstractControl<dynamic>> controles = {
      'titulo': fb.control<String>("", [Validators.required]),
      'descripcion': fb.control<String>(""),
      'sistema': sistema,
      'subSistema': fb.control<SubSistema>(null, [Validators.required]),
      'posicion': fb.control<String>("no aplica"),
      'criticidad': fb.control<double>(0),
      'fotosGuia': fb.array<File>([]),
      'tipoDePregunta': fb.control<TipoDePregunta>(null, [Validators.required]),
      'respuestas':
          fb.array<Map<String, dynamic>>([], [Validators.minLength(1)]),
    };

    return CreadorPreguntaSeleccionSimpleFormGroup._(controles, subSistemas);
  }

  agregarRespuesta() {
    (control('respuestas') as FormArray).add(CreadorRespuestaFormGroup());
  }

  borrarRespuesta(AbstractControl e) {
    try {
      (control('respuestas') as FormArray).remove(e);
    } on FormControlNotFoundException {
      print("que pendejo");
    }
  }

  @override
  void dispose() {
    super.dispose();
    subSistemas.dispose();
  }
}

class CreadorRespuestaFormGroup extends FormGroup {
  CreadorRespuestaFormGroup()
      : super({
          'texto': fb.control<String>("", [Validators.required]),
          'criticidad': fb.control<double>(0)
        });
}

abstract class ConRespuestas {
  agregarRespuesta();
  borrarRespuesta(AbstractControl e);
}

class CreadorPreguntaCuadriculaFormGroup extends FormGroup
    implements ConRespuestas {
  final ValueNotifier<List<SubSistema>> subSistemas;

  CreadorPreguntaCuadriculaFormGroup._(
    Map<String, AbstractControl<dynamic>> controles,
    this.subSistemas,
  ) : super(controles);

  factory CreadorPreguntaCuadriculaFormGroup() {
    final sistema = fb.control<Sistema>(null, [Validators.required]);
    final subSistemas =
        ValueNotifier<List<SubSistema>>([]); //! hay que hacerle dispose

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

  agregarPregunta() {
    (control('preguntas') as FormArray)
        .add(CreadorSubPreguntaCuadriculaFormGroup());
  }

  borrarPregunta(AbstractControl e) {
    try {
      (control('preguntas') as FormArray).remove(e);
    } on FormControlNotFoundException {}
  }

  agregarRespuesta() {
    (control('respuestas') as FormArray).add(CreadorRespuestaFormGroup());
  }

  borrarRespuesta(AbstractControl e) {
    try {
      (control('respuestas') as FormArray).remove(e);
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
