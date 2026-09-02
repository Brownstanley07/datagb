import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  static const String themeKey = 'app_theme_mode';

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(themeKey) ?? 'system';
    themeMode.value = _getThemeModeFromString(themeString);
    Get.changeThemeMode(themeMode.value);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, _getStringFromThemeMode(mode));
    update();
  }

  bool get isDarkMode {
    if (themeMode.value == ThemeMode.dark) return true;
    if (themeMode.value == ThemeMode.light) return false;
    return Get.isPlatformDarkMode;
  }

  ThemeMode _getThemeModeFromString(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _getStringFromThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  String get currentThemeName {
    switch (themeMode.value) {
      case ThemeMode.light:
        return 'Light Theme';
      case ThemeMode.dark:
        return 'Dark Theme';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  IconData get currentThemeIcon {
    switch (themeMode.value) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }
}
