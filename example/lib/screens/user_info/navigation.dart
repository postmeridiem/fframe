import 'package:example/screens/user_info/user_info.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

final userInfoNavigationTarget = NavigationTarget(
  path: "UserInfo",
  title: "Invite Users",
  contentPane: const CurrentUserInfo(),
  destination: const Destination(
    icon: Icon(Icons.info_outline),
    navigationLabel: Text('Account info'),
  ),
  roles: ['UserAdmin', 'SuperAdmin'],
  private: true,
);
