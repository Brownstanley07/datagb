import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/file_picker/document_picker.dart';
import '../controller/kyc_controller.dart';
import '../model/kyc_response_model.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/validators/form_validation.dart';

import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';

class KycVerificationScreen extends GetView<KycController> {
  const KycVerificationScreen({
    super.key,
    required this.kyc,
    required this.controller,
  });

  final Kyc kyc;
  @override
  final KycController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonHeader(
                title:
                    kyc.name?.capitalizeFirst ??
                    'kycVerification.kycVerification'.trns(),
              ),
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._buildDynamicFields(),
                      SizedBox(height: 20.h),
                      Obx(
                        () => AppButton(
                          text: 'kycVerification.submit'.trns(),
                          isLoading: controller.isSubmitting.value,
                          onPressed: controller.submitKyc,
                        ),
                      ),
                      SizedBox(height: 20.h),
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
    final method = controller.selectedKyc.value;
    if (method?.fields == null) return [];

    return method!.fields!.map((field) {
      final isRequired = field.validation == 'required';
      final name = field.name ?? 'common.unnamedField'.trns();
      Widget fieldWidget;
      if (field.type == 'text' || field.type == 'textarea') {
        fieldWidget = AuthTextField(
          label: name.capitalizeFirst.toString(),
          hintText: '${'kycVerification.enter'.trns()} $name',
          controller: controller.getTextController(name),
          showIcon: false,
          isRequired: isRequired,
          maxLines: field.type == 'textarea' ? 3 : 1,
          validator: (v) =>
              isRequired ? FormValidation.validateCustomField(v, name) : null,
        );
      } else if (field.type == 'file') {
        fieldWidget = Obx(() {
          final errorText = controller.dynamicFileErrors[name];
          return FilePickerField(
            label: name.capitalizeFirst.toString(),
            isRequired: isRequired,
            errorText: errorText,
            onFilePicked: () => controller.pickFile(name),
            selectedFile: controller.pickedFiles[name],
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
