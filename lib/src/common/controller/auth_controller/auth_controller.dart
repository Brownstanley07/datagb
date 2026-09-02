import 'package:get/get.dart';

class AuthController extends GetxController {
  // false = Login, true = SignUp
  var isSignUpSelected = false.obs;

  void toggleToLogin() => isSignUpSelected.value = false;
  void toggleToSignUp() => isSignUpSelected.value = true;
}
