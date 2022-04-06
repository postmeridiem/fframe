import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:fframe_demo/views/user/user.dart';

final usersNavigationTargets = NavigationTarget(
  path: "users",
  title: "Users",
  navigationTabs: <NavigationTab>[
    NavigationTab(
      contentPane: const UsersScreen(),
      title: "Active",
      path: "active",
    ),
    NavigationTab(
      contentPane: const UsersScreen(),
      title: "Inactive",
      path: "inactive",
    )
  ],
  navigationRailDestination: const NavigationRailDestination(
    icon: Icon(Icons.person),
    label: Text('Users'),
  ),
  roles: ['UserAdmin', 'SuperAdmin'],
);
