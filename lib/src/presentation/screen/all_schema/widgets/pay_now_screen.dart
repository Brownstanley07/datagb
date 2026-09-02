import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../common/widgets/file_picker/document_picker.dart';
import '../controller/pay_now_controller.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../../../../utils/validators/form_validation.dart';

class PayNowScreen extends GetView<PayNowController> {
  const PayNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: "allSchema.payNow".trns()),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SpinLoader.loader();
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(18.w),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- CHOOSE WALLET ---
                          AuthTextField(
                            label: "allSchema.payNowPage.chooseWallet".trns(),
                            hintText: "allSchema.payNowPage.chooseWallet"
                                .trns(),
                            controller: controller.walletController,
                            icon: Icons.keyboard_arrow_down,
                            readOnly: true,
                            onTap: () => _showMethodBottomSheet(),
                            validator: (value) =>
                                FormValidation.validateCustomField(
                                  value,
                                  'common.wallet'.trns(),
                                ),
                          ),
                          SizedBox(height: 20.h),

                          // --- PAYMENT METHOD (CONDITIONAL) ---
                          if (controller.selectedWallet.value == 'gateway') ...[
                            AuthTextField(
                              label: "allSchema.payNowPage.paymentMethod"
                                  .trns(),
                              hintText: 'allSchema.payNowPage.chooseMethod'
                                  .trns(),
                              controller: controller.gatewayController,
                              icon: Icons.keyboard_arrow_down,
                              readOnly: true,
                              onTap: () => _showPaymentMethodBottomSheet(),
                              validator: (value) =>
                                  FormValidation.validateCustomField(
                                    value,
                                    'allSchema.payNowPage.paymentMethod'.trns(),
                                  ),
                            ),
                            SizedBox(height: 16.h),
                            ..._buildDynamicFields(),
                          ],

                          // --- ENTER AMOUNT ---
                          AuthTextField(
                            label: 'allSchema.payNowPage.enterAmount'.trns(),
                            hintText: controller.investmentAmountText,
                            controller: controller.amountController,
                            keyboardType: TextInputType.number,
                            showImageIcon: true,
                            symbol: controller
                                .settingsController
                                .currencySymbol
                                .value,
                            readOnly: controller.isFixedInvestment,
                            validator: (v) {
                              final method = controller.selectedSchema;
                              if (v == null || v.trim().isEmpty) {
                                return 'allSchema.payNowPage.amountRequired'
                                    .trns();
                              }
                              final val = double.tryParse(v.trim());
                              if (val == null) {
                                return 'allSchema.payNowPage.enterValidNumber'
                                    .trns();
                              }
                              if (method.amountRange == "range") {
                                final min = method.minAmount;
                                final max = method.maxAmount;
                                if (min != null && val < min.toDouble()) {
                                  return '${'allSchema.payNowPage.minimum'.trns()} $min';
                                }
                                if (max != null && val > max.toDouble()) {
                                  return '${'allSchema.payNowPage.maximum'.trns()} $max';
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30.h),

                          // --- REVIEW DETAILS ---
                          _buildReviewDetails(),

                          SizedBox(height: 30.h),
                          AppButton(
                            text: 'allSchema.payNowPage.reviewAndPay'.trns(),
                            onPressed: controller.onReviewNow,
                          ),
                        ],
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

  // Renders the summary of charges and totals
  Widget _buildReviewDetails() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            _buildReviewRow(
              'allSchema.payNowPage.investmentAmount'.trns(),
              "${controller.investmentAmount.value.toStringAsFixed(2)} ${controller.settingsController.sideCurrency.value}",
            ),
            SizedBox(height: 10.h),
            _buildReviewRow(
              'allSchema.payNowPage.charge'.trns(),
              '+ ${controller.charge.value.toStringAsFixed(2)} ${controller.settingsController.sideCurrency.value}',
            ),
            Divider(color: AppColors.border),
            SizedBox(height: 5.h),
            _buildReviewRow(
              'allSchema.payNowPage.totalPayable'.trns(),
              '${controller.totalPayable.value.toStringAsFixed(2)} ${controller.settingsController.sideCurrency.value}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            letterSpacing: 0,
            fontSize: 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            letterSpacing: 0,
            fontSize: 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showMethodBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(color: AppColors.border),
          ),
          child: SafeArea(
            top: false,
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
                      color: AppColors.muted.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(10).w,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'allSchema.payNowPage.selectWallet'.trns(),
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 10.h),
                  child: Divider(
                    color: AppColors.border,
                    height: 0.h,
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: controller.walletOptions.map((wallet) {
                      final isSelected = wallet == controller.selectedWallet.value;
                      return ListTile(
                        tileColor: isSelected
                            ? AppColors.primary.withValues(alpha: .12)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10).w,
                        ),
                        title: Text(
                          controller.getWalletDisplayName(wallet),
                          style: TextStyle(
                            letterSpacing: 0,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                        onTap: () {
                          controller.selectWallet(wallet);
                          Get.back();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPaymentMethodBottomSheet() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(color: AppColors.border),
          ),
          child: SafeArea(
            top: false,
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
                      color: AppColors.muted.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(10).w,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'allSchema.payNowPage.selectPaymentMethod'.trns(),
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.h, bottom: 10.h),
                  child: Divider(
                    color: AppColors.border,
                    height: 0.h,
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: controller.paymentGateways.map((gateway) {
                      final isSelected = gateway == controller.selectedGateway.value;
                      return ListTile(
                        tileColor: isSelected
                            ? AppColors.primary.withValues(alpha: .12)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10).w,
                        ),
                        title: Text(
                          gateway.name ?? '',
                          style: TextStyle(
                            letterSpacing: 0,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                        onTap: () {
                          controller.selectGateway(gateway);
                          Get.back();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Renders dynamic fields from the selected payment gateway
  List<Widget> _buildDynamicFields() {
    final method = controller.selectedGateway.value;
    if (method?.fieldOptions == null) return [];

    return method!.fieldOptions!.map((field) {
      final isRequired = field.validation == 'required';
      final name = field.name ?? 'common.unnamedField'.trns();
      Widget fieldWidget;
      if (field.type == 'text' || field.type == 'textarea') {
        fieldWidget = AuthTextField(
          label: name,
          hintText: '${'allSchema.payNowPage.enter'.trns()} $name',
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
            label: name,
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
