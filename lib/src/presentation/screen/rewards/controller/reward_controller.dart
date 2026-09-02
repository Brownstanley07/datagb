import 'package:get/get.dart';
import '../../../../backend/secure_api_controller.dart';
import '../model/reward_response_model.dart';

class RewardController extends GetxController {
  SecureApiController secureApiController;

  RewardController({required this.secureApiController});

  @override
  void onInit() {
    super.onInit();
    loadRewards();
  }

  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxList<Earning> rewardList = <Earning>[].obs;
  RxList<Earning> redeemList = <Earning>[].obs;
  Rxn<Rewards> reward = Rxn<Rewards>();

  Future<void> loadRewards() async {
    isLoading.value = true;
    await _fetchRewards();
    isLoading.value = false;
  }

  Future<void> refreshRewards() async {
    isLoading.value = true;
    await _fetchRewards();
    isLoading.value = false;
  }

  Future<void> _fetchRewards() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getReward();
      if (response.status == true) {
        reward.value = response.data!.rewards;
        rewardList.value = response.data!.rewards?.earnings ?? [];
        redeemList.value = response.data!.rewards?.redeems ?? [];
      }
    } catch (_) {}
  }

  Future<void> redeemNow() async {
    isSubmitting.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.redeemNow();
      if (response.status == true) {
        loadRewards();
      }
    } catch (_) {
    } finally {
      isSubmitting.value = false;
    }
  }
}
