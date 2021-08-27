import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspecciones/core/enums.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:inspecciones/presentation/widgets/muti_value_listenable_builder.dart';
import 'package:inspecciones/mvvc/planeacion_grupos_cards.dart';
import 'package:inspecciones/mvvc/planeacion_sistemas_control.dart';
import 'package:inspecciones/presentation/widgets/reactive_multiselect_dialog_field.dart';
import 'package:inspecciones/presentation/widgets/action_button.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../router.gr.dart';

class SistemaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (ctx) => BusquedaControl(),
        dispose: (context, BusquedaControl value) => value.dispose(),
        builder: (context, child) {
          final form = Provider.of<BusquedaControl>(context);
          final filter = form.control('filter').value as String;
          final listaFilter = filter.split(',');
          final listaProgramacion = form.sistemas;
          final lista = filter == ''
              ? ValueNotifier<List<int>>(form.activos)
              : ValueNotifier<List<int>>(form.activos
                  .where((x) => listaFilter.contains(x.toString()))
                  .toList());
          return Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ReactiveTextField(
                      toolbarOptions:
                          const ToolbarOptions(selectAll: true, paste: true),
                      keyboardType: TextInputType.number,
                      formControl:
                          form.control('filter') as FormControl<String>,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.search,
                        ),
                        labelText: 'Buscar activo(s)',
                        hintText: 'Por ejemplo: 311,314,...',
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  MultiValueListenableBuilder<List<int>, bool>(
                    lista,
                    form.cargada,
                    builder:
                        (BuildContext context, value, cargada, Widget child) {
                      if (value.isEmpty) {
                        return Center(
                          child: Text(
                            "Activo no encontrado",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        );
                      }
                      if (!cargada) {
                        return const Align(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: lista.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            final activo = value[index];
                            final progActivo = listaProgramacion
                                .where((x) =>
                                    x.programacion.activoId == Value(activo))
                                .toList();
                            final asignados = progActivo
                                .where((x) =>
                                    x.programacion.estado ==
                                    const Value(EstadoProgramacion.asignado))
                                .toList();
                            final noAsignados = progActivo
                                .where((x) =>
                                    x.programacion.estado ==
                                    const Value(EstadoProgramacion.noAsignado))
                                .toList();
                            final noAplica = progActivo
                                .where((x) =>
                                    x.programacion.estado ==
                                    const Value(EstadoProgramacion.noAplica))
                                .toList();
                            return GruposCard(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DetailSitemasPage(
                                        activo: activo,
                                        sistemas: form.sistemasTotal,
                                        asignados: asignados,
                                        noAsignados: noAsignados,
                                        noAplica: noAplica,
                                      ),
                                    ),
                                  );
                                },
                                leading: IconButton(
                                  icon: Icon(Icons.car_rental,
                                      color: Theme.of(context).accentColor,
                                      size: 30),
                                  onPressed: null,
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios,
                                      color: Theme.of(context).accentColor,
                                      size: 30),
                                  onPressed: null,
                                ),
                                title: Text(
                                  "Número control: $activo",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    asignados.isNotEmpty
                                        ? 'Sistemas asignados: ${asignados.first.sistemas.where((x) => x != null)?.length}'
                                        : 'Sistemas asignados: 0',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    noAsignados.isNotEmpty
                                        ? 'Sistemas no asignados: ${noAsignados.first.sistemas.where((x) => x != null)?.length} '
                                        : 'Sistemas no asignados: 0',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    noAplica.isNotEmpty
                                        ? 'No aplican: ${noAplica.first.sistemas.where((x) => x != null)?.length} '
                                        : 'No aplican: 0',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 15));
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class DetailSitemasPage extends StatelessWidget {
  final int activo;
  final List<Sistema> sistemas;
  final List<Programacion> asignados;
  final List<Programacion> noAsignados;
  final List<Programacion> noAplica;
  const DetailSitemasPage(
      {Key key,
      this.activo,
      this.sistemas,
      this.asignados,
      this.noAsignados,
      this.noAplica})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Programacion noApli =
        noAplica.isEmpty ? Programacion() : noAplica.first;
    final Programacion si =
        asignados.isEmpty ? Programacion() : asignados.first;
    final Programacion noAsig =
        noAsignados.isEmpty ? Programacion() : noAsignados.first;
    final formGroup = ActSistemasControl(si, noAsig, noApli, activo);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sistemas programados'),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Card(
                child: ListTile(
                  title: Text(
                    "Número control: $activo",
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Sistemas asignados: ${si?.sistemas?.where((x) => x != null)?.length ?? 0}',
                          style: Theme.of(context).textTheme.subtitle1
                          /* style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15), */
                          ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          'Sistemas no asignados: ${noAsig?.sistemas?.where((x) => x != null)?.length ?? 0} ',
                          style: Theme.of(context).textTheme.subtitle1),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          'No aplican: ${noApli?.sistemas?.where((x) => x != null)?.length ?? 0} ',
                          style: Theme.of(context).textTheme.subtitle1),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text('Sistemas Asignados',
                              style: Theme.of(context).textTheme.headline6),
                          const Divider(),
                          ReactiveMultiSelectDialogField<Sistema>(
                            buttonText:
                                const Text('Seleccione entre las opciones'),
                            items: sistemas
                                .map((e) => MultiSelectItem(e, e.nombre))
                                .toList(),
                            formControl: formGroup.control('asignados')
                                as FormControl<List<Sistema>>,
                            onTap: () => FocusScope.of(context).unfocus(),
                            validationMessages: (control) => {
                              'repetido':
                                  'Seleccionó algún sistema que ya pertenece a otro grupo'
                            },
                            /* onChanged: (value) {
                            if (formGroup.pregunta.pregunta.esCondicional == true) {
                              viewModel.borrarBloque(
                                formGroup.bloque.nOrden,
                                formGroup.seccion,
                              );
                            }
                          }, */
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          Text('Sistemas no asignados',
                              style: Theme.of(context).textTheme.headline6),
                          const Divider(),
                          ReactiveMultiSelectDialogField<Sistema>(
                            buttonText:
                                const Text('Seleccione entre las opciones'),
                            items: sistemas
                                .map((e) => MultiSelectItem(e, e.nombre))
                                .toList(),
                            formControl: formGroup.control('noAsignados')
                                as FormControl<List<Sistema>>,
                            onTap: () => FocusScope.of(context).unfocus(),
                            validationMessages: (control) => {
                              'repetido':
                                  'Seleccionó algún sistema que ya pertenece a otro grupo'
                            },
                            /* onChanged: (value) {
                        if (formGroup.pregunta.pregunta.esCondicional == true) {
                          viewModel.borrarBloque(
                            formGroup.bloque.nOrden,
                            formGroup.seccion,
                          );
                        }
                  }, */
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          Text('Sistemas que no aplican',
                              style: Theme.of(context).textTheme.headline6),
                          const Divider(),
                          ReactiveMultiSelectDialogField<Sistema>(
                            buttonText:
                                const Text('Seleccione entre las opciones'),
                            items: sistemas
                                .map((e) => MultiSelectItem(e, e.nombre))
                                .toList(),
                            formControl: formGroup.control('noAplica')
                                as FormControl<List<Sistema>>,
                            onTap: () => FocusScope.of(context).unfocus(),
                            validationMessages: (control) => {
                              'repetido':
                                  'Seleccionó algún sistema que ya pertenece a otro grupo'
                            },
                            /* onChanged: (value) {
                        if (formGroup.pregunta.pregunta.esCondicional == true) {
                          viewModel.borrarBloque(
                            formGroup.bloque.nOrden,
                            formGroup.seccion,
                          );
                        }
                  }, */
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return ActionButton(
                iconData: Icons.done_all_outlined,
                label: 'Guardar',
                onPressed: () async {
                  if (formGroup.valid == true) {
                    formGroup.markAllAsTouched();
                    await formGroup.guardarProgramacion();
                    Widget okButton = FlatButton(
                      /* onPressed: () async {
                        Navigator.of(context).pop();
                        await ExtendedNavigator.of(context).replace(
                          Routes.planificacionPage,
                          arguments:
                              PlanificacionPageArguments(indexInicial: 1),
                        );
                      }, */
                      child: const Text("Aceptar"),
                    );

                    // set up the AlertDialog
                    final AlertDialog alert = AlertDialog(
                      content: const Text(
                          "La programación para este activo ha sido actualizada"),
                      actions: [
                        okButton,
                      ],
                    );
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  } else {
                    formGroup.markAllAsTouched();
                    const snackBar =
                        SnackBar(content: Text('El formulario tiene errores'));
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                });
          },
        ) /*  */
        );
  }
}
