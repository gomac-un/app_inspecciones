import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:inspecciones/features/creacion_cuestionarios/creacion_form_controller.dart';
import 'package:inspecciones/injection.dart';

part 'creacion_form_controller_state.dart';
part 'creacion_form_controller_cubit.freezed.dart';

@injectable

/// Bloc encargado de instanciar de manera asincrona un [CreacionFormController]
/// con el [cuestionarioId] recibido e ir notificando del estado de este proceso
class CreacionFormControllerCubit extends Cubit<CreacionFormControllerState> {
  final int? cuestionarioId;
  late final CreacionFormController _controller;

  CreacionFormControllerCubit(@factoryParam this.cuestionarioId)
      : super(const CreacionFormControllerState.initial()) {
    _loadViewModel();
  }
  _loadViewModel() async {
    try {
      emit(const CreacionFormControllerState.inProgress());
      final _controller =
          await getIt.getAsync<CreacionFormController>(param1: cuestionarioId);

      emit(CreacionFormControllerState.success(_controller));
    } catch (e) {
      emit(CreacionFormControllerState.failure(e));
    }
  }

  @override
  Future<void> close() async {
    _controller.dispose();
    await super.close();
  }
}
