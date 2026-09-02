import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../controller/crowd_history_item_controller.dart';
import '../model/crowd_schema_history_response_model.dart';
import 'crowd_history_details_sheet.dart';
import '../../../../utils/helper/currency_formatter.dart';

class CrowdHistoryItem extends StatelessWidget {
  const CrowdHistoryItem({super.key, required this.item});

  final CrowdInvest item;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CrowdHistoryItemController(item: item),
      tag: item.id.toString(),
    );
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 30.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: AppColors.grey.withAlpha(50)),
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
                item.crowdSchema?.icon ?? "",
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
              "${item.crowdSchema?.name} >> ${CurrencyFormatter.naira(item.investAmount)}",
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              item.createdAtFormat ?? "",
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 12.sp,
                color: AppColors.subText.withValues(alpha: 0.6),
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
          if (item.status != 'pending') ...[
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
          SizedBox(height: 30.h),
          AppButton(
            text: 'crowdSchemaHistory.view'.trns(),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => CrowdHistoryDetailsSheet(
                  item: item,
                  controller: controller,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
