import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/string_extension.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../common/widgets/file_picker/document_picker.dart';
import '../controller/add_new_withdraw_account_controller.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../../../../utils/validators/form_validation.dart';

class AddNewWithdrawAccountScreen
    extends GetView<AddNewWithdrawAccountController> {
  const AddNewWithdrawAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: "withdraw.addNewAccount".trns()),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SpinLoader.loader();
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshMethods();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(18.0.w),
                      child: Form(
                        key: controller.formKey,
                        child: Obx(
                          () => Column(
                            children: [
                              _buildAccountPicker(),
                              SizedBox(height: 16.h),
                              GetBuilder<AddNewWithdrawAccountController>(
                                builder: (_) =>
                                    controller.selectedAccount.value == null
                                    ? const SizedBox.shrink()
                                    : Column(
                                        children: [
                                          AuthTextField(
                                            label: "withdraw.methodName".trns(),
                                            hintText: "withdraw.enterMethodName"
                                                .trns(),
                                            controller:
                                                controller.methodNameController,
                                            showIcon: false,
                                            isRequired: true,
                                            validator: (value) =>
                                                FormValidation.validateCustomField(
                                                  value,
                                                  "withdraw.methodName".trns(),
                                                ),
                                          ),
                                          SizedBox(height: 16.h),
                                          ..._buildDynamicFields(),
                                        ],
                                      ),
                              ),
                              SizedBox(height: 30.h),
                              AppButton(
                                text: "withdraw.addNewWithdrawAccount".trns(),
                                isLoading: controller.isSubmitting.value,
                                onPressed: controller.addNewAccount,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "withdraw.choiceMethod".trns(),
            style: const TextStyle(
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
            ),
            children: const [
              TextSpan(
                text: "*",
                style: TextStyle(letterSpacing: 0, color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: () => _showMethodBottomSheet(),
          child: Obx(() {
            return Container(
              padding: EdgeInsets.only(left: 16.r, right: 10.r),
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.textfieldColor,
                borderRadius: BorderRadius.circular(20.w),
                border: Border.all(
                  color: controller.hasAccountError.value
                      ? AppColors.error
                      : AppColors.transparent,
                  width: controller.hasAccountError.value ? 1.w : 0.w,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.selectedAccount.value?.name ??
                          'withdraw.chooseMethod'.trns(),
                      style: TextStyle(
                        letterSpacing: 0,
                        fontSize: 14.sp,
                        fontWeight: controller.selectedAccount.value == null
                            ? FontWeight.w500
                            : FontWeight.w600,
                        color: controller.selectedAccount.value == null
                            ? AppColors.grey
                            : AppColors.textPrimary.withAlpha(190),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.grey.withAlpha(45),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.primary.withAlpha(200),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        Obx(
          () => controller.hasAccountError.value
              ? Padding(
                  padding: EdgeInsets.only(left: 8.w, top: 4.h),
                  child: Text(
                    'withdraw.pleaseSelectMethod'.trns(),
                    style: TextStyle(
                      letterSpacing: 0,
                      color: AppColors.error,
                      fontSize: 10.sp,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _showMethodBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 34.w,
                  height: 5.h,
                  margin: const EdgeInsets.all(10).w,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withAlpha(100),
                    borderRadius: BorderRadius.circular(10).w,
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              Text(
                'withdraw.selectPaymentMethod'.trns(),
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h, bottom: 10.h),
                child: Divider(
                  color: AppColors.grey.withAlpha(50),
                  height: 0.h,
                ),
              ),
              if (controller.accountList.isEmpty)
                Center(child: Text('withdraw.noAccountAvailable'.trns())),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: controller.accountList.map((account) {
                    return ListTile(
                      tileColor: account == controller.selectedAccount.value
                          ? AppColors.grey.withAlpha(40)
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10).w,
                      ),
                      title: Text(
                        account.name ?? '',
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: account == controller.selectedAccount.value
                              ? AppColors.textPrimary
                              : AppColors.muted,
                        ),
                      ),
                      onTap: () {
                        controller.selectMethod(account);
                        Get.back();
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildDynamicFields() {
    final method = controller.selectedAccount.value;
    if (method?.fields == null) return [];

    return method!.fields!.map((field) {
      final isRequired = field.validation == 'required';
      final name = field.name ?? 'common.unnamedField'.trns();
      Widget fieldWidget;
      if (field.type == 'text' || field.type == 'textarea') {
        fieldWidget = AuthTextField(
          label: name.toReadableText(),
          hintText: '${'common.enter'.trns()} $name',
          controller:
              controller.dynamicTextControllers[name] ??
              TextEditingController(),
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
            label: name.toReadableText(),
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
