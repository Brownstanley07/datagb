import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../backend/secure_api_controller.dart';
import '../../../../backend/links.dart';
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
  RxString referralLink = "".obs;
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
        referralLink.value = _websiteReferralUrl(response.data);
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

  String get websiteReferralLink => referralLink.value;

  void shareReferralLink() {
    if (referralCode.value.isNotEmpty && referralLink.value.isNotEmpty) {
      SharePlus.instance.share(ShareParams(text: websiteReferralLink));
    } else {
      ToastService.showInfo(
        'referral.controller.linkUnavailable'.trns(),
        title: 'referral.controller.errorTitle'.trns(),
      );
    }
  }

  String _websiteReferralUrl(Data? data) {
    final directLink = data?.link?.trim() ?? '';
    if (directLink.startsWith('http')) return directLink;

    final code = data?.code?.trim() ?? '';
    if (code.isEmpty) return '';

    final siteUrl = Links.baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
    return '$siteUrl/register?invite=${Uri.encodeComponent(code)}';
  }
}
