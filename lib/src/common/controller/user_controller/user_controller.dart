import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../backend/secure_api_controller.dart';

import '../../../presentation/screen/profile_settings/model/user_response_model.dart';

class UserController extends GetxController {
  final SecureApiController secureApiController;

  UserController({required this.secureApiController});

  RxBool isLoading = false.obs;
  Rxn<User> user = Rxn<User>();

  Future<void> loadUser() async {
    isLoading.value = true;
    await secureApiController.ensureInitialized();

    try {
      final response = await secureApiController.api!.getUser();
      if (response.status == true) {
        user.value = response.data?.user;
      }
    } catch (e) {
      if (kDebugMode) {
        print(' the error is $e');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
