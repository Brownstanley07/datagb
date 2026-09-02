import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../app/routes/routes.dart';
import '../../../../../backend/auth_persist_data.dart';

import '../../../../../common/controller/initial_controller.dart';
import '../../../../../common/controller/settings_controller/settings_controller.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  AnimationController? textAnimationController;
  AnimationController? circleAnimationController;
  Animation<double>? circleAnimation;

  final RxBool isReady = false.obs;
  bool hasSeenOnboarding = false;
  bool _isRouting = false;

  @override
  void onInit() {
    super.onInit();

    final initialController = Get.find<InitialController>();
    ever(initialController.isInitialized, (bool ready) {
      if (ready) {
        _initializeSplash();
      }
    });

    // App initialization may have completed before this controller subscribed.
    if (initialController.isInitialized.value) {
      _initializeSplash();
    }
  }

  Future<void> _initializeSplash() async {
    if (_isRouting) return;
    _isRouting = true;

    if (await _hasStoredSession()) {
      Get.offAllNamed(BaseRoute.dashboard);
      return;
    }

    await _checkOnboardingStatus();
    final onboardingEnabled =
        Get.find<SettingsController>().isOnboardingEnabled.value;

    circleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    circleAnimation = CurvedAnimation(
      parent: circleAnimationController!,
      curve: Curves.easeInOutCirc,
    );

    textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    isReady.value = true;

    Future.delayed(const Duration(milliseconds: 50), () {
      circleAnimationController!.forward().whenComplete(() {
        Get.offAllNamed(
          !onboardingEnabled || hasSeenOnboarding
              ? BaseRoute.login
              : BaseRoute.onBoarding,
        );
      });
    });
  }

  Future<bool> _hasStoredSession() async {
    try {
      final authData = await Get.find<AuthPersistData>().getAuthData();
      return authData.token.trim().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
  }

  @override
  void onClose() {
    textAnimationController?.dispose();
    circleAnimationController?.dispose();
    super.onClose();
  }
}
