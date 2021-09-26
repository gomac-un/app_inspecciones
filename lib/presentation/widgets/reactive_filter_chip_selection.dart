import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// seleccion multiple usando [FilterChip]s
///! ojo, el ModelDataType debe ser comparable por valor, sino no funciona esto
class ReactiveFilterChipSelection<ModelDataType, ViewDataType>
    extends ReactiveFormField<List<ModelDataType>, List<ViewDataType>> {
  final List<ViewDataType> posibleItems;
  final String Function(ViewDataType) labelAccesor;
  ReactiveFilterChipSelection({
    Key? key,
    String? formControlName,
    FormControl<List<ModelDataType>>? formControl,
    ValidationMessagesFunction<List<ModelDataType>>? validationMessages,
    ControlValueAccessor<List<ModelDataType>, List<ViewDataType>>?
        valueAccessor,
    ShowErrorsFunction? showErrors,
    InputDecoration? decoration,
    required this.posibleItems,
    required this.labelAccesor,
  }) : super(
            key: key,
            formControl: formControl,
            formControlName: formControlName,
            valueAccessor: valueAccessor,
            validationMessages: validationMessages,
            showErrors: showErrors,
            builder: (field) {
              final selectedItems = field.value;
              if (selectedItems == null) return const SizedBox.shrink();
              return InputDecorator(
                decoration: (decoration ?? const InputDecoration()).copyWith(
                  filled: false,
                  enabled: field.control.enabled,
                  border: InputBorder.none,
                ),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: posibleItems
                      .map(
                        (e) => FilterChip(
                          showCheckmark: false,
                          label: Text(labelAccesor(e)),
                          selected: selectedItems.contains(e),
                          onSelected: (selected) {
                            if (selected) {
                              field.didChange([...?field.value, e]);
                            } else {
                              field.didChange(
                                [...?field.value]..remove(e),
                              );
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
              );
            });
}
