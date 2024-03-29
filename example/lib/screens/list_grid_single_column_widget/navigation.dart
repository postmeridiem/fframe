import 'package:example/themes/config.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:fframe/helpers/l10n.dart';
import 'package:example/screens/list_grid_single_column_widget/screen.dart';

final listGridSingleColumnNavigationTarget = NavigationTarget(
  path: "list-grid-single-column-widget",
  title: "List Grid Single Column Widget",
  // contentPane: const ListGridScreen(
  //   listgridQueryState: ListGridQueryStates.active,
  // ),
  destination: Destination(
    icon: const Icon(Icons.person),
    navigationLabel: () => const Text('Single Column List'),
  ),
  roles: ["User", 'UserAdmin', 'SuperAdmin'],
  private: true,
  navigationTabs: [
    NavigationTab(
      title: "Open",
      path: "open",
      private: true,
      contentPane:
          const ListGridScreen(listgridQueryState: ListGridQueryStates.active),
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
      contentPane: const ListGridScreen(
          listgridQueryState: ListGridQueryStates.inactive),
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
  ],
);
