import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:example/views/user/user.dart';

final usersNavigationTargets = NavigationTarget(
  path: "users",
  title: "Users",
  navigationTabs: <NavigationTab>[
    NavigationTab(
      contentPane: const UsersScreen(
        isActive: true,
      ),
      title: "Active",
      path: "active",
    ),
    NavigationTab(
      contentPane: const UsersScreen(
        isActive: false,
      ),
      title: "Inactive",
      path: "inactive",
    )
  ],
  navigationRailDestination: const NavigationRailDestination(
    icon: Icon(Icons.person),
    label: Text('Users'),
  ),
  roles: ["User", 'UserAdmin', 'SuperAdmin'],
);
