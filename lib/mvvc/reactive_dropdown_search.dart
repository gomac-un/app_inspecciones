import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:reactive_forms/reactive_forms.dart';

//TODO arreglar la reactividad
class ReactiveDropdownSearch<V> extends ReactiveFormField<V> {
  final List<V> items;

  ReactiveDropdownSearch({
    String formControlName,
    FormControl formControl,
    ValidationMessagesFunction validationMessages,
    String Function(V) itemAsString,
    String label,
    String hint,
    this.items,
  }) : super(
            formControlName: formControlName,
            formControl: formControl,
            validationMessages: validationMessages,
            builder: (ReactiveFormFieldState<V> field) {
              return DropdownSearch<V>(
                key: ObjectKey(field
                    .value), //machetazo para que borre el estado interno en cada cambio de field.value
                mode: Mode.MENU,
                //showSelectedItem: true,
                items: items,
                label: label,
                hint: hint,
                onChanged: (value) {
                  field.didChange(value);
                },
                selectedItem: field.value as V,
                itemAsString: itemAsString,
              );
            });
}
