import 'package:bloc/bloc.dart';

enum CounterEvent { increment, decrement, reset }

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0);

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    if (event == CounterEvent.increment) {
      yield state + 1;
    } else if (event == CounterEvent.decrement) {
      yield state - 1;
    } else if (event == CounterEvent.reset) {
      yield 0;
    }
  }

  @override
  void onEvent(CounterEvent event) {
    print('bloc: ${this.runtimeType}, event: $event');
    super.onEvent(event);
  }
}
