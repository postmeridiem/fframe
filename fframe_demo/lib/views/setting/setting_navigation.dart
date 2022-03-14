import 'package:flutter/material.dart';
import 'package:fframe/models/navigation_target.dart';
import 'package:fframe_demo/views/setting/setting.dart';

final settingNavigationTargets = NavigationTarget(
  path: "settings",
  title: "Settings",
  contentPane: const SettingScreen(),
  navigationRailDestination: const NavigationRailDestination(
    icon: Icon(Icons.tune),
    label: Text('Settings'),
  ),
  roles: ['user'],
);
