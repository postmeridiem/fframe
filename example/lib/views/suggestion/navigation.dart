import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/views/suggestion/suggestion.dart';

final suggestionNavigationTargets = NavigationTarget(
  path: "suggestions",
  title: "Suggestions",
  contentPane: const SuggestionScreen(),
  navigationRailDestination: const NavigationRailDestination(
    icon: Icon(Icons.pest_control),
    label: Text('Suggestions'),
  ),
  roles: ['User'],
);
