import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/exit_dialog/exit_dialog.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../common/widgets/common_button/app_button.dart';
import '../../../../../utils/helper/spin_loader.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controller/onboarding_controller.dart';
import '../widgets/common_onboarding_screen.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final background = dark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final mutedDot = dark ? AppColors.darkBorder : Colors.grey.shade300;
    return Scaffold(
      backgroundColor: background,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          Get.dialog(const ExitDialog());
        },
        child: SafeArea(
          child: Obx(() {
            return controller.isLoading.value
                ? SpinLoader.loader()
                : Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: controller.pageController,
                              onPageChanged: controller.onPageChanged,
                              itemCount: controller.onboardingPages.length,
                              itemBuilder: (context, index) {
                                final page = controller.onboardingPages[index];
                                return OnboardingPage(
                                  imagePath: page.image ?? "",
                                  title: page.title ?? "",
                                  subtitle: page.description ?? "",
                                );
                              },
                            ),
                            Positioned(
                              top: 50.r,
                              right: 24.r,
                              child: GestureDetector(
                                onTap: controller.skip,
                                child: Text(
                                  "onboarding.skipButton".trns(),
                                  style: TextStyle(
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.sp,
                                    color: dark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: controller.pageController,
                        count: controller.onboardingPages.length,
                        effect: ExpandingDotsEffect(
                          activeDotColor: AppColors.primary,
                          dotColor: mutedDot,
                          dotHeight: 8.h,
                          dotWidth: 8.w,
                          expansionFactor: 3,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 18,
                          right: 18,
                          bottom: 36,
                          top: 48,
                        ).r,
                        child: AppButton(
                          text:
                              controller.currentPage.value ==
                                  controller.onboardingPages.length - 1
                              ? "onboarding.getStartedButton".trns()
                              : "onboarding.nextButton".trns(),
                          backgroundColor: AppColors.primary,
                          onPressed: controller.nextPage,
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }
}
