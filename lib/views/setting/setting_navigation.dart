import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/setting/setting.dart';

final settingNavigationTargets = NavigationTarget(
  path: "settings",
  title: "Settings",
  contentPane: settingScreen(),
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.tune),
    label: Text('Settings'),
  ),
  roles: ['user'],
);
