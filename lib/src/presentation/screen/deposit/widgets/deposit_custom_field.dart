import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../common/widgets/file_picker/document_picker.dart';
import '../model/deposit_method_response.dart';
import '../../../../utils/validators/form_validation.dart';
import '../controller/deposit_controller.dart';

class DepositCustomField extends StatelessWidget {
  final FieldOption opt;
  final DepositController ctrl;

  const DepositCustomField({super.key, required this.opt, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isRequired = opt.validation == 'required';
    final name = opt.name;
    final type = opt.type;
    final fieldController =
        ctrl.dynamicTextControllers[opt.name] ?? TextEditingController();

    if (type == 'text') {
      return AuthTextField(
        label: name ?? '',
        hintText: '${'deposit.depositCustom.nameHint'.trns()} $name',
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
        label: name ?? '',
        hintText: '${'deposit.depositCustom.textAreaHint'.trns()} $name',
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
        final pickedFile = ctrl.dynamicPickedFiles[name];
        final errorText = ctrl.dynamicFileErrors[name];
        return FilePickerField(
          label: name ?? '',
          isRequired: isRequired,
          onFilePicked: () => ctrl.pickFile(name!),
          selectedFile: pickedFile,
          errorText: errorText,
        );
      });
    }
    return const SizedBox.shrink();
  }
}
