import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/all_transaction_controller.dart';
import '../../../../utils/constants/app_colors.dart';

class DynamicTabs extends GetView<AllTransactionController> {
  const DynamicTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = isDark ? const Color(0xFF94A3B8) : AppColors.muted;

    return Obx(() {
      if (controller.transactionsType.isEmpty) {
        return SizedBox(
          height: 40.h,
          child: const Center(child: Text("")),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(controller.transactionsType.length, (index) {
            final isSelected = index == controller.selectedTab.value;

            return GestureDetector(
              onTap: () => controller.changeTab(index),
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    Text(
                      controller.transactionsType[index].name ??
                          'common.unknown'.trns(),
                      style: TextStyle(
                        letterSpacing: 0,
                        fontSize: 13.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w400,
                        color: isSelected ? AppColors.primary : inactiveColor,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    if (isSelected)
                      Container(
                        height: 2.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      )
                    else
                      SizedBox(height: 2.h),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
