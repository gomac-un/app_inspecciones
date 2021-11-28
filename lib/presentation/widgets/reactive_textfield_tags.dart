import 'package:flutter/material.dart';
import 'package:inspecciones/features/configuracion_organizacion/domain/entities.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'textfield_tags.dart';

class ReactiveTextFieldTags
    extends ReactiveFormField<Set<Etiqueta>, Set<Etiqueta>> {
  ReactiveTextFieldTags({
    Key? key,
    InputDecoration decoration = const InputDecoration(),
    required FormControl<Set<Etiqueta>> formControl,
    ValidationMessagesFunction<Set<Etiqueta>>? validationMessages,
    required AutocompleteOptionsBuilder<Etiqueta> optionsBuilder,
    VoidCallback? onMenu,
  }) : super(
          key: key,
          formControl: formControl,
          validationMessages: validationMessages,
          builder: (field) {
            return InputDecorator(
              decoration: decoration.copyWith(
                errorText: field.errorText,
                enabled: field.control.enabled,
                border: const OutlineInputBorder(),
                filled: false,
                contentPadding: const EdgeInsets.all(8.0),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.label_outlined), onPressed: onMenu),
              ),
              child: TextFieldTags<Etiqueta>(
                enabled: field.control.enabled,
                tags: field.value!,
                onTag: (tag) =>
                    field.didChange(Set.from(field.value!..add(tag))),
                onDelete: (tag) =>
                    field.didChange(Set.from(field.value!..remove(tag))),
                optionsBuilder: optionsBuilder,
                
              ),
            );
          },
        );
}
