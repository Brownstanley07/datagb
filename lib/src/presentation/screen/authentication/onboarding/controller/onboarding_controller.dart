import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../backend/public_api.dart';
import '../model/onboardig_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../app/routes/routes.dart';

class OnboardingController extends GetxController {
  final PublicApi publicApi;
  OnboardingController({required this.publicApi});

  var pageController = PageController();
  var currentPage = 0.obs;
  var isLoading = true.obs;
  RxList<OnboardingSplashScreen> onboardingPages =
      <OnboardingSplashScreen>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOnboardingData();
  }

  Future<void> fetchOnboardingData() async {
    try {
      isLoading.value = true;
      final response = await publicApi.getOnboardingData();
      if (response.status == true) {
        if (response.data?.enabled == false) {
          Get.offAllNamed(BaseRoute.login);
          return;
        }
        onboardingPages.value = response.data?.onboardingSplashScreens ?? [];
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _saveOnboardingSeen();
      Get.offAllNamed(BaseRoute.login);
    }
  }

  Future<void> _saveOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("has_seen_onboarding", true);
  }

  void skip() {
    _saveOnboardingSeen();
    Get.offAllNamed(BaseRoute.login);
  }
}
