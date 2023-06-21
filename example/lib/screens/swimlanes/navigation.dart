import 'package:flutter/material.dart';
import 'package:fframe/fframe.dart';

import 'package:example/screens/swimlanes/screen.dart';

final swimlanesNavigationTarget = NavigationTarget(
  path: "swimlanes",
  title: "Swimlanes",
  contentPane: const SwimlaneScreen(),
  destination: Destination(
    icon: const Icon(Icons.view_week_outlined),
    navigationLabel: () => const Text('Swimlanes'),
  ),
  roles: ["User", 'UserAdmin', 'SuperAdmin'],
  private: true,
);
