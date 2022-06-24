import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/user/user.dart';

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
      destination: Destination(
          icon: Icon(
            Icons.check,
            color: Colors.green.shade900,
          ),
          navigationLabel: const Text("Active"),
          tabLabel: "Active"),
    ),
    NavigationTab(
      contentPane: const UsersScreen(
        isActive: false,
      ),
      title: "Inactive",
      path: "inactive",
      destination: Destination(
          icon: Icon(
            Icons.close,
            color: Colors.redAccent.shade700,
          ),
          navigationLabel: const Text("Inactive"),
          tabLabel: "Inactive"),
    )
  ],
  destination: const Destination(
    icon: Icon(Icons.person),
    navigationLabel: Text('Users'),
  ),
  roles: ["User", 'UserAdmin', 'SuperAdmin'],
  private: true,
);
