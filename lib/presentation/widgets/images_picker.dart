import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspecciones/presentation/widgets/imagen_full_screen.dart';
import 'package:reactive_forms/reactive_forms.dart';

//import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'image_source_sheet.dart';

class FormBuilderImagePicker extends StatelessWidget {
  /// Es el formArray pasado desde la creación o llenado de inspección
  final FormArray<File> formArray;

  final List<FormFieldValidator> validators;
  final List initialValue;
  final bool readOnly;
  @Deprecated('Set the `labelText` within decoration attribute')
  final String labelText;
  final InputDecoration decoration;
  final ValueChanged onChanged;
  final FormFieldSetter onSaved;

  final double imageWidth;
  final double imageHeight;
  final EdgeInsets imageMargin;
  final Color iconColor;

  /// Optional maximum height of image; see [ImagePicker].
  final double maxHeight;

  /// Optional maximum width of image; see [ImagePicker].
  final double maxWidth;

  /// The imageQuality argument modifies the quality of the image, ranging from
  /// 0-100 where 100 is the original/max quality. If imageQuality is null, the
  /// image with the original quality will be returned. See [ImagePicker].
  final int imageQuality;

  /// Use preferredCameraDevice to specify the camera to use when the source is
  /// `ImageSource.camera`. The preferredCameraDevice is ignored when source is
  /// `ImageSource.gallery`. It is also ignored if the chosen camera is not
  /// supported on the device. Defaults to `CameraDevice.rear`. See [ImagePicker].
  final CameraDevice preferredCameraDevice;

  final int maxImages;
  final ImageProvider defaultImage;
  final Widget cameraIcon;
  final Widget galleryIcon;
  final Widget cameraLabel;
  final Widget galleryLabel;
  final EdgeInsets bottomSheetPadding;

  const FormBuilderImagePicker({
    Key key,
    @required this.formArray,
    this.initialValue,
    this.defaultImage,
    this.validators = const [],
    this.labelText,
    this.onChanged,
    this.imageWidth = 130,
    this.imageHeight = 130,
    this.imageMargin,
    this.readOnly = false,
    this.onSaved,
    this.decoration = const InputDecoration(),
    this.iconColor,
    this.maxHeight = 1000,
    this.maxWidth = 1000,
    this.imageQuality = 90,
    this.preferredCameraDevice = CameraDevice.rear,
    this.maxImages,
    this.cameraIcon = const Icon(Icons.camera_enhance),
    this.galleryIcon = const Icon(Icons.image),
    this.cameraLabel = const Text('Camera'),
    this.galleryLabel = const Text('Gallery'),
    this.bottomSheetPadding = const EdgeInsets.all(0),
  }) : super(key: key);

  /// Muestra BottomSheet de selección de camara o galeria cuando se agrega foto a cuestionario o inspeccion
  void modal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ImageSourceBottomSheet(
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          imageQuality: imageQuality,
          preferredCameraDevice: preferredCameraDevice,
          cameraIcon: cameraIcon,
          galleryIcon: galleryIcon,
          cameraLabel: cameraLabel,
          galleryLabel: galleryLabel,
          onImageSelected: (image) async {
            //field.didChange([...field.value, image]);

            //onChanged?.call(field.value);

            formArray.add(FormControl(value: image));

            Navigator.of(context).pop();
          },
          onImage: (image) {
            //Para web
            //field.didChange([...field.value, image]);
            //onChanged?.call(field.value);

            //TODO: extender el inputfieldbloc para que reciba imagenes readasbytes

            /*imagenesFieldBlocs.addFieldBloc(
                InputFieldBloc(name: "foto", initialValue: image));*/
            Navigator.of(context).pop();
          },
          bottomSheetPadding: bottomSheetPadding,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //_readOnly = _formState?.readOnly == true || widget.readOnly;

    return ReactiveValueListenableBuilder(
      //key: _fieldKey,
      //enabled: !_readOnly,
      //initialValue: [],
      /*validator: (val) =>
          FormBuilderValidators.validateValidators(val, widget.validators),*/
      /*onSaved: (val) {
        /*var transformed;
        if (widget.valueTransformer != null) {
          transformed = widget.valueTransformer(val);
          _formState?.setAttributeValue(widget.attribute, transformed);
        } else {
          _formState?.setAttributeValue(widget.attribute, val);
        }
        widget.onSaved?.call(transformed ?? val);*/
      },*/
      formControl: formArray,
      builder: (context, control, child) {
        final theme = Theme.of(context);

        return InputDecorator(
          decoration: decoration.copyWith(
              filled: false,
              enabled: !readOnly,
              //errorText: field.errorText,
              // ignore: deprecated_member_use_from_same_package
              labelText: decoration.labelText ?? labelText,
              contentPadding: const EdgeInsets.all(8.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8),

                /// Cuando no se ha agregado ninguna foto
                if (formArray.controls.isEmpty)
                  GestureDetector(
                    onTap: () => modal(context),
                    child: Icon(Icons.camera_enhance,
                        color: iconColor ?? theme.accentColor),
                  )
                else
                  SizedBox(
                    height: imageHeight,
                    width: double.maxFinite,

                    /// Si ya hay fotos se muestra la lista
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        ...formArray.controls.map<Widget>((item) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              Container(
                                width: imageWidth,
                                height: imageHeight,
                                margin: imageMargin,
                                /*child: kIsWeb
                                ? Image.memory(item, fit: BoxFit.cover)
                                : item is String
                                    ? Image.network(item, fit: BoxFit.cover)
                                    : Image.file(item, fit: BoxFit.cover),*/
                                child: //TODO: arreglar cuando se implemente el web
                                    /*kIsWeb
                                      ? Image.memory(item, fit: BoxFit.cover)
                                      : item.value is String
                                          ? Image.network(item.value,
                                              fit: BoxFit.cover)
                                          :*/

                                    GestureDetector(
                                  onTap: () {
                                    /// Permite ver la foto [item] en pantalla completa
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return FotoFullScreen(
                                          item.value, item.value.hashCode);
                                    }));
                                  },
                                  child: Hero(
                                    tag: item.value.hashCode,
                                    child: Image.file(item.value,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              if (!readOnly)
                                InkWell(
                                  onTap: () {
                                    item.value.deleteSync();
                                    formArray.remove(item);
                                    /*field.didChange(
                                        [...field.value]..remove(item));
                                    onChanged?.call(field.value);*/
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.7),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    height: 22,
                                    width: 22,
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }).toList(),
                        if (!readOnly /*&& !_hasMaxImages*/)
                          GestureDetector(
                            onTap: () => modal(context),
                            child: defaultImage != null
                                ? Image(
                                    width: imageWidth,
                                    height: imageHeight,
                                    image: defaultImage,
                                  )
                                : Container(
                                    width: imageWidth,
                                    height: imageHeight,
                                    color: (readOnly
                                            ? theme.disabledColor
                                            : iconColor ?? theme.primaryColor)
                                        .withAlpha(50),
                                    child: Icon(Icons.camera_enhance,
                                        color: readOnly
                                            ? theme.disabledColor
                                            : iconColor ?? theme.primaryColor),
                                  ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
