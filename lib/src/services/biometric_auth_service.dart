import 'package:flutter/foundation.dart';
import '../common/widgets/extension/translation_extension.dart';
import '../utils/snackbar/snackbar_helper.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication biometricService = LocalAuthentication();

  Future<bool> authenticateWithBiometrics() async {
    try {
      final canCheck = await biometricService.canCheckBiometrics;
      final isSupport = await biometricService.isDeviceSupported();
      final available = await biometricService.getAvailableBiometrics();

      if (!isSupport) {
        ToastService.showError('biometric.deviceNotSupported'.trns());
        return false;
      }

      if (!canCheck) {
        ToastService.showError('biometric.notAvailable'.trns());
        return false;
      }
      if (canCheck && available.isEmpty) {
        ToastService.showError('biometric.notEnrolled'.trns());
        return false;
      }

      return await biometricService.authenticate(
        localizedReason: 'biometric.authenticateReason'.trns(),
        biometricOnly: true,
        sensitiveTransaction: false,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      ToastService.showError('biometric.authenticationFailed'.trns());
      if (kDebugMode) {
        print(' Biometric authentication failed: $e');
      }
      return false;
    }
  }

  Future<bool> isBiometricAvailable() async {
    try {
      final canCheck = await biometricService.canCheckBiometrics;
      final isSupport = await biometricService.isDeviceSupported();
      final available = await biometricService.getAvailableBiometrics();
      return isSupport && canCheck && available.isNotEmpty;
    } catch (e) {
      ToastService.showError('biometric.availabilityCheckFailed'.trns());
      if (kDebugMode) {
        print(' Biometric authentication failed: $e');
      }
      return false;
    }
  }
}
