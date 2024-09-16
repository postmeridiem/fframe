import 'package:example/themes/config.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

import 'package:fframe/helpers/l10n.dart';
import 'package:example/screens/customwidget/suggestion.dart';

final customNavigationTarget = NavigationTarget(
  path: "custom",
  title: "CustomWidget",
  // contentPane: const SuggestionScreen(suggestionQueryState),
  destination: Destination(
    icon: const Icon(Icons.pest_control),
    navigationLabel: () => Text(
      L10n.string(
        'custom_suggestions',
        placeholder: 'CustomWidget',
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
      roles: ['developer'],
      contentPane: const SuggestionScreen(suggestionQueryState: SuggestionQueryStates.active),
      destination: Destination(
        icon: Icon(
          Icons.toggle_on,
          color: SignalColors().constAccentColor,
        ),
        navigationLabel: () => Text(L10n.string(
          'suggestions_tab_active',
          placeholder: 'Active (placeholder)',
          namespace: 'global',
        )),
        tabLabel: () => L10n.string(
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
      roles: ["developer"],
      contentPane: const SuggestionScreen(suggestionQueryState: SuggestionQueryStates.done),
      destination: Destination(
        icon: const Icon(Icons.toggle_off_outlined),
        navigationLabel: () => Text(
          L10n.string(
            'suggestions_tab_done',
            placeholder: 'Done (placeholder)',
            namespace: 'global',
          ),
        ),
        tabLabel: () => L10n.string(
          'suggestions_tab_done',
          placeholder: 'Done (placeholder)',
          namespace: 'global',
        ),
      ),
    ),
  ],
);
