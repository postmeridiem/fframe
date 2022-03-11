import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/scratchpad/scratchpad.dart';

final scratchpadNavigationTargets = NavigationTarget(
  path: "scratchpad",
  title: "Scratchpads",
  navigationTabs: <NavigationTab>[
    NavigationTab(
      contentPane: scratchpadScreen(active: true),
      title: "Active",
      path: "activee",
    ),
    NavigationTab(
      contentPane: scratchpadScreen(active: false),
      title: "Inactive",
      path: "inactivee",
    )
  ],
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.draw),
    label: Text('Scratchpads'),
  ),
  roles: ['user'],
);
