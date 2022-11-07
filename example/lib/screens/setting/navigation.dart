import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/setting/setting.dart';

final settingNavigationTarget = NavigationTarget(
  path: "settings",
  title: "Settings",
  contentPane: const SettingScreen(),
  destination: Destination(
    icon: const Icon(Icons.tune),
    navigationLabel: () => const Text('Settings'),
  ),
  roles: ['User', 'Developer', 'SuperAdmin'],
  private: true,
);
