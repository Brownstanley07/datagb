import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../all_schema/model/all_schema_response_model.dart';
import '../controller/home_controller.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';
import '../../../../utils/helper/currency_formatter.dart';

class PlanCarousel extends StatelessWidget {
  const PlanCarousel({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    //list of plan images
    final List<String> basePlanImages = [
      AppImages.homePlan1,
      AppImages.homePlan2,
      AppImages.homePlan3,
      AppImages.homePlan4,
    ];

    final List<String> allPlanImages = List.generate(
      controller.schemas.length,
      (index) => basePlanImages[index % basePlanImages.length],
    );

    return Obx(() {
      if (controller.isLoading.value) return SpinLoader.loader();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              spacing: 10.w,
              children: List.generate(controller.schemas.length, (index) {
                final String imagePath = allPlanImages[index];
                final Schema schema = controller.schemas[index];
                return GestureDetector(
                  onTap: () {
                    if (controller.user.value?.kyc == 0 ||
                        controller.user.value?.kyc == 2 ||
                        controller.user.value?.kyc == 3) {
                      ToastService.showError(
                        'home.planCarouselKycError'.trns(),
                      );
                      return;
                    }
                    Get.toNamed(BaseRoute.payNow, arguments: schema);
                  },
                  child: Container(
                    width: 212.w,
                    height: 62.h,
                    padding: EdgeInsets.all(12.0.w),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(imagePath)),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  schema.icon ?? '',
                                  height: 14.h,
                                  width: 14.w,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Shimmer.fromColors(
                                          baseColor: AppColors.shimmerBase,
                                          highlightColor:
                                              AppColors.shimmerHighlight,
                                          child: Container(
                                            height: 14.h,
                                            width: 14.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.shimmerBase,
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox.shrink(),
                                ),
                                const Spacer(),
                                Text(
                                  schema.name ?? '',
                                  style: TextStyle(
                                    letterSpacing: 0,
                                    color: AppColors.textPrimary,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    schema.amountRange == 'fixed'
                                        ? CurrencyFormatter.naira(
                                            schema.fixedAmount,
                                          )
                                        : CurrencyFormatter.nairaRange(
                                            schema.minAmount,
                                            schema.maxAmount,
                                          ),
                                    textAlign: TextAlign.right,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    maxLines: 1,
                                    style: TextStyle(
                                      letterSpacing: 0,
                                      color: AppColors.textPrimary,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const Spacer(),
                                  Text(
                                    schema.returnInterest ?? '',
                                    maxLines: 1,
                                    style: TextStyle(
                                      letterSpacing: 0,
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.textPrimary,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      );
    });
  }
}
