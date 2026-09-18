import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';

import '../model/referral_success_response.dart';

class ReferralController extends GetxController {
  SecureApiController secureApiController;

  ReferralController({required this.secureApiController});

  @override
  void onInit() {
    super.onInit();
    loadReferral();
  }

  RxBool isLoading = false.obs;
  Rxn<Data> referral = Rxn<Data>();
  RxString referralCode = "".obs;
  RxString totalReferralPoint = "".obs;
  RxSet<int> expanded = <int>{}.obs;
  RxList<Tree> tree = RxList<Tree>();
  RxList<General> general = <General>[].obs;
  RxList<Targeted> targeted = <Targeted>[].obs;

  Future<void> loadReferral() async {
    isLoading.value = true;
    await _fetchReferral();
    isLoading.value = false;
  }

  Future<void> refreshReferral() async {
    isLoading.value = true;
    await _fetchReferral();
    isLoading.value = false;
  }

  Future<void> _fetchReferral() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getReferral();
      if (response.status == true) {
        referral.value = response.data;
        referralCode.value = response.data?.code ?? "";
        tree.assignAll([response.data?.tree ?? Tree()]);
        totalReferralPoint.value = response.data?.totalReferralPoint ?? "";
        general.value = response.data?.referralLogs?.general ?? [];
        targeted.value = response.data?.referralLogs?.targeted ?? [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(' the error is $e');
      }
    }
  }

  void toggle(int index) {
    if (expanded.contains(index)) {
      expanded.remove(index);
    } else {
      expanded.add(index);
    }
  }

  void shareReferralCode() {
    if (referralCode.value.isNotEmpty) {
      SharePlus.instance.share(
        ShareParams(
          text:
              'Use my referral code ${referralCode.value} when creating your DataGB account.',
        ),
      );
    } else {
      ToastService.showInfo(
        'Your referral code is not available yet.',
        title: 'referral.controller.errorTitle'.trns(),
      );
    }
  }

  Future<void> copyReferralCode() async {
    final code = referralCode.value.trim();
    if (code.isEmpty) {
      ToastService.showInfo('Your referral code is not available yet.');
      return;
    }
    await Clipboard.setData(ClipboardData(text: code));
    ToastService.showSuccess('Referral code copied.');
  }
}
