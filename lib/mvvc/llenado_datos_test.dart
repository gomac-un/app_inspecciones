part of 'llenado_form_view_model.dart';

final bloquesDeEjemplo = FormArray([
  TituloFormGroup(
    Titulo(
      bloqueId: 1,
      descripcion: "descripcion del titulazo",
      fotos: [],
      id: 1,
      titulo: "El titulazo",
    ),
  ),
  RespuestaSeleccionSimpleFormGroup(
    PreguntaConOpcionesDeRespuesta(
      Pregunta(
        bloqueId: 2,
        criticidad: 1,
        descripcion: "desc1",
        fotosGuia: [],
        id: 1,
        posicion: "abajo",
        sistemaId: 1,
        subSistemaId: 1,
        tipo: TipoDePregunta.unicaRespuesta,
        titulo: "titulo1",
      ),
      [
        OpcionDeRespuesta(id: 1, preguntaId: 1, texto: "res1", criticidad: 1),
        OpcionDeRespuesta(id: 2, preguntaId: 1, texto: "res2", criticidad: 2),
      ],
    ),
    RespuestaConOpcionesDeRespuesta(
      Respuesta(
        fotosBase: [],
        fotosReparacion: [],
        id: 1,
        inspeccionId: 1,
        observacion: "obs1",
        observacionReparacion: "obrep1",
        preguntaId: 1,
        reparado: false,
      ).toCompanion(true),
      [
        OpcionDeRespuesta(id: 2, preguntaId: 1, texto: "res2", criticidad: 2),
      ],
    ),
  ),
  RespuestaCuadriculaFormArray(
      CuadriculaDePreguntasConOpcionesDeRespuesta(
        CuadriculaDePreguntas(
            id: 1,
            bloqueId: 1,
            descripcion: "descripcion de la cuadricula",
            titulo: "titulo de la cuadricula"),
        [
          OpcionDeRespuesta(
              id: 3,
              cuadriculaId: 1,
              texto: "texto de una columna de la tabla",
              criticidad: 2),
          OpcionDeRespuesta(
              id: 4,
              cuadriculaId: 1,
              texto: "texto2 de una columna de la tabla",
              criticidad: 2)
        ],
      ),
      [
        PreguntaConRespuestaConOpcionesDeRespuesta(
          Pregunta(
            bloqueId: 3,
            criticidad: 1,
            descripcion: "descripcion de la pregunta de una fila de la tabla",
            fotosGuia: [],
            id: 3,
            posicion: "null",
            sistemaId: null,
            subSistemaId: null,
            tipo: TipoDePregunta.parteDeCuadricula,
            titulo: "pregunta de una fila de la tabla",
          ),
          RespuestaConOpcionesDeRespuesta(
            RespuestasCompanion.insert(inspeccionId: null, preguntaId: null),
            [
              OpcionDeRespuesta(
                id: 3,
                cuadriculaId: 2,
                texto: "texto de una columna de la tabla",
                criticidad: 2,
              ),
            ],
          ),
        ),
        PreguntaConRespuestaConOpcionesDeRespuesta(
            Pregunta(
              bloqueId: 3,
              criticidad: 1,
              descripcion:
                  "descripcion2 de la pregunta de una fila de la tabla",
              fotosGuia: [],
              id: 4,
              posicion: "null",
              sistemaId: null,
              subSistemaId: null,
              tipo: TipoDePregunta.parteDeCuadricula,
              titulo: "pregunta2 de una fila de la tabla",
            ),
            RespuestaConOpcionesDeRespuesta(null, null)),
      ]),
]);
