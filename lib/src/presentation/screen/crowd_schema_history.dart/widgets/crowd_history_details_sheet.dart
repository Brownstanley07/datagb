import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/crowd_history_item_controller.dart';
import '../model/crowd_schema_history_response_model.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class CrowdHistoryDetailsSheet extends StatelessWidget {
  final CrowdInvest item;
  final CrowdHistoryItemController controller;
  const CrowdHistoryDetailsSheet({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
              "crowdSchemaHistory.details".trns(),
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
                item.crowdSchema?.name ?? '',
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
                  // color: data.amount.contains("-")
                  //     ? Colors.red
                  //     : Colors.green,
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
                item.createdAtDateFormat ?? '',

                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.subText.withValues(alpha: 0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                item.createdAtTimeFormat ?? '',
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

          _row("crowdSchemaHistory.roi".trns(), item.roi ?? '0%'),
          _row(
            "crowdSchemaHistory.profit".trns(),
            item.status != 'completed'
                ? 'crowdSchemaHistory.pending'.trns()
                : item.profitAmount ?? "0",
            valueColor: item.status != 'completed'
                ? AppColors.pending
                : AppColors.textTertiary,
            isBold: true,
          ),

          _row(
            "crowdSchemaHistory.status".trns(),
            item.status?.capitalizeFirst ?? "crowdSchemaHistory.success".trns(),
            valueColor:
                item.status == 'success' ||
                    item.status == 'completed' ||
                    item.status == 'ongoing'
                ? AppColors.success
                : AppColors.pending,
          ),
          if (item.crowdSchema?.endDate != null)
            _row(
              "crowdSchemaHistory.daysLeft".trns(),
              " ${item.crowdSchema?.daysLeft.toString() ?? '0'} ${'crowdSchemaHistory.days'.trns()}",
            ),
          _row(
            "crowdSchemaHistory.returnDate".trns(),
            item.crowdSchema?.returnDateFormat ?? '',
          ),
          if (item.status == 'ongoing') ...[
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
          ],
          SizedBox(height: 30.h),
        ],
      ),
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
}
