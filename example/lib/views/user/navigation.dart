import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:example/views/user/user.dart';

final usersNavigationTarget = NavigationTarget(
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
  destination: const Destination(
    icon: Icon(Icons.person),
    label: Text('Users'),
  ),
  roles: ["User", 'UserAdmin', 'SuperAdmin'],
  private: true,
);
