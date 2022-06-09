import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/views/suggestion/suggestion.dart';

final suggestionNavigationTarget = NavigationTarget(
  path: "suggestions",
  title: "Suggestions",
  contentPane: const SuggestionScreen(),
  destination: const Destination(
    icon: Icon(Icons.pest_control),
    label: Text('Suggestions'),
  ),
  roles: ['user'],
  private: true,
  landingPage: true,
);
