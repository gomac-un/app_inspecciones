import 'dart:io';

import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:test/test.dart';

void main() {
  Iterable<Etiqueta> getEtiquetas(
      String nombreNivel, List<EtiquetaEnJerarquia> children) sync* {
    for (var etiqueta in children) {
      yield Etiqueta(nombreNivel, etiqueta.valor);
    }
  }

  test('etiqueta simple', () {
    final miEtiqueta = Jerarquia.etiqueta(clave: "color", valor: "amarillo");
    expect(
      getEtiquetas(miEtiqueta.niveles[0], miEtiqueta.arbol).first,
      Etiqueta("color", "amarillo"),
    );
  });

  test('jerarquia con un nivel', () {
    final miJerarquia = Jerarquia(
      niveles: ["sistema"],
      arbol: [
        EtiquetaEnJerarquia("motor"),
        EtiquetaEnJerarquia("chasis"),
      ],
    );
    expect(getEtiquetas(miJerarquia.niveles[0], miJerarquia.arbol), [
      Etiqueta("sistema", "motor"),
      Etiqueta("sistema", "chasis"),
    ]);
  });
  test('jerarquia con varios niveles', () {
    final miJerarquia = Jerarquia(niveles: [
      "sistema",
      "subsistema",
      "componente",
    ], arbol: [
      EtiquetaEnJerarquia("motor", [
        EtiquetaEnJerarquia("clutch", [
          EtiquetaEnJerarquia("discos"),
        ]),
        EtiquetaEnJerarquia("cilindro"),
      ]),
      EtiquetaEnJerarquia("chasis"),
    ]);
    final subsistemasDeMotor =
        getEtiquetas(miJerarquia.niveles[1], miJerarquia.arbol[0].children);

    expect(subsistemasDeMotor, [
      Etiqueta("subsistema", "clutch"),
      Etiqueta("subsistema", "cilindro"),
    ]);

    final componentesDeClutch = getEtiquetas(
        miJerarquia.niveles[2], miJerarquia.arbol[0].children[0].children);
    expect(componentesDeClutch, [
      Etiqueta("componente", "discos"),
    ]);
  });
  test('recorrido', () {
    final miJerarquia = Jerarquia(niveles: [
      "sistema",
      "subsistema",
      "componente",
    ], arbol: [
      EtiquetaEnJerarquia("motor", [
        EtiquetaEnJerarquia("clutch", [
          EtiquetaEnJerarquia("discos"),
        ]),
        EtiquetaEnJerarquia("cilindro"),
      ]),
      EtiquetaEnJerarquia("chasis"),
    ]);

    void recorrerJerarquia(
        List<EtiquetaEnJerarquia> arbol, List<String> niveles, int nivel) {
      stdout.write("(");
      for (var etiqueta in arbol) {
        stdout.write("${niveles[nivel]}:${etiqueta.valor}->");
        recorrerJerarquia(etiqueta.children, niveles, nivel + 1);
        stdout.write(",");
      }
      stdout.write(")");
    }

    recorrerJerarquia(miJerarquia.arbol, miJerarquia.niveles, 0);
  });
}
