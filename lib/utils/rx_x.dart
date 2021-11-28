import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

extension RxCustomStreamExtensions<T> on Stream<T> {
  // to value stream with initial
  ValueConnectableStream<T> toVSwithInitial(T seedValue) =>
      publishValueSeeded(seedValue)..connect();
}

extension FormControlValueToStreamExtensions<T> on FormControl<T> {
  /// to value stream not nullable
  ValueConnectableStream<T> toValueStreamNN() =>
      valueChanges.map((r) => r!).toVSwithInitial(value!);

  ValueConnectableStream<T?> toValueStream() =>
      valueChanges.toVSwithInitial(value);
}
