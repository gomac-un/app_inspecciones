import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:inspecciones/application/auth/auth_bloc.dart';
import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/infrastructure/repositories/inspecciones_repository.dart';
import 'package:inspecciones/infrastructure/repositories/planeacion_repository.dart';
import 'package:inspecciones/mvvc/planeacion_grupos_controls.dart';
import 'package:inspecciones/presentation/widgets/action_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../injection.dart';

class GruposCard extends StatelessWidget {
  final List<Widget> children;
  final Widget trailing;
  final Widget leading;
  final GruposInspecciones grupo;
  final Widget title;
  final Function() onTap;
  const GruposCard(
      {Key key,
      this.children,
      this.trailing,
      this.leading,
      this.grupo,
      this.title,
      this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 15, right: 15),
      elevation: 10,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: onTap,
            leading: leading,
            trailing: trailing,
            contentPadding: const EdgeInsets.all(10),
            isThreeLine: true,
            title: grupo != null
                ? Text(
                    "${grupo.nGrupo} Grupo",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : title,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          const SizedBox(height: 15)
        ],
      ),
    );
  }
}

class CreacionGrupoCard extends StatelessWidget {
  const CreacionGrupoCard();
  @override
  Widget build(BuildContext context) {
    final selectedDate = DateTime.now();
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
    final authBloc = Provider.of<AuthBloc>(context);
    return MultiProvider(
        providers: [
          RepositoryProvider(
              create: (ctx) => getIt<PlaneacionRepository>(
                  param1: authBloc.state.maybeWhen(
                      authenticated: (u, s) => u.token,
                      orElse: () => throw Exception(
                          "Error inesperado: usuario no encontrado")))),
          Provider(
              create: (ctx) => CrearGrupoControl(),
              dispose: (context, CrearGrupoControl value) => value.dispose(),
              child: this)
        ],
        builder: (context, child) {
          final form = Provider.of<CrearGrupoControl>(context);
          return Scaffold(
            appBar: AppBar(title: const Text('Creación grupos')),
            body: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Theme.of(context).primaryColorLight,
                        child: const ListTile(
                          leading: Icon(Icons.contact_support_rounded,
                              color: Colors.red),
                          title: Text(
                            'Seleccione las fechas de inicio y de fin, los grupos se crearán automáticamente.', /* Luego de crearlos, puede elegir las inspecciones que se realizarán en cada uno de los grupos.', */
                            /*  style: TextStyle(color: Theme.of(context).hintColor), */
                          ),
                        ),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context).backgroundColor,
                              width: 2.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReactiveForm(
                          formGroup: form,
                          child: Column(
                            children: [
                              ReactiveTextField(
                                formControl: form.control('nombre')
                                    as FormControl<String>,
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  labelText: 'Nombre',
                                  helperMaxLines: 2,
                                  helperText:
                                      'Asigne un nombre a esta ronda de grupos.',
                                ),
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 10.0),
                              ReactiveTextField(
                                validationMessages: (control) => {
                                  'required': 'Este valor es requerido',
                                },
                                formControlName: 'cantidad',
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  labelText: 'Periodicidad (en meses)',
                                  helperMaxLines: 2,
                                  helperText:
                                      'Digite la periodicidad de la inspección',
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 10.0),
                              ValueListenableBuilder<DateTime>(
                                builder: (BuildContext context, value,
                                    Widget child) {
                                  return ReactiveTextField(
                                      readOnly: true,
                                      textInputAction: TextInputAction.next,
                                      validationMessages: (control) =>
                                          {'required': 'Seleccione la fecha'},
                                      formControlName: 'fechaInicio',
                                      decoration: const InputDecoration(
                                        labelText: 'Fecha de inicio',
                                        fillColor: Colors.transparent,
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      onTap: () => _mostrarDatePicker(
                                          context, value, 'inicio'));
                                },
                                valueListenable: form.fechaInicioSelec,
                              ),
                              const SizedBox(height: 10),
                              ValueListenableBuilder<DateTime>(
                                builder: (BuildContext context, value,
                                    Widget child) {
                                  return ReactiveTextField(
                                      readOnly: true,
                                      textInputAction: TextInputAction.next,
                                      validationMessages: (control) =>
                                          {'required': 'Seleccione la fecha'},
                                      formControlName: 'fechaFin',
                                      decoration: const InputDecoration(
                                        labelText: 'Fecha de fin',
                                        fillColor: Colors.transparent,
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      onTap: () => _mostrarDatePicker(
                                          context, value, 'fin'));
                                },
                                valueListenable: form.fechaFinSelec,
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Builder(
                      builder: (BuildContext context) {
                        return ActionButton(
                            iconData: Icons.save,
                            label: 'Guardar',
                            onPressed: () {
                              if (form.valid == true) {
                                form.markAllAsTouched();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                );
                                mostrarAlertaGrupos(context);
                              } else {
                                form.markAllAsTouched();
                                final snackBar = SnackBar(
                                    content: Text(
                                        'Verifique los datos ${form.errors.toString()}'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                            });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

/// Muestra el DatePicker.
///
/// [tipo] se usa para saber que control es, si el de 'fechaInicio' o el de 'fechaFin'
Future _mostrarDatePicker(
    BuildContext context, DateTime value, String tipo) async {
  final form = Provider.of<CrearGrupoControl>(context, listen: false);
  final DateTime picked = await showDatePicker(
      context: context,
      locale: const Locale("es", ""),
      initialDate: value, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      helpText: 'Seleccione fecha de $tipo', // Can be used as title
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      errorFormatText: 'Ingrese una fecha válida',
      fieldLabelText: 'Fecha $tipo',
      fieldHintText: 'Mes/Día/Año',
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).accentColor,
                surface: Theme.of(context).primaryColor,
                onPrimary: Colors.black,
              ),
              textTheme: const TextTheme(
                overline: TextStyle(fontSize: 15),
                subtitle1: TextStyle(color: Colors.black),
              )),
          child: child,
        );
      });
  final fecha = tipo == 'inicio' ? form.fechaInicioSelec : form.fechaFinSelec;
  if (picked != null && picked != fecha.value) {
    tipo == 'inicio'
        ? form.fechaInicioSelec.value = picked
        : form.fechaFinSelec.value = picked;

    /// Hace que el valor del reactiveTextField sea el seleccionado en el DateTimePicker
    form.instanciarInicio(picked, tipo);
  }
}

void mostrarAlertaGrupos(BuildContext context) {
  final form = Provider.of<CrearGrupoControl>(context, listen: false);
  final grupos = form.crearGrupos();
  final List<Widget> contenido = [
    const Text('Los grupos de inspecciones quedaron distribuidos así: \n'),
    /*  */
  ];
  contenido.insertAll(
    1,
    grupos
        .map(
          (e) => Text.rich(
            TextSpan(// default text style
                children: <TextSpan>[
              TextSpan(
                  text: '${e.nGrupo} grupo:\n',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                text:
                    '  De ${DateFormat('dd/MM/yyyy').format(e.inicio)} a ${DateFormat('dd/MM/yyyy').format(e.fin)}',
              ),
            ]),
          ),
        )
        .toList(),
  );
  Navigator.pop(context);
  final cancelButton = FlatButton(
    onPressed: () => Navigator.of(context).pop(),
    child: Text("Cancelar",
        style: TextStyle(
            color: Theme.of(context).accentColor)), // OJO con el context
  );
  final Widget continueButton = FlatButton(
    onPressed: () async {
      final tipoId = await form.guardarGrupo(grupos);
      final grupo = await getIt<Database>()
          .planeacionDao
          .getGruposXTipoInspeccionId(tipoId);
      final respuesta = await _subirAlServidor(grupo.first, context);
      if (respuesta != "") {
        Navigator.of(context).pop();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'Los grupos fueron guardados localmente, pero no fueron enviados al servidor porque $respuesta'),
        ));
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Grupos creados con éxito'),
        ));
      }
    },
    child: Text("Confirmar",
        style: TextStyle(color: Theme.of(context).accentColor)),
  );
  // set up the AlertDialog
  final alert = AlertDialog(
    title: Text(
      "Resumen",
      style: TextStyle(color: Theme.of(context).accentColor),
    ),
    content: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: contenido,
      ),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<String> _subirAlServidor(
    GrupoXTipoInspeccion grupo, BuildContext context) async {
  return RepositoryProvider.of<PlaneacionRepository>(context)
      .crearGrupos(grupo)
      .then(
        (res) => res.fold(
            (fail) => fail.when(
                pageNotFound: () =>
                    'No se pudo encontrar la página, informe al encargado',
                noHayConexionAlServidor: () => "No hay conexion al servidor",
                noHayInternet: () => "No hay internet",
                serverError: (msg) => "Error interno: $msg",
                credencialesException: () =>
                    'Error inesperado: intente inciar sesión nuevamente'), (u) {
          Navigator.of(context).popUntil(ModalRoute.withName('/grupos-screen'));
          return "";
        }),
      );
}

class DetailGruposPage extends StatelessWidget {
  final TiposDeInspeccionesCompanion tipoInspeccion;
  const DetailGruposPage({Key key, this.tipoInspeccion}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return MultiProvider(
      providers: [
        RepositoryProvider(
            create: (ctx) => getIt<InspeccionesRepository>(
                param1: authBloc.state.maybeWhen(
                    authenticated: (u, s) => u.token,
                    orElse: () => throw Exception(
                        "Error inesperado: usuario no encontrado")))),
        StreamProvider(
            create: (_) => getIt<Database>()
                .planeacionDao
                .getGrupoXInspeccionId(tipoInspeccion.id.value)),
      ],
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final grupos = Provider.of<List<GruposInspecciones>>(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(tipoInspeccion.tipo.value),
          ),
          body: Consumer<List<GruposInspecciones>>(
            builder: (context, grupos1, child) {
              if (grupos1 == null) {
                return const Align(
                  child: CircularProgressIndicator(),
                );
              }
              if (grupos1.isEmpty) {
                return const Text('Error desconocido');
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 10,
                ),
                itemCount: grupos1.length,
                itemBuilder: (context, index) {
                  final grupo = grupos1[index];
                  return GruposCard(
                    grupo: grupo,
                    leading: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.miscellaneous_services_rounded,
                          color: Theme.of(context).accentColor, size: 30),
                    ),
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Fecha inicio: ${DateFormat('dd/MM/yyyy').format(grupo.inicio)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Fecha fin: ${DateFormat('dd/MM/yyyy').format(grupo.fin)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  );
                },
              );
              /*  */
            },
          ),
          floatingActionButton: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              FloatingActionButton(
                onPressed: null,
                child: Icon(
                  Icons.circle,
                  color: Theme.of(context).accentColor,
                ),
              ),
              PopupMenuButton<int>(
                /* offset: const Offset(-15, -120), */
                icon: const Icon(Icons.more_vert, size: 30),
                padding: const EdgeInsets.all(2.0),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 3,
                    child: ListTile(
                      title: Text('Editar',
                          style: TextStyle(color: Colors.grey[800])),
                      selected: true,
                      onTap: () async {
                        Navigator.of(context).pop();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ActualizacionCard(
                              grupos: grupos,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: 4,
                    child: ListTile(
                      selected: true,
                      title: Text('Ver todos',
                          style: TextStyle(color: Colors.grey[800])),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => AllGroupsPage(
                              tipoInspeccion: tipoInspeccion,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ActualizacionCard extends StatelessWidget {
  final List<GruposInspecciones> grupos;
  ActualizacionCard({Key key, this.grupos}) : super(key: key);
  final _animatedListKey = GlobalKey<AnimatedListState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return MultiProvider(
      providers: [
        RepositoryProvider(
            create: (ctx) => getIt<InspeccionesRepository>(
                param1: authBloc.state.maybeWhen(
                    authenticated: (u, s) => u.token,
                    orElse: () => throw Exception(
                        "Error inesperado: usuario no encontrado")))),
        RepositoryProvider(create: (_) => getIt<Database>()),
        Provider(
          create: (ctx) => ActualizacionFormGroup(grupos),
          dispose: (context, ActualizacionFormGroup value) => value.dispose(),
          child: this,
        )
      ],
      // Se usa builder en lugar de child porque con child se intenta acceder al provider del formGroup que todavia se está creando y lanza una excepción
      builder: (context, child) {
        final formGroup =
            Provider.of<ActualizacionFormGroup>(context, listen: false);
        return ReactiveForm(
          formGroup: formGroup,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: const Text('Edición'),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      _agregarGrupo(context);
                    },
                  ),
                ),
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.save, color: Colors.white),
                    onPressed: () async {
                      /*  await getIt<Database>().planeacionDao.datosPrueba(); */
                      /* final x = await getIt<Database>()
                          .planeacionDao
                          .getProgramacionSistemas();
                      print(x); */
                      await formGroup.actualizarGrupos();
                      /*  await formGroup.borrar(); */

                      const mensaje = SnackBar(
                        content: Text('Grupos actualizados'),
                      );
                      Scaffold.of(context).showSnackBar(mensaje);
/* 
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).pop();
                        }); */
                    },
                  ),
                ),
              ],
            ),
            body: AnimatedList(
              key: _animatedListKey,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              initialItemCount:
                  (formGroup.control("grupos") as FormArray).controls.length,
              itemBuilder: (context, index, animation) {
                final grupo = (formGroup.control('grupos') as FormArray)
                    .controls[index] as GrupisControl;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: GruposCard(
                    grupo: grupo.grupo,
                    trailing: IconButton(
                      onPressed: () {
                        final index =
                            (grupo.parent as FormArray).controls.indexOf(grupo);
                        if (index !=
                                (formGroup.control('grupos') as FormArray)
                                        .controls
                                        .length -
                                    1 ||
                            index == 0) return;
                        _animatedListKey.currentState.removeItem(
                          index,
                          (_, animation) => SizeTransition(
                            sizeFactor: animation,
                            child: GruposCard(
                              grupo: grupo.grupo,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  grupo.grupo.inicio != null
                                      ? "Fecha inicio: ${DateFormat('dd/MM/yyyy').format(grupo.grupo?.inicio)}"
                                      : '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                ReactiveDropdownField<int>(
                                  itemHeight: 50,
                                  //La de seleccion unica usa el control de la primer pregunta de la lista
                                  formControl: grupo.control('fechaInicio')
                                      as FormControl<int>,
                                  items: [],
                                  decoration: const InputDecoration(
                                    fillColor: Colors.transparent,
                                    labelText: 'Editar Mes Inicio',
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  grupo.grupo.fin != null
                                      ? 'Fecha fin: ${DateFormat('dd/MM/yyyy').format(grupo.grupo?.fin)}'
                                      : '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                ReactiveDropdownField<int>(
                                  itemHeight: 50,
                                  //La de seleccion unica usa el control de la primer pregunta de la lista
                                  formControl: grupo.control('fechaFin')
                                      as FormControl<int>,
                                  items: grupo.dic
                                      .map(
                                        (mes) => DropdownMenuItem<int>(
                                            value: mes[0] as int,
                                            child: Text(mes[1] as String)),
                                      )
                                      .toList(),
                                  decoration: const InputDecoration(
                                    fillColor: Colors.transparent,
                                    labelText: 'Editar Mes Fin',
                                    helperText:
                                        'Seleccione el mes en el que finalizará el grupo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                        formGroup.borrarBloque(grupo);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        grupo.grupo.inicio != null
                            ? "Fecha inicio: ${DateFormat('dd/MM/yyyy').format(grupo.grupo?.inicio)}"
                            : '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      ReactiveDropdownField<int>(
                        itemHeight: 50,
                        //La de seleccion unica usa el control de la primer pregunta de la lista
                        formControl:
                            grupo.control('fechaInicio') as FormControl<int>,
                        items: grupo.dic
                            .map(
                              (mes) => DropdownMenuItem<int>(
                                  value: mes[0] as int,
                                  child: Text(mes[1] as String)),
                            )
                            .toList(),
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          labelText: 'Editar Mes Inicio',
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        grupo.grupo.fin != null
                            ? 'Fecha fin: ${DateFormat('dd/MM/yyyy').format(grupo.grupo?.fin)}'
                            : '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      ReactiveDropdownField<int>(
                        itemHeight: 50,
                        //La de seleccion unica usa el control de la primer pregunta de la lista
                        formControl:
                            grupo.control('fechaFin') as FormControl<int>,
                        items: grupo.dic
                            .map(
                              (mes) => DropdownMenuItem<int>(
                                  value: mes[0] as int,
                                  child: Text(mes[1] as String)),
                            )
                            .toList(),
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          labelText: 'Editar Mes Fin',
                          helperText:
                              'Seleccione el mes en el que finalizará el grupo',
                        ),
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _agregarGrupo(BuildContext context) {
    final formGroup =
        Provider.of<ActualizacionFormGroup>(context, listen: false);
    final bloques = formGroup.control("grupos") as FormArray;
    final ultimoBloque = bloques.controls.last;
    final mes =
        (ultimoBloque as GrupisControl).control('fechaFin').value as int;
    final siguienteMes = mes == 12
        ? 1
        : ((ultimoBloque as GrupisControl).control('fechaFin').value as int) +
            1;
    final anio = mes != 12 ? DateTime.now().year : DateTime.now().year + 1;
    final siguienteBloque = GruposInspecciones(
      nGrupo: (ultimoBloque as GrupisControl).grupo.nGrupo + 1,
      inicio: DateTime(
        anio,
        siguienteMes,
      ),
    );
    // Aquí voy a validar que el ultimo mes no sea diciembre, o enero porque ya los otros grupos van a ser para el siguietne año
    if (mes == 12 || mes == 1) {
      const mensaje = SnackBar(
        content: Text(
            'El ultimo grupo tiene como mes de fin el límite para este año'),
      );
      Scaffold.of(context).showSnackBar(mensaje);
    } else {
      _animatedListKey.currentState
          .insertItem(bloques.controls.indexOf(ultimoBloque) + 1);
      bloques.insert(bloques.controls.indexOf(ultimoBloque) + 1,
          GrupisControl(siguienteBloque));
    }
  }
}

class AllGroupsPage extends StatelessWidget {
  final TiposDeInspeccionesCompanion tipoInspeccion;

  const AllGroupsPage({Key key, this.tipoInspeccion}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final authBloc = Provider.of<AuthBloc>(context);
    return MultiProvider(
      providers: [
        RepositoryProvider(
            create: (ctx) => getIt<InspeccionesRepository>(
                param1: authBloc.state.maybeWhen(
                    authenticated: (u, s) => u.token,
                    orElse: () => throw Exception(
                        "Error inesperado: usuario no encontrado")))),
        StreamProvider(
            create: (_) => getIt<Database>()
                .planeacionDao
                .obtenerTodosGruposXInspeccionid(tipoInspeccion.id.value)),
        RepositoryProvider(create: (_) => getIt<Database>()),
      ],
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Grupos'),
          ),
          body: Consumer<List<GruposInspecciones>>(
            builder: (context, grupos1, child) {
              if (grupos1 == null) {
                return const Align(
                  child: CircularProgressIndicator(),
                );
              }
              if (grupos1.isEmpty) {
                return const CreacionGrupoCard();
              }
              return GroupedListView<GruposInspecciones, String>(
                order: GroupedListOrder.DESC,
                separator: const SizedBox(
                  height: 15,
                ),
                elements: grupos1,
                groupBy: (element) => element.anio.toString(),
                groupHeaderBuilder: (GruposInspecciones grupo) => Card(
                  color: Theme.of(context).accentColor,
                  margin: const EdgeInsets.only(
                      left: 150, right: 150, top: 10, bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      grupo.anio.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                itemBuilder: (context, GruposInspecciones grupo) {
                  return GruposCard(
                    grupo: grupo,
                    leading: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.miscellaneous_services_rounded,
                          color: Theme.of(context).accentColor, size: 30),
                    ),
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Fecha inicio: ${DateFormat('dd/MM/yyyy').format(grupo.inicio)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Fecha fin: ${DateFormat('dd/MM/yyyy').format(grupo.fin)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  );
                }, // optional
                useStickyGroupSeparators: true, // optional
                floatingHeader: true, // optional
              );
            },
          ),
        ),
      ),
    );
  }
}
