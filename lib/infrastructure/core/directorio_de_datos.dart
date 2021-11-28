import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Este se inicializa en el main y se entrega al [ProviderScope]
final directorioDeDatosProvider = Provider<DirectorioDeDatos>(
    (ref) => throw Exception("no se ha inicializado el directorio de datos"));

class DirectorioDeDatos {
  final String path;
  const DirectorioDeDatos(this.path);
}
