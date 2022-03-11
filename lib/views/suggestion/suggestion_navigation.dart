import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/suggestion/suggestion.dart';

final suggestionNavigationTargets = NavigationTarget(
  path: "suggestion",
  title: "Suggestions",
  navigationTabs: <NavigationTab>[
    NavigationTab(
      contentPane: suggestionScreen(active: true),
      title: "Active",
      path: "actives",
    ),
    NavigationTab(
      contentPane: suggestionScreen(active: false),
      title: "Inactive",
      path: "inactives",
    )
  ],
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.pest_control),
    label: Text('Suggestions'),
  ),
  roles: ['user'],
);
