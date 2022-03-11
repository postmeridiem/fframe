import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/configuration/configuration.dart';

final configurationNavigationTargets = NavigationTarget(
  path: "configuration",
  title: "Configuration",
  // navigationTabs: <NavigationTab>[
  //   NavigationTab(
  //     contentPane: configurationScreen(active: true),
  //     title: "Active",
  //     path: "activec",
  //   ),
  //   NavigationTab(
  //     contentPane: configurationScreen(active: false),
  //     title: "Inactive",
  //     path: "inactivec",
  //   )
  // ],

  contentPane: configurationScreen(),
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.tune),
    label: Text('Configuration'),
  ),
  roles: ['user'],
);
