import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveMultiSelectDialogField<V> extends ReactiveFormField<List<V>> {
  final List<MultiSelectItem<V>> items;
  final Text buttonText;

  ReactiveMultiSelectDialogField({
    String formControlName,
    FormControl formControl,
    ValidationMessagesFunction validationMessages,
    @required this.items,
    this.buttonText,
    Function onTap,
  }) : super(
            formControlName: formControlName,
            formControl: formControl,
            validationMessages: validationMessages,
            builder: (ReactiveFormFieldState<List<V>> field) {
              final InputDecoration effectiveDecoration = const InputDecoration(
                      filled: false, border: InputBorder.none)
                  .applyDefaults(Theme.of(field.context).inputDecorationTheme);
              return GestureDetector(
                behavior:
                    HitTestBehavior.translucent, //TODO hacer funcionar el onTap
                onTap: onTap,
                child: InputDecorator(
                  decoration:
                      effectiveDecoration.copyWith(errorText: field.errorText),
                  child: MultiSelectDialogField<V>(
                    height: 30,
                    buttonText: buttonText,
                    items: items,
                    initialValue: field.value,
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) {
                      field.didChange(values);
                    },
                    chipDisplay: MultiSelectChipDisplay<V>(
                      items: items,
                      //TODO: https://github.com/joanpablo/reactive_forms/issues/64
                      // por ahora solo hay ediciones de una via
                      /*onTap: (dynamic value) {
                        
                        return field.didChange(
                          // The rebuild does not reflect this new value 😢
                          (field.value as List<V>)
                              .where((e) => e != value)
                              .toList(),
                        );
                      },*/
                    ),
                  ),
                ),
              );
            });

  @override
  ReactiveFormFieldState<List<V>> createState() =>
      ReactiveFormFieldState<List<V>>();
}
