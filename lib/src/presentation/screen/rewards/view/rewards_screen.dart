import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../controller/reward_controller.dart';
import '../widgets/redeem_earning_tile.dart';
import '../widgets/reward_earing_tile.dart';

class RewardsScreen extends GetView<RewardController> {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonHeader(title: "rewards.title".trns()),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return SpinLoader.loader();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      /// Top Reward Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        margin: EdgeInsets.symmetric(horizontal: 18.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: Get.isDarkMode
                                ? [const Color(0xFF1E3A8A), const Color(0xFF0F172A)]
                                : [const Color(0xFF2452F9), const Color(0xFF0A2580)],
                          ),
                          image: const DecorationImage(
                            image: AssetImage(AppImages.rewardBg),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "rewards.myRewardPoints".trns(),
                              style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 14.sp,
                                color: Colors.white.withValues(alpha: .85),
                              ),
                            ),

                            SizedBox(height: 6.h),

                            Text(
                              "${controller.reward.value?.points ?? 0}${"rewards.pointsSuffix".trns()}",
                              style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: 8.h),

                            Text(
                              controller.reward.value?.text ??
                                  "rewards.pointConversion".trns(),
                              style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 12.sp,
                                color: const Color(0xFF60A5FA),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 20.h),

                            ElevatedButton(
                              onPressed: controller.reward.value?.points == 0
                                  ? null
                                  : () => controller.redeemNow(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                minimumSize: Size(95.w, 30.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                              ),
                              child: Text(
                                "rewards.redeemNowButton".trns(),
                                style: TextStyle(
                                  letterSpacing: 0,
                                  fontSize: 11.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30.h),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: Container(
                          height: 48.h,
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(52.r),
                            border: Border.all(
                              color: AppColors.border,
                            ),
                          ),
                          child: TabBar(
                            indicator: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: AppColors.transparent,
                            labelColor: AppColors.primary,
                            unselectedLabelColor: AppColors.textPrimary,
                            splashFactory: NoSplash.splashFactory,
                            labelStyle: TextStyle(
                              letterSpacing: 0,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: TextStyle(
                              letterSpacing: 0,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.muted,
                            ),
                            tabs: [
                              Tab(text: "rewards.earningsTab".trns()),
                              Tab(text: "rewards.historyTab".trns()),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: TabBarView(
                          children: [
                            RefreshIndicator(
                              color: AppColors.primary,
                              onRefresh: () async {
                                await controller.refreshRewards();
                              },
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  if (controller.rewardList.isEmpty) {
                                    return ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(
                                          height: constraints.maxHeight,
                                          child: Center(
                                            child: Text(
                                              "rewards.noEarnings".trns(),
                                              style: TextStyle(color: AppColors.textPrimary),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  return ListView.separated(
                                    itemCount: controller.rewardList.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(height: 0.h, color: AppColors.border),
                                    itemBuilder: (context, index) {
                                      final reward =
                                          controller.rewardList[index];
                                      return RewardEarningTile(
                                        icon: reward.rankingIcon ?? "",
                                        title: reward.ranking ?? "",
                                        subtitle: reward.rankingLevel ?? "",
                                        amount:
                                            reward.amountOfTransactions ??
                                            '0 ${'common.currencyUsd'.trns()}',
                                        point: reward.point ?? '0 Points',
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            RefreshIndicator(
                              color: AppColors.primary,
                              onRefresh: () async {
                                await controller.refreshRewards();
                              },
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  if (controller.redeemList.isEmpty) {
                                    return ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(
                                          height: constraints.maxHeight,
                                          child: Center(
                                            child: Text(
                                              "rewards.noRedeems".trns(),
                                              style: TextStyle(color: AppColors.textPrimary),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }

                                  return ListView.separated(
                                    itemCount: controller.redeemList.length,
                                    separatorBuilder: (context, index) =>
                                        Divider(height: 0.h, color: AppColors.border),
                                    itemBuilder: (context, index) {
                                      final redeem =
                                          controller.redeemList[index];
                                      return RedeemEarningTile(
                                        icon: redeem.rankingIcon ?? "",
                                        title: redeem.ranking ?? "",
                                        subtitle: redeem.rankingLevel ?? "",
                                        amount:
                                            redeem.amount ??
                                            '0 ${'common.currencyUsd'.trns()}',
                                        point: redeem.point ?? '0 Points',
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
