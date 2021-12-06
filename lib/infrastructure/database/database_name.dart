import 'package:diacritic/diacritic.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:inspecciones/application/auth/auth_service.dart';

final databaseNameProvider = Provider((ref) {
  final nombreOrganizacion = ref.watch(authProvider).maybeWhen(
      authenticated: (a) =>
          a.map(online: (u) => u.organizacion, offline: (u) => u.organizacion),
      orElse: () => throw Error());
  final nombreNormalizado =
      removeDiacritics(nombreOrganizacion.replaceAll(" ", "_"));
  return '${nombreNormalizado}_db.sqlite';
});
