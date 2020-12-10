import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:inspecciones/domain/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreadorTituloFormGroup extends FormGroup {
  CreadorTituloFormGroup()
      : super({
          'titulo': fb.control<String>(""),
          'descripcion': fb.control<String>("")
        });
}

class CreadorPreguntaSeleccionSimpleFormGroup extends FormGroup {
  ValueNotifier<List<SubSistema>> subSistemas;
  //constructor que le envia los controles a la clase padre
  CreadorPreguntaSeleccionSimpleFormGroup._(
      Map<String, AbstractControl<dynamic>> controles, this.subSistemas)
      : super(controles);

  factory CreadorPreguntaSeleccionSimpleFormGroup() {
    final sistema = fb.control<Sistema>(null);
    final subSistemas = ValueNotifier<List<SubSistema>>([]);

    sistema.valueChanges.asBroadcastStream().listen((sistema) async {
      subSistemas.value = await getIt<Database>().getSubSistemas(sistema);
    });

    final Map<String, AbstractControl<dynamic>> controles = {
      'titulo': fb.control<String>(""),
      'descripcion': fb.control<String>(""),
      'sistema': sistema,
      'subSistema': fb.control<SubSistema>(null),
      'posicion': fb.control<String>("no aplica"),
      'criticidad': fb.control<double>(0),
      'fotosGuia': fb.array<File>([]),
      'tipoDePregunta': fb.control<TipoDePregunta>(null),
      'respuestas': fb.array([]),
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
}

class CreadorRespuestaFormGroup extends FormGroup {
  CreadorRespuestaFormGroup()
      : super({
          'texto': fb.control<String>(""),
          'criticidad': fb.control<double>(0)
        });
}

class CreadorPreguntaCuadriculaFormArray extends FormArray<OpcionDeRespuesta> {
  //constructor que le envia los controles a la clase padre
  CreadorPreguntaCuadriculaFormArray._(
    controles,
  ) : super(controles);

  factory CreadorPreguntaCuadriculaFormArray() {
    FormGroup controles = FormGroup({});

    return CreadorPreguntaCuadriculaFormArray._(
      controles,
    );
  }
}
