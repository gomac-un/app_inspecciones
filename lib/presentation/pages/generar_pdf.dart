import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';

import 'package:inspecciones/infrastructure/moor_database.dart';
import 'package:inspecciones/injection.dart';
import 'package:pdf/widgets.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:share/share.dart';

//! No importar nada de flutter aca, solo de package:pdf
/* TODO: resumen al final de la inspeccion

criticidad de la inspeccion suma

titulo pregunta
descripcion
criticidad pregunta * respuesta si > 0
observacion
observacion de reparacion
fotos
*/
generarPDF(/*Inspeccion ins*/) async {
  //final lista = pw.Column();

  final lista = ListView(
    children: [Text("coltest")],
  );
  final tabla = Table(children: [TableRow()]);

  final cuadriculaSelUnica1 = Container(
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(border: Border.all()),
    child: Column(
      children: [
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
      ],
    ),
  );
  final cuadriculaSelUnica2 = Container(
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(border: Border.all()),
    child: Column(
      children: [
        Text("p1as : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
      ],
    ),
  );
  final cuadriculaSelUnica3 = Container(
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(border: Border.all()),
    child: Column(
      children: [
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
        Text("p1 : r1"),
        Text("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"),
        Text("p3 : r3"),
      ],
    ),
  );

  /*
  final bloquesBD = await getIt<Database>()
      .llenadoDao
      .cargarCuestionario(_cuestionarioId, _vehiculo);
  final bloques = (bloquesBD
        ..sort(
          (a, b) => a.nOrden.compareTo(b.bloque.nOrden),
        ))
      .map<AbstractControl>((e) {
    if (e is BloqueConTitulo) return TituloFormGroup(e.titulo);
    if (e is BloqueConPreguntaSimple) {
      return RespuestaSeleccionSimpleFormGroup(e.pregunta, e.respuesta);
    }
    if (e is BloqueConCuadricula) {
      return RespuestaCuadriculaFormArray(e.cuadricula, e.preguntasRespondidas);
    }
    throw Exception("Tipo de bloque no reconocido");
  }).toList();*/

  final pdf = Document();

  /*pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(children: [
            pw.Text("Hello World"),
            lista,
            cuadriculaSelUnica1,
            cuadriculaSelUnica2,
            cuadriculaSelUnica3,
          ]),
        );
      }));*/
  final issues = [
    Issue(id: 1),
    Issue(id: 2),
    Issue(id: 3),
    Issue(id: 4),
    Issue(id: 1),
    Issue(id: 2),
    Issue(id: 3),
    Issue(id: 4),
    Issue(id: 1),
    Issue(id: 2),
    Issue(id: 3),
    Issue(id: 4),
    Issue(id: 1),
    Issue(id: 2),
    Issue(id: 3),
    Issue(id: 4),
    Issue(id: 1),
    Issue(id: 2),
    Issue(id: 3),
    Issue(id: 4),
    Issue(id: 1),
    Issue(id: 2),
    Issue(id: 3),
    Issue(id: 4),
  ];
  pdf.addPage(
    MultiPage(
      build: (Context context) => <Widget>[
        Wrap(
          children: List<Widget>.generate(issues.length, (int index) {
            final issue = issues[index];
            return Container(
              child: Column(
                children: <Widget>[
                  Header(
                      text: "Issue n°${issue.id}",
                      textStyle: TextStyle(fontSize: 20)),
                  Text("Description :",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15)),
                ],
              ),
            );
          }),
        ),
      ],
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/example.pdf");
  //final file = File("example.pdf");
  print(file.path);
  await file.writeAsBytes(pdf.save());
  //Share.shareFiles([file.path], text: 'Great pdf');
  OpenFile.open(file.path);
}

class Issue {
  int id;
  Issue({
    this.id,
  });
}
