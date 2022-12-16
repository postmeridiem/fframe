import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';
import 'package:example/screens/user/user.dart';

final usersNavigationTarget = NavigationTarget(
  path: "users",
  title: "Users",
  contentPane: const UsersScreen(),
  destination: Destination(
    icon: const Icon(Icons.person),
    navigationLabel: () => const Text('Users'),
  ),
  roles: ["User", 'UserAdmin', 'SuperAdmin'],
  private: true,
);
