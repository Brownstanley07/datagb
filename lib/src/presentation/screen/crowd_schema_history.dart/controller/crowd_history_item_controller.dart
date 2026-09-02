import 'dart:async';

import 'package:get/get.dart';
import '../../../../common/controller/settings_controller/settings_controller.dart';
import '../model/crowd_schema_history_response_model.dart';

class CrowdHistoryItemController extends GetxController {
  final CrowdInvest item;
  CrowdHistoryItemController({required this.item});

  Timer? _timer;
  final remainingTime = Duration.zero.obs;
  final progress = 0.0.obs;
  final settingsController = Get.find<SettingsController>();
  late final String siteTimezone;

  @override
  void onInit() {
    super.onInit();
    siteTimezone =
        settingsController.settings
            .firstWhere((setting) => setting.name == 'site_timezone')
            .value ??
        'UTC';
    if (item.status != 'pending' && item.updatedAt != null) {
      _updateTimer();
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _updateTimer(),
      );
    }
  }

  void _updateTimer() {
    final now = DateTime.now().toUtc();
    final createdAt = item.createdAt;
    final nextProfitTime = item.crowdSchema?.returnDate;

    if (nextProfitTime != null && now.isBefore(nextProfitTime)) {
      final safeCreatedAt = createdAt ?? DateTime.now();
      final totalDuration = nextProfitTime.difference(safeCreatedAt);
      final elapsedDuration = now.difference(safeCreatedAt);

      remainingTime.value = nextProfitTime.difference(now);
      progress.value = (elapsedDuration.inSeconds / totalDuration.inSeconds)
          .clamp(0.0, 1.0);
    } else {
      remainingTime.value = Duration.zero;
      progress.value = 1.0;
      _timer?.cancel();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
