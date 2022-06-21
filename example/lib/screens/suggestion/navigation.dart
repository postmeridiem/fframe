import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/screens/suggestion/suggestion.dart';

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
    navigationTabs: [
      NavigationTab(
        title: "Active",
        path: "active",
        contentPane: const SuggestionScreen(),
      ),
      NavigationTab(
        title: "Done",
        path: "done",
        contentPane: const SuggestionScreen(),
      ),
      NavigationTab(
        title: "Rejected",
        path: "rejected",
        contentPane: const SuggestionScreen(),
      ),
    ]);
