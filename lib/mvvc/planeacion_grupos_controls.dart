import 'package:flutter/material.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../injection.dart';

class CrearGrupoControl extends FormGroup {
  final _db = getIt<Database>();
  final fechaInicioSelec = ValueNotifier<DateTime>(DateTime.now());
  final fechaFinSelec =
      ValueNotifier<DateTime>(DateTime.now().add(const Duration(days: 30)));
  CrearGrupoControl()
      : super(
          {
            'fechaInicio': fb.control<DateTime>(null, [Validators.required]),
            'cantidad': fb.control<int>(null, [
              Validators.required,
              Validators.number /* , Validators.max(6) */
            ]),
            'fechaFin': fb.control<DateTime>(null, [Validators.required]),
            'nombre': fb.control<String>(null, [Validators.required]),
          },
        );

  // ignore: use_setters_to_change_properties
  void instanciarInicio(DateTime fecha, String tipo) {
    tipo == 'inicio'
        ? control('fechaInicio').value = fecha
        : control('fechaFin').value = fecha;
  }

  List<GruposInspecciones> crearGrupos() {
    final fechaInicio = value['fechaInicio'] as int;
    final cantidad = value['cantidad'] as int;
    final List<GruposInspecciones> grupos = [];
    int contador = 1;
    DateTime siguienteFecha = DateTime(DateTime.now().year, fechaInicio);
    final otroAnio = DateTime(DateTime.now().year, 12, 31);
    while (siguienteFecha.isBefore(otroAnio)) {
      final inicio = siguienteFecha;
      final siguienteMes = siguienteFecha.month + cantidad;
      final fechaFinal = siguienteMes >= 2 && siguienteMes <= 1
          ? DateTime(DateTime.now().year + 1, siguienteMes)
              .add(const Duration(days: -1))
          : DateTime(DateTime.now().year, siguienteMes)
              .add(const Duration(days: -1));
      final grupo = GruposInspecciones(
        inicio: inicio,
        fin: fechaFinal,
        nGrupo: contador,
        anio: DateTime.now().year,
      );
      grupos.add(grupo);
      contador++;
      siguienteFecha = fechaFinal.add(const Duration(days: 1));
    }
    return grupos;
    /* final fechaFin = value['fechaFin'] as int;
    final totalMeses = fechaFin - fechaInicio + 1;
    final veces = totalMeses ~/ cantidad;
    
    
    for (int i = fechaInicio; i <= fechaFin; i += veces) {
      final grupo = DateTime(DateTime.now().year, i);
      final ensayo =
          DateTime(grupo.year, i + veces).add(const Duration(days: -1));
      grupos.add(GruposInspecciones(
          inicio: grupo, fin: ensayo, nGrupo: contador, anio: ensayo.year));
      contador++;
    }
    return grupos; */
  }

  Future<int> guardarGrupo(List<GruposInspecciones> grupos) async {
    final tipoDeInspeccion =
        control('tipoDeInspeccion').value as TiposDeInspeccione;
    GrupoXTipoInspeccion grupoInspeccion = GrupoXTipoInspeccion(grupos: grupos);
    if (tipoDeInspeccion.tipo == 'Otra') {
      grupoInspeccion = grupoInspeccion.copyWith(
        tipoInspeccion: TiposDeInspeccione(
          tipo: control('nuevoTipoDeInspeccion').value as String,
          id: null,
        ),
      );
    } else {
      grupoInspeccion = grupoInspeccion.copyWith(
        tipoInspeccion: tipoDeInspeccion,
      );
    }
    final idTipo = await _db.planeacionDao.guardarGrupos(grupoInspeccion);
    /* await _db.planeacionDao.borrarGrupos(); */
    return idTipo;
  }
}

/* ValidatorFunction _verificarRango(String controlMinimo, String controlMaximo) {
  return (AbstractControl<dynamic> control) {
    final form = control as FormGroup;

    final valorMinimo = form.control(controlMinimo);
    final valorMaximo = form.control(controlMaximo);
    if ((valorMaximo.value as int) < (valorMinimo.value as int)) {
      valorMaximo.setErrors({'esMenor': true});
    } else {
      valorMaximo.removeError('esMenor');
    }
    if ((valorMaximo.value as int) - (valorMinimo.value as int) < 6) {
      valorMaximo.setErrors({'diferencia': true});
    } else {
      valorMaximo.removeError('diferencia');
    }
    if ((valorMaximo.value as int) == (valorMinimo.value as int)) {
      valorMaximo.setErrors({'esIgual': true});
    } else {
      valorMaximo.removeError('esIgual');
    }
    return null;
  };
} */

class ActualizacionFormGroup extends FormGroup {
  final List<GruposInspecciones> grupos;
  ActualizacionFormGroup(this.grupos)
      : super(
          {
            'grupos': FormArray(grupos.map((e) => GrupisControl(e)).toList()),
          },
        );

  Future actualizarGrupos() async {
    final _bd = getIt<Database>();
    final x = (control('grupos') as FormArray).controls.asMap().entries;
    final gruposAguardar = x.expand<GruposInspecciones>((e) {
      final control = e.value as GrupisControl;
      return [control.toBD()];
    }).toList();
    /* gruposAguardar.add(
      GruposInspecciones(
        inicio: DateTime.now(),
        anio: 2020,
        nGrupo: 1,
        fin: DateTime.now().add(
          const Duration(days: 15),
        ),
      ),
    ); */
    await _bd.planeacionDao.actualizarGrupos(gruposAguardar);
  }

  void borrarBloque(AbstractControl e) {
    try {
      (control("grupos") as FormArray).remove(e);
    } on FormControlNotFoundException {}
  }

  Future borrar() async {
    final _bd = getIt<Database>();
    await _bd.planeacionDao.borrarGrupos();
  }
}

class GrupisControl extends FormGroup {
  final GruposInspecciones grupo;
  final dic = [
    [1, 'Enero'],
    [2, 'Febrero'],
    [3, 'Marzo'],
    [4, 'Abril'],
    [5, 'Mayo'],
    [6, 'Junio'],
    [7, 'Julio'],
    [8, 'Agosto'],
    [9, 'Septiembre'],
    [10, 'Octubre'],
    [11, 'Noviembre'],
    [12, 'Diciembre']
  ];
  GrupisControl(this.grupo)
      : super(
          {
            'fechaInicio': fb.control<int>(
                grupo?.inicio?.month ?? 12, [Validators.required]),
            'fechaFin':
                fb.control<int>(grupo?.fin?.month ?? 12, [Validators.required]),
          },
        );

  GruposInspecciones toBD() {
    final anio1 = grupo?.inicio?.year;
    int anio2 = anio1;
    if (control('fechaFin').value as int >= 1 &&
        control('fechaFin').value as int <= 3 &&
        control('fechaInicio').value as int <= 12 &&
        control('fechaInicio').value as int >= 9) {
      anio2 = anio1 + 1;
    }
    final fechaFin = DateTime(anio2, (control('fechaFin').value as int) + 1)
        .add(const Duration(days: -1));
    return grupo?.copyWith(
      inicio: DateTime(anio1, control('fechaInicio').value as int),
      fin: fechaFin,
      anio: DateTime.now().year,
    );
  }
}
