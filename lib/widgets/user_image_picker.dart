import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:zeeyou/l10n/app_localizations.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({
    super.key,
    required this.onPickImage,
  });

  final void Function(File? pickedImage) onPickImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage(ImageSource source, FormFieldState formState) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 300,
    );

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    formState.didChange(_pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FormField<File>(
      onSaved: (value) => widget.onPickImage(value),
      validator: (value) {
        if (value == null && !Platform.isIOS) {
          return l10n.pleasePickAnImage;
        }
        return null;
      },
      builder: (formState) {
        BorderSide border = BorderSide.none;
        Color iconColor = Theme.of(context).colorScheme.primary;
        if (formState.hasError) {
          border = BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          );
          iconColor = Theme.of(context).colorScheme.error;
        }
        return Column(
          children: [
            _pickedImageFile != null
                ? CircleAvatar(
                    radius: 40,
                    foregroundImage: FileImage(_pickedImageFile!),
                  )
                : IconButton.filledTonal(
                    onPressed: () => _pickImage(ImageSource.camera, formState),
                    icon: Icon(Icons.camera_alt_outlined, color: iconColor),
                    iconSize: 40,
                    padding: const EdgeInsets.all(15),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            CircleBorder(side: border))),
                  ),
            TextButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery, formState),
              icon: const Icon(Icons.image),
              label: Text(l10n.addImage),
              style: TextButton.styleFrom(foregroundColor: iconColor),
            ),
          ],
        );
      },
    );
  }
}
