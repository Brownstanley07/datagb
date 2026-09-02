import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/crowd_schema_controller.dart';
import '../../../../utils/constants/app_colors.dart';

class DynamicTabs extends GetView<CrowdSchemaController> {
  const DynamicTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.schemas.isEmpty) {
        return SizedBox(
          height: 40.h,
          child: Center(
            child: Text(
              "crowdSchema.crowdSchemaReviewDetails.noCrowdSchema".trns(),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Row(
          children: List.generate(controller.schemas.length, (index) {
            final schema = controller.schemas[index];
            final isSelected = controller.selectedSchema.value?.id == schema.id;

            return GestureDetector(
              onTap: () => controller.selectCrowdSchema(schema),
              child: Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: Column(
                  children: [
                    Text(
                      schema.name ?? 'common.unknown'.trns(),
                      style: TextStyle(
                        letterSpacing: 0,
                        fontSize: 13.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.subText.withValues(alpha: 0.6),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    if (isSelected)
                      Container(
                        height: 2.h,
                        width: 40.w,
                        color: AppColors.primary,
                      ),
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
