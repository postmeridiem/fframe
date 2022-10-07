import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:fframe/helpers/l10n.dart';
import 'package:example/screens/suggestion/suggestion.dart';

final suggestionNavigationTarget = NavigationTarget(
  path: "suggestions",
  title: "Suggestions",
  // contentPane: const SuggestionScreen(suggestionQueryState),
  destination: Destination(
    icon: const Icon(Icons.pest_control),
    navigationLabel: Text(
      L10n.string(
        'suggestions',
        placeholder: 'Suggestions',
        namespace: 'global',
      ),
    ),
  ),
  roles: ['user'],
  private: true,
  landingPage: true,
  navigationTabs: [
    NavigationTab(
      title: "Active",
      path: "active",
      private: true,
      contentPane: const SuggestionScreen(
          suggestionQueryState: SuggestionQueryStates.active),
      destination: Destination(
        icon: const Icon(Icons.check_box),
        navigationLabel: Text(L10n.string(
          'suggestions_tab_active',
          placeholder: 'Active (placeholder)',
          namespace: 'global',
        )),
        tabLabel: L10n.string(
          'suggestions_tab_active',
          placeholder: 'Active (placeholder)',
          namespace: 'global',
        ),
      ),
    ),
    NavigationTab(
      title: "Done",
      path: "done",
      private: true,
      contentPane: const SuggestionScreen(
          suggestionQueryState: SuggestionQueryStates.done),
      destination: Destination(
        icon: Icon(
          Icons.check,
          color: Colors.greenAccent[700],
        ),
        navigationLabel: Text(
          L10n.string(
            'suggestions_tab_done',
            placeholder: 'Done (placeholder)',
            namespace: 'global',
          ),
        ),
        tabLabel: L10n.string(
          'suggestions_tab_done',
          placeholder: 'Done (placeholder)',
          namespace: 'global',
        ),
      ),
      // navigationTabs: [ TODO: Allow subtabs
      //   NavigationTab(
      //     title: "Done sub 1",
      //     path: "donesub1",
      //     private: true,
      //     contentPane: const Text("Sub1"),
      //     destination: Destination(
      //       icon: Icon(
      //         Icons.check,
      //         color: Colors.greenAccent[700],
      //       ),
      //       navigationLabel: const Text("Done sub 1"),
      //       tabLabel: "Done sub1",
      //     ),
      //   ),
      //   NavigationTab(
      //     title: "Done sub 2",
      //     path: "donesub2",
      //     private: true,
      //     contentPane: const Text("Sub2"),
      //     destination: Destination(
      //       icon: Icon(
      //         Icons.check,
      //         color: Colors.greenAccent[700],
      //       ),
      //       navigationLabel: const Text("Done sub 2"),
      //       tabLabel: "Done sub2",
      //     ),
      //   ),
      //   NavigationTab(
      //     title: "Done sub 3",
      //     path: "donesub3",
      //     private: true,
      //     contentPane: const Text("Sub3"),
      //     destination: Destination(
      //       icon: Icon(
      //         Icons.check,
      //         color: Colors.greenAccent[700],
      //       ),
      //       navigationLabel: const Text("Done sub 3"),
      //       tabLabel: "Done sub3",
      //     ),
      //   ),
      // ],
    ),
  ],
);
