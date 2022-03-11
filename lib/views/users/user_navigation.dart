import 'package:flutter/material.dart';
import 'package:fframe/models/navigationTarget.dart';
import 'package:fframe/views/users/user.dart';

final usersNavigationTargets = NavigationTarget(
  path: "users",
  title: "Users",
  contentPane: UsersScreen(),
  navigationRailDestination: NavigationRailDestination(
    icon: Icon(Icons.person),
    label: Text('Users'),
  ),
  roles: ['user'],
);
