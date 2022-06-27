import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:example/screens/suggestion/suggestion.dart';

final suggestionNavigationTarget = NavigationTarget(
  path: "suggestions",
  title: "Suggestions",
  contentPane: const SuggestionScreen(),
  destination: const Destination(
    icon: Icon(Icons.pest_control),
    navigationLabel: Text('Suggestions'),
  ),
  roles: ['user'],
  private: true,
  landingPage: true,
  navigationTabs: [
    NavigationTab(
      title: "Active",
      path: "active",
      private: true,
      contentPane: const SuggestionScreen(),
      destination: const Destination(
        icon: Icon(Icons.check_box),
        navigationLabel: Text("Active"),
        tabLabel: "Active",
      ),
    ),
    NavigationTab(
      title: "Done",
      path: "done",
      private: true,
      contentPane: const SuggestionScreen(),
      destination: Destination(
        icon: Icon(
          Icons.check,
          color: Colors.greenAccent[700],
        ),
        navigationLabel: const Text("Done"),
        tabLabel: "Done",
      ),
    ),
    NavigationTab(
      title: "Rejected",
      path: "rejected",
      private: true,
      contentPane: const SuggestionScreen(),
      destination: Destination(
        icon: Icon(
          Icons.not_interested,
          color: Colors.redAccent[700],
        ),
        navigationLabel: const Text("Rejected"),
        tabLabel: "Rejected",
      ),
    ),
  ],
);
