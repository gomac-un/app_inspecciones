import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'transition.dart';

abstract class Bloc<Event, State> {
  final PublishSubject<Event> _eventSubject = PublishSubject<Event>();
  BehaviorSubject<State> _stateSubject;

  State get initialState;

  State get currentState => _stateSubject.value;

  Stream<State> get state => _stateSubject.stream;

  Block() {
    _stateSubject = BehaviorSubject<State>.seeded(initialState);
    _bindStateSubject();
  }

  @mustCallSuper
  void dispose() {
    _eventSubject.close();
    _stateSubject.close();
  }

  void onTransition(Transition<Event, State> transition) => null;

  void onError(Object error, StackTrace stackTrace) => null;

  void onEvent(Event event) => null;

  void dispatch(Event event) {
    try {
      onEvent(event);
      _eventSubject.sink.add(event);
    } catch (error) {
      _handleError(error);
    }
  }

  Stream<State> transform(
    Stream<Event> events,
    Stream<State> next(Event event),
  ) {
    return events.asyncExpand(next);
  }

  Stream<State> mapEventToState(Event event);

  void _bindStateSubject() {
    Event currentEvent;

    transform(
      _eventSubject,
      (Event event) {
        currentEvent = event;
        return mapEventToState(currentEvent).handleError(_handleError);
      },
    ).forEach(
      (State nextState) {
        if (currentState == nextState || _stateSubject.isClosed) return;
        final transition = Transition(
          currentState: currentState,
          event: currentEvent,
          nextState: nextState,
        );
        _stateSubject.sink.add(nextState);
      },
    );
  }

  void _handleError(Object error, [StackTrace stacktrace]) {
    onError(error, stacktrace);
  }
}
