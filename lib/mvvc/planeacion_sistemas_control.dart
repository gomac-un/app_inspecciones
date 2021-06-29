import 'package:flutter/cupertino.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:reactive_forms/reactive_forms.dart';

class BusquedaControl extends FormGroup {
  final List<Programacion> sistemas = [];
  final List<int> activos = [];
  final List<Sistema> sistemasTotal = [];
  ValueNotifier<bool> cargada = ValueNotifier(false);
  BusquedaControl()
      : super(
          {
            'filter': fb.control<String>(''),
          },
        ) {
    _cargarDatos();
  }

  Future _cargarDatos() async {
    final _bd = getIt<Database>();
    final list = await _bd.planeacionDao.getProgramacionSistemas();
    sistemas.insertAll(0, list);
    final activosList = await _bd.planeacionDao.getActivos();
    final sistemasTotalList = await _bd.planeacionDao.programacion();
    activos.insertAll(0, activosList);
    sistemasTotal.insertAll(0, sistemasTotalList);
    cargada.value = true;
  }
}

class ActSistemasControl extends FormGroup {
  final Programacion asignados;
  final Programacion noAsignados;
  final Programacion noAplica;
  final int activo;
  ActSistemasControl(
      this.asignados, this.noAsignados, this.noAplica, this.activo)
      : super({
          'asignados':
              FormControl<List<Sistema>>(value: asignados?.sistemas ?? []),
          'noAsignados':
              FormControl<List<Sistema>>(value: noAsignados?.sistemas ?? []),
          'noAplica':
              FormControl<List<Sistema>>(value: noAplica?.sistemas ?? []),
        }, validators: [
          _verificarSistemas('asignados', 'noAsignados', 'noAplica'),
        ]);

  Future guardarProgramacion() async {
    final bd = getIt<Database>();
    final grupo = await bd.planeacionDao.getGrupoByMonth();
    final progDefault = ProgramacionSistemasCompanion(
      activoId: Value(activo),
      grupoId: Value(grupo.id),
      mes: Value(DateTime.now().month),
    );
    final List<Programacion> listaAGuardar = [
      Programacion(
        programacion: asignados.programacion ??
            progDefault.copyWith(
                estado: const Value(EstadoProgramacion.asignado)),
        sistemas: control('asignados').value as List<Sistema>,
      ),
      Programacion(
        programacion: noAsignados.programacion ??
            progDefault.copyWith(
                estado: const Value(EstadoProgramacion.noAsignado)),
        sistemas: control('noAsignados').value as List<Sistema>,
      ),
      Programacion(
        programacion: noAplica.programacion ??
            progDefault.copyWith(
                estado: const Value(EstadoProgramacion.noAplica)),
        sistemas: control('noAplica').value as List<Sistema>,
      ),
    ];
    await bd.planeacionDao.saveProgramacionSistemas(listaAGuardar);
    print('Hola');
  }
}

ValidatorFunction _verificarSistemas(
    String controlasig, String controlnoAsig, String controlNoApli) {
  return (AbstractControl<dynamic> control) {
    final form = control as FormGroup;

    final valorAsignado = form.control(controlasig).value as List<Sistema>;
    final valorNoAsig = form.control(controlnoAsig).value as List<Sistema>;
    final valorNoAPLI = form.control(controlNoApli).value as List<Sistema>;
    final listAsignados = [];
    final listNoAsignados = [];
    final listNoAplica = [];
    for (int i = 0; i < valorAsignado.length; i++) {
      if ((valorNoAsig.contains(valorAsignado[i]) ||
              valorNoAPLI.contains(valorAsignado[i])) &&
          valorAsignado[i] != null) {
        listAsignados.add(valorAsignado[i]);
      }
    }
    for (int i = 0; i < valorNoAsig.length; i++) {
      if ((valorAsignado.contains(valorNoAsig[i]) ||
              valorNoAPLI.contains(valorNoAsig[i])) &&
          valorNoAsig[i] != null) {
        listNoAsignados.add(valorNoAsig[i]);
      }
    }
    for (int i = 0; i < valorNoAPLI.length; i++) {
      if ((valorAsignado.contains(valorNoAPLI[i]) ||
              valorNoAsig.contains(valorNoAPLI[i])) &&
          valorNoAPLI[i] != null) {
        listNoAplica.add(valorNoAPLI[i]);
      }
    }
    if (listAsignados.isEmpty) {
      form.control(controlasig).removeError('repetido');
    } else {
      form.control(controlasig).setErrors({'repetido': true});
    }
    if (listNoAsignados.isEmpty) {
      form.control(controlnoAsig).removeError('repetido');
    } else {
      form.control(controlnoAsig).setErrors({'repetido': true});
    }
    if (listNoAplica.isEmpty) {
      form.control(controlNoApli).removeError('repetido');
    } else {
      form.control(controlNoApli).setErrors({'repetido': true});
    }
    return null;
  };
}

ValidatorFunction _verificarrango(String controlMinimo, String controlMaximo) {
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
