import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fframe/helpers/fframe_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('FframePrefs', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('getThemeMode should return system when no value is stored', () async {
      final themeMode = await FframePrefs.getThemeMode();
      expect(themeMode, ThemeMode.system);
    });

    test('setThemeMode and getThemeMode should work correctly for dark mode', () async {
      FframePrefs.setThemeMode(themeMode: ThemeMode.dark);
      // Allow the async operation to complete
      await Future.delayed(Duration.zero);
      final themeMode = await FframePrefs.getThemeMode();
      expect(themeMode, ThemeMode.dark);
    });

    test('setThemeMode and getThemeMode should work correctly for light mode', () async {
      FframePrefs.setThemeMode(themeMode: ThemeMode.light);
      // Allow the async operation to complete
      await Future.delayed(Duration.zero);
      final themeMode = await FframePrefs.getThemeMode();
      expect(themeMode, ThemeMode.light);
    });

    test('getString should return fallback when no value is stored', () async {
      final value = await FframePrefs.getString(key: 'testKey', fallback: 'fallback');
      expect(value, 'fallback');
    });

    test('setString and getString should work correctly', () async {
      await FframePrefs.setString(key: 'testKey', value: 'testValue');
      // Allow the async operation to complete
      await Future.delayed(Duration.zero);
      final value = await FframePrefs.getString(key: 'testKey', fallback: 'fallback');
      expect(value, 'testValue');
    });
  });
}
