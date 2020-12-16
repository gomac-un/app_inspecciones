import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:inspecciones/presentation/widgets/imagen_full_screen.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'image_source_sheet.dart';
import 'package:image_picker/image_picker.dart';

class FormBuilderImagePicker extends StatelessWidget {
  final ListFieldBloc<InputFieldBloc<File, Object>> imagenesFieldBlocs;

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

  FormBuilderImagePicker({
    Key key,
    @required this.imagenesFieldBlocs,
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
    this.maxHeight = 500,
    this.maxWidth = 500,
    this.imageQuality = 70,
    this.preferredCameraDevice = CameraDevice.rear,
    this.maxImages,
    this.cameraIcon = const Icon(Icons.camera_enhance),
    this.galleryIcon = const Icon(Icons.image),
    this.cameraLabel = const Text('Camera'),
    this.galleryLabel = const Text('Gallery'),
    this.bottomSheetPadding = const EdgeInsets.all(0),
  }) : super(key: key);

  bool get _hasMaxImages {
    if (maxImages == null) {
      return false;
    } else {
      //TODO
      /*return /*_fieldKey.currentState.value != null &&*/ _fieldKey
              .currentState.value.length >=
          widget.maxImages;*/
    }
  }

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

            imagenesFieldBlocs.addFieldBloc(InputFieldBloc(
              name: "foto",
              initialValue: image,
              toJson: (file) => file.path,
            ));
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

    return BlocBuilder<ListFieldBloc<InputFieldBloc<File, Object>>,
        ListFieldBlocState<InputFieldBloc<File, Object>>>(
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
      cubit: imagenesFieldBlocs,
      builder: (context, state) {
        var theme = Theme.of(context);

        return InputDecorator(
          decoration: decoration.copyWith(
              enabled: !readOnly,
              //errorText: field.errorText,
              // ignore: deprecated_member_use_from_same_package
              labelText: decoration.labelText ?? labelText,
              contentPadding: EdgeInsets.all(8.0)),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 8),
                state.fieldBlocs.length == 0
                    ? GestureDetector(
                        child: Icon(Icons.camera_enhance,
                            color: iconColor ?? theme.accentColor),
                        onTap: () => modal(context),
                      )
                    : Container(
                        height: imageHeight,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...(state.fieldBlocs.map<Widget>((item) {
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
                                        item.value is File
                                            ? GestureDetector(
                                                child: Hero(
                                                  tag: item.value.hashCode,
                                                  child: Image.file(item.value,
                                                      fit: BoxFit.cover),
                                                ),
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (_) {
                                                    return FotoFullScreen(
                                                        item.value,
                                                        item.value.hashCode);
                                                  }));
                                                },
                                              )
                                            : item.value,
                                  ),
                                  if (!readOnly)
                                    InkWell(
                                      onTap: () {
                                        item.state.value.deleteSync();
                                        imagenesFieldBlocs
                                            .removeFieldBlocsWhere(
                                                (e) => e == item);
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
                            }).toList()),
                            if (!readOnly && !_hasMaxImages)
                              GestureDetector(
                                  child: defaultImage != null
                                      ? Image(
                                          width: imageWidth,
                                          height: imageHeight,
                                          image: defaultImage,
                                        )
                                      : Container(
                                          width: imageWidth,
                                          height: imageHeight,
                                          child: Icon(Icons.camera_enhance,
                                              color: readOnly
                                                  ? theme.disabledColor
                                                  : iconColor ??
                                                      theme.primaryColor),
                                          color: (readOnly
                                                  ? theme.disabledColor
                                                  : iconColor ??
                                                      theme.primaryColor)
                                              .withAlpha(50),
                                        ),
                                  onTap: () => modal(context)),
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
