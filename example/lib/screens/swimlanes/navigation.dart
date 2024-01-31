// ignore_for_file: unused_import

import 'package:example/themes/config.dart';
import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:fframe/helpers/l10n.dart';
import 'package:example/screens/swimlanes/screen.dart';

final swimlanesNavigationTarget = NavigationTarget(
  path: "swimlanes",
  title: "Swimlanes",
  contentPane: const SwimlanesScreen(
    swimlanesQueryState: SwimlanesQueryStates.active,
  ),
  destination: Destination(
    icon: const Icon(Icons.table_chart_outlined),
    navigationLabel: () => const Text('Swimlanes'),
  ),
  roles: ["User", 'UserAdmin', 'SuperAdmin'],
  private: true,
  // navigationTabs: [
  //   NavigationTab(
  //     title: "Open",
  //     path: "open",
  //     contentPane: const SwimlanesScreen(
  //         swimlanesQueryState: SwimlanesQueryStates.active),
  //     destination: Destination(
  //       icon: Icon(
  //         Icons.table_chart_outlined,
  //         color: SignalColors().constAccentColor,
  //       ),
  //       navigationLabel: () => Text(L10n.string(
  //         'swimlanes_tab_open',
  //         placeholder: 'Open',
  //         namespace: 'global',
  //       )),
  //       tabLabel: () => L10n.string(
  //         'swimlanes_tab_open',
  //         placeholder: 'Open',
  //         namespace: 'global',
  //       ),
  //     ),
  //   ),
  //   NavigationTab(
  //     title: "Archived",
  //     path: "archived",
  //     contentPane: const SwimlanesScreen(
  //         swimlanesQueryState: SwimlanesQueryStates.inactive),
  //     destination: Destination(
  //       icon: const Icon(Icons.inventory_2_outlined),
  //       navigationLabel: () => Text(
  //         L10n.string(
  //           'swimlanes_tab_archived',
  //           placeholder: 'Archived',
  //           namespace: 'global',
  //         ),
  //       ),
  //       tabLabel: () => L10n.string(
  //         'swimlanes_tab_archived',
  //         placeholder: 'Archived',
  //         namespace: 'global',
  //       ),
  //     ),
  //     roles: ['Developer'],
  //   ),
  // ],
);
