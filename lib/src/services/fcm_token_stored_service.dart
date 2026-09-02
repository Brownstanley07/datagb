import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenStoredService extends GetxService {
  static const String currentFcmTokenKey = 'current_fcm_token';
  final Rx<String?> currentFcmToken = Rx<String?>(null);

  Future<void> saveFcmToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentFcmToken.value = token;
    await prefs.setString(currentFcmTokenKey, token);
  }

  Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentFcmTokenKey);
  }

  Future<void> deleteFcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(currentFcmTokenKey);
  }
}
