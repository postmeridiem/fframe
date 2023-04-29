import 'package:example/screens/list_grid/screen.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

final listGridNavigationTarget = NavigationTarget(
  path: "list-grid",
  title: "List Grid",
  contentPane: const ListGridScreen(
    listgridQueryState: ListGridQueryStates.active,
  ),
  destination: Destination(
    icon: const Icon(Icons.person),
    navigationLabel: () => const Text('List Grid'),
  ),
  roles: ["User", 'UserAdmin', 'SuperAdmin'],
  private: true,
);
