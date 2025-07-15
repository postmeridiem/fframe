import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FframePrefs {
  static final FframePrefs instance = FframePrefs._internal();

// stores current language map. has some boot up defaults
  late Map<String, dynamic> map = {};

  FframePrefs._internal();

  factory FframePrefs() {
    return instance;
  }

  static Future<ThemeMode> getThemeMode() async {
    return await getString(key: "themeMode", fallback: "system").then((value) {
      ThemeMode mode;
      switch (value) {
        case 'dark':
          mode = ThemeMode.dark;
          break;
        case 'light':
          mode = ThemeMode.light;
          break;
        case 'system':
        default:
          mode = ThemeMode.system;
      }
      return mode;
    });
  }

  static void setThemeMode({required ThemeMode themeMode}) {
    String mode;
    switch (themeMode) {
      case ThemeMode.dark:
        mode = 'dark';
        break;
      case ThemeMode.light:
        mode = 'light';
        break;
      case ThemeMode.system:
        mode = 'system';
    }
    setString(key: "themeMode", value: mode);
  }

  static Future<String> getString({required String key, required String fallback}) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key) ?? fallback;
  }

  static Future<void> setString({required String key, required String value}) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }
}


// 