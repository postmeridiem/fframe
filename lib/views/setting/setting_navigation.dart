import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/setting/setting.dart';

final settingNavigationTargets = NavigationTarget(
  path: "settings",
  title: "Settings",
  // navigationTabs: <NavigationTab>[
  //   NavigationTab(
  //     contentPane: settingScreen(),
  //     title: "Active",
  //     path: "active",
  //   ),
  //   NavigationTab(
  //     contentPane: settingScreen(),
  //     title: "Inactive",
  //     path: "inactive",
  //   )
  // ],

  contentPane: settingScreen(),
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.tune),
    label: Text('Settings'),
  ),
  roles: ['user'],
);
