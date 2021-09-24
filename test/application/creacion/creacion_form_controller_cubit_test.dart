import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';
import 'package:inspecciones/application/creacion/creacion_form_controller_cubit.dart';

void main() {
  /*late CreacionFormControllerCubit cubit;

  setUp(() {
    cubit = CreacionFormControllerCubit(1);
  });

  test('el estado incial debería ser initial', () {
    expect(cubit.state, const CreacionFormControllerState.initial());
  });
  */
  blocTest<CreacionFormControllerCubit, CreacionFormControllerState>(
    'emits [1] when CounterEvent.increment is added',
    build: () => CreacionFormControllerCubit(1),
    //act: (cubit) => cubit.add(CounterEvent.increment),
    expect: () => [const CreacionFormControllerState.inProgress()],
  );
}
