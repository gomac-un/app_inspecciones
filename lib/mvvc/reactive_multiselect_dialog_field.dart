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
    void Function() onTap,
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
                    decoration: effectiveDecoration.copyWith(
                        errorText: field.errorText),
                    child: MultiSelectDialogField<V>(
                      buttonText: buttonText,
                      items: items,
                      initialValue: field.value as List<V>,
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        field.didChange(values);
                      },
                      chipDisplay: MultiSelectChipDisplay<V>(
                        items: items,
                        onTap: (dynamic value) {
                          final newlist = (field.value as List<V>)
                              .where((e) => e != value)
                              .toList();
                          field.didChange(newlist);
                          return newlist;
                        },
                      ),
                    ) //..state?.didChange(field.value as List<V>),
                    ),
              );
            });

  @override
  ReactiveFormFieldState<List<V>> createState() =>
      ReactiveFormFieldState<List<V>>();
}
