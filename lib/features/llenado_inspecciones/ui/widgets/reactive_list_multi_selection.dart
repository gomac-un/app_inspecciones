import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

/// ReactiveWidget para un control tipo lista al cual se le pueden agregar y
/// eliminar elementos, no se esta usando en la pregunta de seleccion multiple
/// ya que se requiere que cada opcion tenga su propio control.
///! ojo, el ModelDataType debe ser comparable por valor, sino no funciona esto
class ReactiveMultiListSelection<ModelDataType, ViewDataType>
    extends ReactiveFormField<List<ModelDataType>, List<ViewDataType>> {
  final List<ViewDataType> posibleItems;
  final String Function(ViewDataType) labelAccesor;
  ReactiveMultiListSelection({
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
                child: Column(
                  children: posibleItems
                      .map(
                        (e) => CheckboxListTile(
                            title: Text(labelAccesor(e)),
                            value: selectedItems.contains(e),
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (selected) {
                              if (selected == null) {
                                throw Exception("el checkbox es null");
                              }

                              if (selected) {
                                field.didChange([...?field.value, e]);
                              } else {
                                field.didChange(
                                  [...?field.value]..remove(e),
                                );
                              }
                            }),
                      )
                      .toList(),
                ),
              );
            });
}
