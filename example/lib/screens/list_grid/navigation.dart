import 'package:example/themes/config.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:fframe/helpers/l10n.dart';
import 'package:example/screens/list_grid/screen.dart';

final listGridNavigationTarget = NavigationTarget(
  path: "list-grid",
  title: "List Grid",
  // contentPane: const ListGridScreen(
  //   listgridQueryState: ListGridQueryStates.active,
  // ),
  destination: Destination(
    icon: const Icon(Icons.person),
    navigationLabel: () => const Text('List Grid'),
  ),
  roles: ["User", 'UserAdmin', 'SuperAdmin'],
  private: true,
  navigationTabs: [
    NavigationTab(
      title: "Open",
      path: "open",
      private: true,
      contentPane: const ListGridScreen(listgridQueryState: ListGridQueryStates.active),
      destination: Destination(
        icon: Icon(
          Icons.toggle_on,
          color: SignalColors().constAccentColor,
        ),
        navigationLabel: () => Text(L10n.string(
          'suggestions_tab_active',
          placeholder: 'Active',
          namespace: 'global',
        )),
        tabLabel: () => L10n.string(
          'suggestions_tab_active',
          placeholder: 'Active',
          namespace: 'global',
        ),
      ),
    ),
    NavigationTab(
      title: "Done",
      path: "done",
      private: true,
      contentPane: const ListGridScreen(listgridQueryState: ListGridQueryStates.inactive),
      destination: Destination(
        icon: const Icon(Icons.toggle_off_outlined),
        navigationLabel: () => Text(
          L10n.string(
            'suggestions_tab_done',
            placeholder: 'Inactive',
            namespace: 'global',
          ),
        ),
        tabLabel: () => L10n.string(
          'suggestions_tab_done',
          placeholder: 'Inactive',
          namespace: 'global',
        ),
      ),
      roles: ['Developer'],
    ),
    NavigationTab(
      title: "All",
      path: "all",
      private: true,
      contentPane: const ListGridScreen(listgridQueryState: ListGridQueryStates.inactive),
      destination: Destination(
        icon: const Icon(Icons.toggle_off_outlined),
        navigationLabel: () => Text(
          L10n.string(
            'suggestions_tab_all',
            placeholder: 'All',
            namespace: 'global',
          ),
        ),
        tabLabel: () => L10n.string(
          'suggestions_tab_all',
          placeholder: 'All',
          namespace: 'global',
        ),
      ),
      roles: ['Developer'],
    ),
  ],
);
