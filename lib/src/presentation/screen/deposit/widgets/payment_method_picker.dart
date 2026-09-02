import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../controller/deposit_controller.dart';

class PaymentMethodPicker extends StatelessWidget {
  const PaymentMethodPicker({super.key, required this.ctrl});

  final DepositController ctrl;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.darkCard : AppColors.lightCard;
    final field = dark ? const Color(0xFF182437) : AppColors.lightTextfield;
    final title = dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final muted = dark
        ? AppColors.darkTextTertiary
        : AppColors.lightTextTertiary;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "deposit.paymentMethodPicker.title".trns(),
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
          onTap: () {
            showModalBottomSheet(
              context: Get.context!,
              backgroundColor: surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
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
                        'deposit.paymentMethodPicker.selectPaymentMethod'
                            .trns(),
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: title,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.h, bottom: 10.h),
                        child: Divider(color: border, height: 0.h),
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: ctrl.methods.map((m) {
                            final bool isBank =
                                (m.name ?? '').toLowerCase().contains('bank') ||
                                (m.name ?? '').toLowerCase().contains(
                                  'transfer',
                                );
                            return ListTile(
                              tileColor: m == ctrl.selectedMethod.value
                                  ? AppColors.primary.withValues(alpha: .12)
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10).w,
                              ),
                              title: Row(
                                children: [
                                  if (isBank) ...[
                                    Icon(
                                      Icons.account_balance_rounded,
                                      size: 18.sp,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 8.w),
                                  ],
                                  Expanded(
                                    child: Text(
                                      m.name ?? '',
                                      style: TextStyle(
                                        letterSpacing: 0,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: m == ctrl.selectedMethod.value
                                            ? title
                                            : muted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                ctrl.selectMethod(m);
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
          },
          child: Obx(() {
            return Container(
              padding: EdgeInsets.only(left: 16.r, right: 10.r),
              height: 48.h,
              decoration: BoxDecoration(
                color: field,
                borderRadius: BorderRadius.circular(20.w),
                border: Border.all(
                  color: ctrl.hasPaymentMethodError.value
                      ? AppColors.error
                      : AppColors.transparent,
                  width: ctrl.hasPaymentMethodError.value ? 1.w : 0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final m = ctrl.selectedMethod.value;
                      final bool isBank =
                          (m?.name ?? '').toLowerCase().contains('bank') ||
                          (m?.name ?? '').toLowerCase().contains('transfer');
                      return Row(
                        children: [
                          if (isBank) ...[
                            Icon(
                              Icons.account_balance_rounded,
                              size: 18.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8.w),
                          ],
                          Expanded(
                            child: Text(
                              m?.name ??
                                  'deposit.paymentMethodPicker.chooseMethod'
                                      .trns(),
                              style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 14.sp,
                                fontWeight: m == null
                                    ? FontWeight.w500
                                    : FontWeight.w600,
                                color: m == null ? muted : title,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: dark
                          ? const Color(0xFF26354A)
                          : AppColors.grey.withAlpha(45),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: AppColors.primary.withAlpha(200),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
