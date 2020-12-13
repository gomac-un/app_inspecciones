//esto va en el controlador:
final cuadricula = FormArray([
    FormArray([
      FormControl(value: true),
      FormControl(value: false),
      FormControl(value: false)
    ]),
    FormArray([
      FormControl(value: false),
      FormControl(value: true),
      FormControl(value: false)
    ]),
    FormArray([
      FormControl(value: false),
      FormControl(value: true),
      FormControl(value: false)
    ]),
  ]);
final labelsFilas = [
    "pregunta 1",
    "La pregunta 2 es excesivamente larga por lo tanto se debe controlar el overflow",
    "pregunta 3"
  ];

  final labelsColumnas = [
    "respuesta 1",
    "La respuesta 2 es excesivamente larga por lo tanto se debe controlar el overflow",
    "respuesta 3"
  ];
  
//ui:
RespuestaCard(
              titulo: "Prueba 3",
              descripcion: "descripcion descriptiva de la prueba 3",
              child: ReactiveFormArray<List<bool>>(
                formArray: viewModel.cuadricula,
                builder: (context, formArray, child) {
                  print(viewModel.cuadricula == formArray);
                  return Table(
                    border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.black26)),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    // defaultColumnWidth: IntrinsicColumnWidth(), // esto es caro
                    columnWidths: {0: FlexColumnWidth(2)},
                    children: [
                      TableRow(
                        children: [
                          Text(""),
                          ...viewModel.labelsColumnas.map(
                            (e) => Text(
                              e,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      ...IterableZip(
                          [viewModel.labelsFilas, formArray.controls]).map((e) {
                        final textoPregunta = e[0] as String;
                        final ctrlFila = e[1] as FormArray<bool>;
                        return TableRow(
                          children: [
                            Text(textoPregunta),
                            ...ctrlFila.controls
                                .map((ctrlColumna) => ReactiveCheckbox(
                                      formControl:
                                          ctrlColumna as FormControl<bool>,
                                    ))
                                .toList(),
                          ],
                        );
                      }).toList(),
                    ],
                  );
                },
              ),
            ),