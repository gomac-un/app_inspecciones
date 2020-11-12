import 'package:meta/meta.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class BloqueFieldBloc extends GroupFieldBloc {
  final TextFieldBloc titulo;
  final TextFieldBloc descripcion;

  BloqueFieldBloc({
    @required this.titulo,
    this.descripcion,
    String name,
    List<FieldBloc> fieldBlocs,
  }) : super([titulo, descripcion, ...?fieldBlocs], name: name);
}
