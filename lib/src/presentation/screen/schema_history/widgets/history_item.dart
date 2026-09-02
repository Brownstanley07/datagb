import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../controller/history_item_controller.dart';
import '../model/schema_history_response_model.dart';
import 'history_details_sheet.dart';
import '../../../../utils/helper/currency_formatter.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key, required this.item});

  final Invest item;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      HistoryItemController(item: item),
      tag: item.id.toString(),
    );
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(color: const Color(0xFFF0F1F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              height: 44.h,
              width: 44.w,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.grey.withAlpha(30),
                shape: .circle,
              ),
              child: Image.network(
                item.schema?.icon ?? "",
                width: 20.w,
                height: 20.h,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: AppColors.shimmerBase,
                    highlightColor: AppColors.shimmerHighlight,
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerBase,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
            title: Text(
              item.schema?.name ?? 'Investment',
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                '${CurrencyFormatter.naira(item.investAmount)}  •  ${item.createdAtFormat}',
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 11.sp,
                  color: AppColors.subText.withValues(alpha: 0.65),
                ),
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: BoxDecoration(
                color:
                    item.status == 'success' ||
                        item.status == 'completed' ||
                        item.status == 'ongoing'
                    ? AppColors.success.withAlpha(15)
                    : item.status == 'pending'
                    ? AppColors.pending.withAlpha(15)
                    : AppColors.error.withAlpha(15),
                borderRadius: .circular(12.w),
              ),
              child: Text(
                item.status?.capitalizeFirst ?? '',
                style: TextStyle(
                  letterSpacing: 0,
                  color:
                      item.status == 'success' ||
                          item.status == 'completed' ||
                          item.status == 'ongoing'
                      ? AppColors.success
                      : item.status == 'pending'
                      ? AppColors.pending
                      : AppColors.error,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (item.status == 'ongoing') ...[
            SizedBox(height: 30.h),
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
          SizedBox(height: 18.h),
          AppButton(
            text: 'schemaHistory.view'.trns(),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) =>
                    HistoryDetailsSheet(item: item, controller: controller),
              );
            },
          ),
        ],
      ),
    );
  }
}
