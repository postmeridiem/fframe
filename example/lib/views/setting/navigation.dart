import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';
import 'package:example/views/setting/setting.dart';

final settingNavigationTargets = NavigationTarget(
  path: "settings",
  title: "Settings",
  contentPane: const SettingScreen(),
  navigationRailDestination: const NavigationRailDestination(
    icon: Icon(Icons.tune),
    label: Text('Settings'),
  ),
  roles: ['UserAdmin', 'SuperAdmin'],
);
