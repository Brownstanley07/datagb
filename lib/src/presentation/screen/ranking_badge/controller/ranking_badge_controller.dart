import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../backend/secure_api_controller.dart';
import '../model/ranking_badge_response_model.dart';

import '../../../../utils/helper/gradient_helper.dart';

class RankingBadgeController extends GetxController {
  final SecureApiController secureApiController;
  RankingBadgeController({required this.secureApiController});

  final Map<String, List<Color>> _cache = {};
  RxBool isLoading = false.obs;
  RxList<Ranking> badges = <Ranking>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBadges();
  }

  List<Color> getGradientColors(String title) {
    if (_cache.containsKey(title)) return _cache[title]!;
    final colors = GradientHelper.gradientFromString(title);
    _cache[title] = colors;
    return colors;
  }

  Future<void> fetchBadges() async {
    isLoading.value = true;
    await _fetchBadges();
    isLoading.value = false;
  }

  Future<void> refreshBadges() async {
    isLoading.value = true;
    await _fetchBadges();
    isLoading.value = false;
  }

  Future<void> _fetchBadges() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.rankingBadge();
      if (response.status == true) {
        badges.value = response.data?.ranking ?? [];
      }
    } catch (_) {}
  }

  void clearCache() {
    _cache.clear();
  }

  @override
  void onClose() {
    _cache.clear();
    super.onClose();
  }
}
