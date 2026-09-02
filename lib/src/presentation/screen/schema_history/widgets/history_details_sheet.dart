import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../controller/history_item_controller.dart';
import '../controller/schema_history_controller.dart';
import '../model/schema_history_response_model.dart';
import '../../../../utils/constants/image_string.dart';

import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class HistoryDetailsSheet extends StatelessWidget {
  final Invest item;
  final HistoryItemController controller;
  const HistoryDetailsSheet({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final schemaController = Get.find<SchemaHistoryController>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Drag handle
          Center(
            child: Container(
              width: 30.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 39.h),
              decoration: BoxDecoration(
                color: AppColors.grey.withAlpha(130),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "schemaHistory.details".trns(),
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Divider(height: 0.h, color: AppColors.grey.withAlpha(80)),
          SizedBox(height: 16.h),

          /// Title + Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.schema?.name ?? '',
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                CurrencyFormatter.naira(item.investAmount),
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.createAtDateFormat ?? "",
                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.subText.withValues(alpha: 0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                item.createAtTimeFormat ?? "",
                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.subText.withValues(alpha: 0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          SizedBox(height: 30.h),

          _row("schemaHistory.roi".trns(), item.roi ?? '0%'),
          _row(
            "schemaHistory.profit".trns(),
            item.profitText ?? '0%',
            valueColor: Colors.red,
            isBold: true,
          ),

          _row(
            "schemaHistory.pendingRemaining".trns(),
            item.periodRemaining ?? 'schemaHistory.times'.trns(),
          ),
          _row(
            "schemaHistory.status".trns(),
            item.status?.capitalizeFirst ?? 'schemaHistory.success'.trns(),
            valueColor:
                item.status == 'success' ||
                    item.status == 'completed' ||
                    item.status == 'ongoing'
                ? AppColors.success
                : item.status == 'pending'
                ? AppColors.pending
                : item.status == 'paused'
                ? AppColors.warning
                : AppColors.error,
          ),
          _row(
            "schemaHistory.capitalBack".trns(),
            item.schema?.capitalBack == true
                ? "schemaHistory.yes".trns()
                : "schemaHistory.no".trns(),
          ),
          if (item.schema?.isAutoRenewal == true)
            Obx(() {
              final updatedItem = schemaController.invest.firstWhere(
                (e) => e.id == item.id,
                orElse: () => item,
              );

              return _buildSwitchRow(
                label: "schemaHistory.autoRenew".trns(),
                value: updatedItem.isAutoRenewal ?? false,
                onChanged: (newValue) {
                  if (item.status == 'ongoing') {
                    schemaController.toggleAutoRenewal(item.id ?? 0);
                  }
                },
              );
            }),

          if (item.status == 'ongoing' && item.isCancel == true) ...[
            _row("crowdSchemaHistory.timeline".trns(), ''),
            SizedBox(height: 9.h),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      minHeight: 10.h,
                      value: controller.progress.value,
                      backgroundColor: AppColors.primary.withAlpha(30),
                      color: AppColors.primary.withAlpha(200),
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    '${(controller.progress.value * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Obx(
              () => Text(
                '${controller.remainingTime.value.inDays}D  :  ${(controller.remainingTime.value.inHours % 24).toString().padLeft(2, '0')}H  :  ${(controller.remainingTime.value.inMinutes % 60).toString().padLeft(2, '0')}M  :  ${(controller.remainingTime.value.inSeconds % 60).toString().padLeft(2, '0')}S',
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.subText.withValues(alpha: 0.8),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            AppButton(
              text: 'schemaHistory.cancel'.trns(),
              onPressed: () {
                _showConfirmationSheet(context, item.id?.toInt() ?? 0);
              },
              backgroundColor: AppColors.error,
            ),
          ],

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  void _showConfirmationSheet(BuildContext context, int id) {
    final schemaController = Get.find<SchemaHistoryController>();
    Get.bottomSheet(
      Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 30.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 39.h),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withAlpha(130),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(height: 25.h),
              SvgPicture.asset(AppImages.cancelSvg),
              SizedBox(height: 25.h),
              Text(
                'schemaHistory.areYouSure'.trns(),
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'schemaHistory.desc'.trns(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 13.sp,
                  color: AppColors.grey,
                ),
              ),
              SizedBox(height: 60.h),
              AppButton(
                text: "schemaHistory.yesIam".trns(),
                isLoading: schemaController.isSubmitting.value,
                onPressed: () async {
                  await schemaController.cancelSchema(id: id);
                  Get.back();
                  Get.back();
                },
              ),

              SizedBox(height: 20.w),
              AppButton(
                text: 'schemaHistory.notNow'.trns(),
                onPressed: () => Get.back(),
                backgroundColor: AppColors.error,
              ),
              SizedBox(height: 20.w),
            ],
          ),
        ),
      ),
      isDismissible: !schemaController.isSubmitting.value,
      enableDrag: !schemaController.isSubmitting.value,
    );
  }

  Widget _row(
    String label,
    String value, {
    Color valueColor = AppColors.textPrimary,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.subText.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.subText.withValues(alpha: 0.6),
            ),
          ),
          Transform.scale(
            scale: 0.7,
            alignment: Alignment.centerRight,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
