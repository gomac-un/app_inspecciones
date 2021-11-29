import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rxdart/rxdart.dart';

T useValueStream<T>(ValueStream<T> subject) =>
    useStream(subject /*, initialData: subject.value*/).data ?? subject.value;

T? useControlValue<T>(AbstractControl<T> control) =>
    useStream(control.valueChanges, initialData: control.value).requireData;

bool useControlValid(AbstractControl control) =>
    useStream(control.statusChanged.map((_) => control.valid),
            initialData: control.valid)
        .requireData;
