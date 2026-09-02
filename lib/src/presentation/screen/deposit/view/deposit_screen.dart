import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../widgets/payment_method_picker.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../widgets/deposit_custom_field.dart';

import '../controller/deposit_controller.dart';
import '../model/deposit_method_response.dart';

class DepositScreen extends GetView<DepositController> {
  const DepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          Get.offAllNamed(BaseRoute.dashboard);
        },
        child: SafeArea(
          child: Column(
            children: [
              CommonHeader(
                title: "deposit.title".trns(),
                backToDashboard: controller.backToHome.value,
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Form(
                  key: controller.formKey,
                  child: Obx(() {
                    if (controller.isLoadingMethods.value) {
                      return SpinLoader.loader();
                    }
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PaymentMethodPicker(ctrl: controller),

                            controller.hasPaymentMethodError.value
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      left: 8.w,
                                      top: 4.h,
                                    ),
                                    child: Text(
                                      'deposit.selectPaymentMethod'.trns(),
                                      style: TextStyle(
                                        letterSpacing: 0,
                                        color: AppColors.error,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),

                            SizedBox(height: 8.h),
                            Text(
                              controller.chargeText.value,
                              style: TextStyle(
                                letterSpacing: 0,
                                color: AppColors.error,
                                fontSize: 11.sp,
                              ),
                            ),

                            if (controller.chargeText.value.isNotEmpty)
                              SizedBox(height: 18.h),
                            if (controller.selectedMethod.value != null) ...[
                              _bankDetailsCard(
                                context,
                                controller.selectedMethod.value!,
                              ),
                              SizedBox(height: 18.h),
                            ],
                            AuthTextField(
                              label: "deposit.amountLabel".trns(),

                              hintText: 'deposit.amountHint'.trns(),

                              keyboardType: TextInputType.number,
                              controller: controller.amountController,
                              showImageIcon: true,
                              symbol: controller.currencySymbol.value,
                              validator: (v) {
                                final method = controller.selectedMethod.value;
                                if (v == null || v.trim().isEmpty) {
                                  return 'deposit.amountRequire'.trns();
                                }
                                final val = double.tryParse(v.trim());
                                if (val == null) {
                                  return 'deposit.enterValidNumber'.trns();
                                }
                                if (method != null) {
                                  final min = method.minimumDeposit;
                                  final max = method.maximumDeposit;
                                  if (min != null && val < min.toDouble()) {
                                    return '${'deposit.minimum'.trns()} ${method.minimumDeposit} ${method.currency}';
                                  }
                                  if (max != null && val > max.toDouble()) {
                                    return '${'deposit.maximum'.trns()} ${method.maximumDeposit} ${method.currency}';
                                  }
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 18.h),
                            if (controller.selectedMethod.value != null &&
                                (controller
                                            .selectedMethod
                                            .value
                                            ?.paymentDetails ??
                                        '')
                                    .isNotEmpty)
                              DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  radius: Radius.circular(4.w),
                                  color: AppColors.warning.withValues(
                                    alpha: .6,
                                  ),
                                  strokeWidth: 1.w,
                                  dashPattern: const [6, 6],
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: dark
                                        ? const Color(0xFF2B2518)
                                        : AppColors.htmlField,
                                    borderRadius: BorderRadius.circular(4.w),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,

                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: AppColors.warning,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: HtmlWidget(
                                          controller
                                                  .selectedMethod
                                                  .value!
                                                  .paymentDetails ??
                                              '',
                                          textStyle: TextStyle(
                                            letterSpacing: 0,
                                            fontSize: 12.sp,
                                            color: dark
                                                ? AppColors.darkTextPrimary
                                                : AppColors.lightTextPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(height: 18.h),
                            if (controller.selectedMethod.value != null &&
                                controller.selectedMethod.value!.fieldOptions!
                                    .any((field) => field.type != 'file'))
                              Column(
                                children: controller
                                    .selectedMethod
                                    .value!
                                    .fieldOptions!
                                    .where((field) => field.type != 'file')
                                    .map(
                                      (customField) => Column(
                                        children: [
                                          DepositCustomField(
                                            opt: customField,
                                            ctrl: controller,
                                          ),
                                          SizedBox(height: 16.h),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              ),

                            if (controller.selectedMethod.value != null &&
                                controller.selectedMethod.value!.fieldOptions!
                                    .any((field) => field.type == 'file')) ...[
                              _proofSection(context),
                              SizedBox(height: 16.h),
                            ],

                            SizedBox(height: 34.h),
                            AppButton(
                              text: 'deposit.submit'.trns(),
                              onPressed: controller.proceedToReview,
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bankDetailsCard(BuildContext context, DepositMethod method) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = dark ? AppColors.darkCard : AppColors.lightCard;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final title = dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: .12),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'Bank Account Details',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: title,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          _bankRow(context, 'Bank Name', method.bankName),
          _bankRow(context, 'Account Number', method.accountNumber),
          _bankRow(
            context,
            'Account Owner Name',
            method.accountName,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _bankRow(
    BuildContext context,
    String label,
    String? value, {
    bool isLast = false,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final title = dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final muted = dark
        ? AppColors.darkTextTertiary
        : AppColors.lightTextTertiary;
    final display = (value ?? '').trim();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: muted),
            ),
          ),
          Flexible(
            child: Text(
              display.isEmpty ? 'Not provided' : display,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: title,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _proofSection(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final card = dark ? AppColors.darkCard : AppColors.lightCard;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final title = dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final muted = dark
        ? AppColors.darkTextTertiary
        : AppColors.lightTextTertiary;
    final files = controller.selectedMethod.value!.fieldOptions!.where(
      (field) => field.type == 'file',
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Submit Proof of Payment',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: title,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Upload your transfer receipt for secure payment verification.',
            style: TextStyle(fontSize: 11.sp, color: muted),
          ),
          SizedBox(height: 14.h),
          ...files.map(
            (field) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: DepositCustomField(opt: field, ctrl: controller),
            ),
          ),
        ],
      ),
    );
  }
}
