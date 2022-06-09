import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:example/views/setting/setting.dart';

final settingNavigationTarget = NavigationTarget(
  path: "settings",
  title: "Settings",
  contentPane: const SettingScreen(),
  destination: const Destination(
    icon: Icon(Icons.tune),
    label: Text('Settings'),
  ),
  roles: ['UserAdmin', 'SuperAdmin'],
  private: true,
);
