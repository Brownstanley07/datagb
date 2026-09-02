import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_data.dart';

const String authPersistData = 'authPersistData';

class AuthPersistData {
  static const _tokenKey = 'auth_token';
  static const _biometricTokenKey = 'biometric_auth_token';
  static const _storage = FlutterSecureStorage();

  Future<void> setAuthData(AuthData authData) async {
    await _storage.write(key: _tokenKey, value: authData.token);
    await (await SharedPreferences.getInstance()).remove(authPersistData);
  }

  Future<AuthData> getAuthData() async {
    final token = await _storage.read(key: _tokenKey);
    await (await SharedPreferences.getInstance()).remove(authPersistData);
    if (token == null || token.isEmpty) throw Exception('not authenticated');
    return AuthData(token: token);
  }

  Future<void> deleteAuthData() async {
    await _storage.delete(key: _tokenKey);
    await (await SharedPreferences.getInstance()).remove(authPersistData);
  }

  Future<void> setBiometricAuthData(AuthData authData) async {
    await _storage.write(key: _biometricTokenKey, value: authData.token);
  }

  Future<AuthData?> getBiometricAuthData() async {
    final token = await _storage.read(key: _biometricTokenKey);
    if (token == null || token.isEmpty) return null;
    return AuthData(token: token);
  }

  Future<void> deleteBiometricAuthData() async {
    await _storage.delete(key: _biometricTokenKey);
  }
}
