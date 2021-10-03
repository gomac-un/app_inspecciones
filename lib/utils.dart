import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'infrastructure/core/directorio_de_datos.dart';

Future<DirectorioDeDatos> getDirectorioDeDatos() async {
  final add = await getApplicationDocumentsDirectory();
  return DirectorioDeDatos(add.path);
}

class RemoveFocusOnTap extends StatelessWidget {
  final Widget child;
  const RemoveFocusOnTap({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // esto quita el foco (y esconde el teclado) al hacer tap
        // en cualquier lugar no-interactivo de la pantalla https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: child,
    );
  }
}

class ClearFocusOnPop extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      // solo quita el teclado pero deja el focus
      //SystemChannels.textInput.invokeMethod('TextInput.hide');
      // quita el focus despues de un pop
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }
}
