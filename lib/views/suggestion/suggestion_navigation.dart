import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/suggestion/suggestion.dart';

final suggestionNavigationTargets = NavigationTarget(
  path: "suggestions",
  title: "Suggestions",
  // navigationTabs: <NavigationTab>[
  //   NavigationTab(
  //     contentPane: suggestionScreen(),
  //     title: "Active",
  //     path: "active",
  //   ),
  //   NavigationTab(
  //     contentPane: suggestionScreen(),
  //     title: "Inactive",
  //     path: "inactive",
  //   )
  // ],

  contentPane: suggestionScreen(),
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.pest_control),
    label: Text('Suggestions'),
  ),
  roles: ['user'],
);
