import 'package:flutter/material.dart';

class AyudaPosicion extends StatelessWidget {
  const AyudaPosicion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ayuda',
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 2,
                child: ClipRRect(
                  // Los bordes del contenido del card se cortan usando BorderRadius
                  borderRadius: BorderRadius.circular(15),

                  // EL widget hijo que será recortado segun la propiedad anterior
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/Posicion.jpeg",
                        width: media.size.width * 0.7,
                      ),
                      const Text('Guía para las posiciones'),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(15, 10, 25, 0),
                  title: const Text('Posición',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3),
                      Text(
                        'Indica al inspector en qué lugar se encuentra el componente que se está inspeccionando en esta pregunta.',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      const SizedBox(height: 5),
                      Text('- La posición Y indica el eje',
                          style: Theme.of(context).textTheme.bodyText1),
                      Text('- La posición X indica el lado',
                          style: Theme.of(context).textTheme.bodyText1),
                      Text(
                        '- La posición Z indica si está arriba, abajo o en el medio',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  leading: Icon(Icons.help,
                      color: Theme.of(context).colorScheme.secondary),
                  isThreeLine: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
