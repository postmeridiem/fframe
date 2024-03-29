import 'package:example/screens/user_list/screen.dart';
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
  roles: ["Developer"],
  private: true,
);
