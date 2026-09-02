import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/model/registration_field.dart'
    as custom_field_model;
import '../../../../../common/widgets/extension/string_extension.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';

import '../../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../../common/widgets/camera_picker/pick_image.dart';
import '../../../../../common/widgets/file_picker/document_picker.dart';
import '../../../../../utils/validators/form_validation.dart';
import '../controller/signup_controller.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    super.key,
    required this.customField,
    required this.controller,
  });

  final custom_field_model.ValueElement customField;
  final SignupController controller;

  @override
  Widget build(BuildContext context) {
    final name = customField.name;
    final type = customField.type;
    final isRequired = customField.validation == 'required';
    final fieldController =
        controller.customFieldControllers[customField.name]!;

    if (type == 'text') {
      return AuthTextField(
        label: name?.toReadableText() ?? '',
        hintText: '${'deposit.depositCustom.textAreaHint'.trns()} $name',
        controller: fieldController,
        showIcon: false,
        isRequired: isRequired,
        validator: (value) {
          if (isRequired) {
            return FormValidation.validateCustomField(value, name ?? '');
          }
          return null;
        },
      );
    } else if (type == 'textarea') {
      return AuthTextField(
        label: name?.toReadableText() ?? '',
        hintText: '${'deposit.depositCustom.textAreaHint'.trns()}  $name',
        controller: fieldController,
        showIcon: false,
        isRequired: isRequired,
        maxLines: 3,
        validator: (value) {
          if (isRequired) {
            return FormValidation.validateCustomField(value, name ?? '');
          }
          return null;
        },
      );
    } else if (type == 'file') {
      return Obx(() {
        final pickedFile = controller.pickedFiles[name];
        final errorText = controller.dynamicFileErrors[name];
        return FilePickerField(
          label: name?.toReadableText() ?? '',
          isRequired: isRequired,
          onFilePicked: () => controller.pickFile(name!),
          selectedFile: pickedFile,
          errorText: errorText,
        );
      });
    } else if (type == 'camera') {
      return Obx(() {
        final pickedFile = controller.pickedFiles[name];
        return ImagePickerField(
          label: name ?? '',
          isRequired: isRequired,
          onTapCamera: () => controller.pickImage(name!),
          selectedImage: pickedFile,
          errorText: controller.dynamicImageErrors[name],
        );
      });
    }
    return const SizedBox.shrink();
  }
}
