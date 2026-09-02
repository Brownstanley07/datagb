import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../widgets/badge_card.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';

import '../../../../common/widgets/common_hader/common_header.dart';
import '../controller/ranking_badge_controller.dart';

class RankingBadgeScreen extends GetView<RankingBadgeController> {
  const RankingBadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonHeader(title: "rankingBadge.allTheBadges".trns()),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SpinLoader.loader();
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshBadges();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: controller.badges.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20.h,
                        crossAxisSpacing: 20.w,
                        mainAxisExtent: 250.h,
                      ),
                      itemBuilder: (context, index) {
                        final badge = controller.badges[index];
                        final title = badge.name ?? '';
                        final gradientColors = controller.getGradientColors(
                          title,
                        );
                        return BadgeCard(
                          icon: badge.icon ?? '',
                          title: badge.name ?? '',
                          subtitle: badge.description ?? '',
                          isLocked: badge.isLocked ?? false,
                          gradientColors: gradientColors,
                        );
                      },
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
}
