import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:state_notifier/state_notifier.dart';

/// Hook provides this object with both the notifier and state as properties
class StateNotifierState<State, Notifier extends StateNotifier<State>> {
  final Notifier notifier;
  final State state;

  StateNotifierState(this.notifier, this.state);
}

/// Manages a [StateNotifier] automatically disposed.
///
/// Change [keys] to reinitialize.
///
/// See also:
///   * [StateNotifier], the managed object.
StateNotifierState<State, Notifier> useStateNotifier<State, Notifier extends StateNotifier<State>>(
        Notifier Function() stateNotifierBuilder,
        {List<Object>? keys}) =>
    use(_StateNotifierHook<State, Notifier>(stateNotifierBuilder, keys: keys));

/// Hook object for a StateNotifier
class _StateNotifierHook<State, Notifier extends StateNotifier<State>>
    extends Hook<StateNotifierState<State, Notifier>> {
  final Notifier Function() stateNotifierBuilder;

  const _StateNotifierHook(this.stateNotifierBuilder, {List<Object>? keys}) : super(keys: keys);

  @override
  _StateNotifierHookState<State, Notifier> createState() => _StateNotifierHookState<State, Notifier>();
}

/// Hook object state that is provided as the current state
// Don't implement "didUpdateHook", key changes will init a new state and dispose the old state
class _StateNotifierHookState<State, Notifier extends StateNotifier<State>>
    extends HookState<StateNotifierState<State, Notifier>, _StateNotifierHook<State, Notifier>> {
  late final Notifier _notifier;
  late final Function() _stopListening;

  late StateNotifierState<State, Notifier> _stateNotifierState;

  @override
  void initHook() {
    super.initHook();
    _notifier = hook.stateNotifierBuilder();
    _stopListening = _notifier.addListener((State s) {
      setState(() => _stateNotifierState = StateNotifierState(_notifier, s));
    });
  }

  @override
  StateNotifierState<State, Notifier> build(BuildContext context) => _stateNotifierState;

  @override
  void dispose() {
    _stopListening();
  }

  @override
  String get debugLabel => 'useStateNotifier<$State,$Notifier>';
}