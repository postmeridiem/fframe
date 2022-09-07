import 'package:example/screens/invite_user/invite_user.dart';
import 'package:fframe/fframe.dart';
import 'package:flutter/material.dart';

final inviteUserNavigationTarget = NavigationTarget(
  path: "inviteusers",
  title: "Invite Users",
  contentPane: const InviteUser(),
  destination: const Destination(
    icon: Icon(Icons.person_add),
    navigationLabel: Text('Invite Users'),
  ),
  roles: ['UserAdmin', 'SuperAdmin'],
  private: true,
);
