import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/language_controller.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';

void showLanguageBottomSheet(BuildContext context) {
  final controller = Get.find<LanguageController>();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        builder: (_, scrollController) {
          return Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: controller.isLoading.value
                  ? Center(child: SpinLoader.loader())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag handle
                        Center(
                          child: Container(
                            width: 40.w,
                            height: 5.h,
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),

                        // Title
                        Text(
                          "setting.selectLanguage".trns(),
                          style: TextStyle(
                            letterSpacing: 0,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // List of languages
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: controller.languageList.length,
                            itemBuilder: (_, index) {
                              final language = controller.languageList[index];
                              final isSelected =
                                  controller.selectedLang.value ==
                                  language.locale;

                              return GestureDetector(
                                onTap: () async {
                                  Get.back();
                                  await controller.changeLanguage(language);
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 6.h),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 12.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary.withValues(
                                            alpha: 0.1,
                                          )
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: isSelected
                                        ? Border.all(
                                            color: AppColors.primary.withAlpha(
                                              80,
                                            ),
                                            width: 1.5,
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          language.name ?? '',
                                          style: TextStyle(
                                            letterSpacing: 0,
                                            fontSize: 16.sp,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w400,
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.grey,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check_circle,
                                          color: AppColors.primary,
                                          size: 24.sp,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      );
    },
  );
}
