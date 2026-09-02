import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../common/widgets/file_picker/document_picker.dart';
import '../controller/edit_withdraw_account_controller.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/validators/form_validation.dart';

class EditWithdrawAccount extends GetView<EditWithdrawAccountController> {
  const EditWithdrawAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonHeader(title: 'withdraw.editWithdrawAccount'.trns()),
              Padding(
                padding: .all(18.0.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        label: 'withdraw.methodName'.trns(),
                        hintText: 'withdraw.enterMethodName'.trns(),
                        controller: controller.methodNameController,
                        showIcon: false,
                        isRequired: true,
                        validator: (value) =>
                            FormValidation.validateCustomField(
                              value,
                              'withdraw.methodName'.trns(),
                            ),
                      ),
                      SizedBox(height: 16.h),
                      ..._buildDynamicFields(),
                      SizedBox(height: 40.h),
                      Obx(
                        () => AppButton(
                          text: 'withdraw.updateAccount'.trns(),
                          isLoading: controller.isSubmitting.value,
                          onPressed: controller.updateAccount,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDynamicFields() {
    if (controller.account.fields == null) {
      return [];
    }
    return controller.account.fields!.map((field) {
      final isRequired = field.validation == 'required';
      final name = field.name ?? 'common.unnamedField'.trns();

      Widget fieldWidget;

      if (field.type == 'text' || field.type == 'textarea') {
        final textController = controller.dynamicTextControllers[name]!;
        fieldWidget = AuthTextField(
          label: name,
          hintText: '${'deposit.depositCustom.nameHint'.trns()} $name',
          controller: textController,
          showIcon: false,
          isRequired: isRequired,
          maxLines: field.type == 'textarea' ? 3 : 1,
          validator: (value) {
            if (isRequired) {
              return FormValidation.validateCustomField(value, name);
            }
            return null;
          },
        );
      } else if (field.type == 'file') {
        fieldWidget = Obx(() {
          final pickedFile = controller.pickedFiles[name];
          final existingFileUrl = controller.existingFiles[name];

          File? displayFile;
          if (pickedFile != null) {
            displayFile = pickedFile;
          }

          return FilePickerField(
            label: name,
            isRequired: isRequired,
            onFilePicked: () => controller.pickFile(name),
            selectedFile: displayFile,
            existingFileUrl: existingFileUrl,
          );
        });
      } else {
        fieldWidget = const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: fieldWidget,
      );
    }).toList();
  }
}
