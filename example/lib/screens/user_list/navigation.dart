import 'package:example/screens/user_list/screen.dart';
import 'package:example/screens/user_list/user_data.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

final userListNavigationTarget = NavigationTarget(
  path: "user-list",
  title: "User List",
  contentPane: const UserListScreen(),
  destination: Destination(
    icon: const Icon(Icons.person),
    navigationLabel: () => const Text('User List'),
  ),
  roles: ["User", 'UserAdmin', 'SuperAdmin'],
  private: true,
);
